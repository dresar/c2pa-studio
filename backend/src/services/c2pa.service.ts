import fs from 'fs';
import path from 'path';
import { exec } from 'child_process';
import util from 'util';
import { logger } from '../utils/logger';
import { AppError } from '../utils/errors';
import { env } from '../config/env';

const execPromise = util.promisify(exec);

// ─────────────────────────────────────────────
// C2PA Service
// ─────────────────────────────────────────────

export interface C2paCheckResult {
  hasC2pa: boolean;
  isVerified: boolean | null;
  manifests?: C2paManifestData[];
  error?: string;
}

export interface C2paManifestData {
  title?: string;
  format?: string;
  claim?: {
    producer?: string;
    instanceId?: string;
    claimGenerator?: string;
  };
  assertions?: C2paAssertion[];
  signature?: {
    issuer?: string;
    time?: string;
    algorithm?: string;
  };
  aiInfo?: {
    generator?: string;
    prompt?: string;
    model?: string;
  };
  timestamp?: string;
}

export interface C2paAssertion {
  label: string;
  data: Record<string, unknown>;
}

export interface CustomC2paInput {
  creator?: string;
  organization?: string;
  website?: string;
  license?: string;
  copyright?: string;
  generator?: string;
  aiModel?: string;
  prompt?: string;
  negativePrompt?: string;
  workflow?: string;
  source?: string;
}

export class C2paService {
  private c2paAvailable = false;
  private c2patoolAvailable = false;

  constructor() {
    this.checkC2paAvailability();
  }

  private async checkC2paAvailability(): Promise<void> {
    try {
      // Dynamic require — won't crash if not installed
      require('c2pa-node');
      this.c2paAvailable = true;
      logger.info('✅ c2pa-node is available');
    } catch {
      logger.warn(
        '⚠️  c2pa-node not installed. Checking for c2patool CLI...',
      );
      try {
        await execPromise('c2patool --version');
        this.c2patoolAvailable = true;
        logger.info('✅ c2patool CLI is available');
      } catch {
        logger.warn(
          '⚠️  c2patool CLI not found in PATH. C2PA features will use basic sidecar fallback.',
        );
      }
    }
  }

  // ─────────────────────────────────────────────
  // Detect and read C2PA manifest from file
  // ─────────────────────────────────────────────
  async read(filePath: string): Promise<C2paCheckResult> {
    if (!this.c2paAvailable) {
      if (this.c2patoolAvailable) {
        return this.cliRead(filePath);
      }
      return this.fallbackRead(filePath);
    }

    try {
      const { createC2pa } = require('c2pa-node');
      const c2pa = createC2pa();
      const result = await c2pa.read({ path: filePath });

      if (!result) {
        return { hasC2pa: false, isVerified: null };
      }

      const manifests: C2paManifestData[] = [];

      if (result.active_manifest) {
        manifests.push(this.parseManifest(result.active_manifest));
      }

      return {
        hasC2pa: true,
        isVerified: result.validation_status === 'valid',
        manifests,
      };
    } catch (error) {
      logger.error({ err: error, filePath }, 'C2PA read failed');
      return {
        hasC2pa: false,
        isVerified: null,
        error: 'Failed to read C2PA manifest',
      };
    }
  }

  // ─────────────────────────────────────────────
  // Remove C2PA manifest from file
  // Result: new file path with manifest stripped
  // ─────────────────────────────────────────────
  async remove(inputPath: string, outputPath: string): Promise<void> {
    if (!this.c2paAvailable) {
      if (this.c2patoolAvailable) {
        try {
          // Try running c2patool with remote flag or no manifest to strip/rewrite
          await execPromise(`c2patool "${inputPath}" --output "${outputPath}"`);
          return;
        } catch (err) {
          logger.warn({ err }, 'c2patool remove failed, falling back to copying');
        }
      }
      // Fallback: copy file as-is (can't strip without SDK)
      await fs.promises.copyFile(inputPath, outputPath);
      logger.warn('c2pa-node & c2patool unavailable — file copied without C2PA removal');
      return;
    }

    try {
      const { createC2pa } = require('c2pa-node');
      const c2pa = createC2pa();
      await c2pa.sign({
        asset: { path: inputPath },
        thumbnail: null,
        signer: null,
        outputPath,
      });
    } catch {
      // If c2pa-node doesn't support direct removal, copy file
      await fs.promises.copyFile(inputPath, outputPath);
      logger.warn('C2PA removal via c2pa-node unavailable — fallback copy used');
    }
  }

  // ─────────────────────────────────────────────
  // Create custom C2PA manifest and embed it
  // ─────────────────────────────────────────────
  async createCustom(
    inputPath: string,
    outputPath: string,
    input: CustomC2paInput,
  ): Promise<C2paManifestData> {
    if (!this.c2paAvailable) {
      if (this.c2patoolAvailable) {
        return this.cliCreateCustom(inputPath, outputPath, input);
      }
      // Generate a JSON manifest and embed as sidecar reference
      const manifest = this.buildManifestJson(input);
      const sidecarPath = outputPath.replace(/\.[^.]+$/, '.c2pa.json');
      await fs.promises.writeFile(sidecarPath, JSON.stringify(manifest, null, 2));
      await fs.promises.copyFile(inputPath, outputPath);
      logger.warn('c2pa-node & c2patool unavailable — manifest saved as sidecar JSON');
      return manifest;
    }

    try {
      const { createC2pa, ManifestBuilder } = require('c2pa-node');
      const c2pa = createC2pa();

      const manifest = new ManifestBuilder({
        claim_generator: input.generator ?? 'Image Provenance Studio',
        format: path.extname(inputPath).replace('.', ''),
        title: path.basename(inputPath),
        assertions: this.buildAssertions(input),
      });

      await c2pa.sign({
        asset: { path: inputPath },
        manifest,
        outputPath,
        signer: null,
      });

      return this.buildManifestJson(input);
    } catch (error) {
      logger.error({ err: error, inputPath }, 'C2PA creation failed');
      throw new AppError('Failed to create C2PA manifest', 500, 'C2PA_CREATE_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // CLI Helper methods for c2patool
  // ─────────────────────────────────────────────
  private async cliRead(filePath: string): Promise<C2paCheckResult> {
    try {
      const { stdout } = await execPromise(`c2patool "${filePath}"`);
      const raw = JSON.parse(stdout);
      
      const manifests: C2paManifestData[] = [];
      if (raw.active_manifest) {
        manifests.push(this.parseManifest(raw.active_manifest));
      } else if (raw.manifests) {
        const keys = Object.keys(raw.manifests);
        if (keys.length > 0) {
          manifests.push(this.parseManifest(raw.manifests[keys[0]]));
        }
      }

      return {
        hasC2pa: manifests.length > 0,
        isVerified: raw.validation_status === 'valid' || raw.validation_status === undefined,
        manifests,
      };
    } catch (error: any) {
      if (error.stdout) {
        try {
          const raw = JSON.parse(error.stdout);
          if (raw.error === 'no_manifests') {
            return { hasC2pa: false, isVerified: null };
          }
        } catch {}
      }
      return this.fallbackRead(filePath);
    }
  }

  private async cliCreateCustom(
    inputPath: string,
    outputPath: string,
    input: CustomC2paInput,
  ): Promise<C2paManifestData> {
    const tempManifestPath = path.join(
      env.TEMP_DIR,
      `manifest_${Date.now()}_${Math.random().toString(36).slice(2)}.json`
    );

    try {
      const assertions = this.buildAssertions(input).map(a => ({
        label: a.label,
        data: a.data
      }));

      const manifestDef = {
        claim_generator: input.generator ?? 'Image Provenance Studio',
        assertions
      };

      await fs.promises.writeFile(tempManifestPath, JSON.stringify(manifestDef, null, 2));
      await execPromise(`c2patool "${inputPath}" --manifest "${tempManifestPath}" --output "${outputPath}"`);

      return this.buildManifestJson(input);
    } catch (error) {
      logger.error({ err: error, inputPath }, 'c2patool CLI custom creation failed');
      const manifest = this.buildManifestJson(input);
      const sidecarPath = outputPath.replace(/\.[^.]+$/, '.c2pa.json');
      await fs.promises.writeFile(sidecarPath, JSON.stringify(manifest, null, 2));
      await fs.promises.copyFile(inputPath, outputPath);
      return manifest;
    } finally {
      await fs.promises.unlink(tempManifestPath).catch(() => {});
    }
  }

  // ─────────────────────────────────────────────
  // Fallback: scan for C2PA JUMBF box in raw bytes
  // ─────────────────────────────────────────────
  private async fallbackRead(filePath: string): Promise<C2paCheckResult> {
    try {
      const buffer = await fs.promises.readFile(filePath);
      // C2PA data is stored in a JUMBF box with label "c2pa"
      const c2paSignature = Buffer.from('6332706100', 'hex'); // 'c2pa\0'
      const hasC2pa = buffer.includes(c2paSignature);

      return {
        hasC2pa,
        isVerified: null,
        error: hasC2pa
          ? 'C2PA detected but full parsing requires c2pa-node'
          : undefined,
      };
    } catch {
      return { hasC2pa: false, isVerified: null };
    }
  }

  // ─────────────────────────────────────────────
  // Parse native c2pa-node manifest structure
  // ─────────────────────────────────────────────
  private parseManifest(raw: Record<string, unknown>): C2paManifestData {
    return {
      title: (raw.title as string) ?? undefined,
      format: (raw.format as string) ?? undefined,
      claim: {
        producer: (raw.claim_generator as string) ?? undefined,
      },
      assertions: Array.isArray(raw.assertions)
        ? (raw.assertions as any[]).map((a) => ({
            label: a.label,
            data: a.data ?? {},
          }))
        : [],
      timestamp: (raw.signature_info as any)?.time ?? undefined,
    };
  }

  // ─────────────────────────────────────────────
  // Build assertions array for manifest creation
  // ─────────────────────────────────────────────
  private buildAssertions(input: CustomC2paInput): C2paAssertion[] {
    const assertions: C2paAssertion[] = [];

    if (input.creator || input.organization) {
      assertions.push({
        label: 'c2pa.actions',
        data: {
          actions: [
            {
              action: 'c2pa.created',
              softwareAgent: input.generator ?? 'Image Provenance Studio',
            },
          ],
        },
      });
    }

    if (input.aiModel || input.prompt || input.generator) {
      assertions.push({
        label: 'c2pa.training-mining',
        data: {
          entries: {
            'c2pa.ai.generative': {
              use: 'notAllowed',
            },
          },
        },
      });
    }

    if (input.copyright) {
      assertions.push({
        label: 'stds.exif',
        data: { Copyright: input.copyright },
      });
    }

    return assertions;
  }

  // ─────────────────────────────────────────────
  // Build a plain JSON manifest object
  // ─────────────────────────────────────────────
  private buildManifestJson(input: CustomC2paInput): C2paManifestData {
    return {
      claim: {
        producer: input.creator,
        claimGenerator: input.generator ?? 'Image Provenance Studio',
      },
      assertions: this.buildAssertions(input),
      aiInfo:
        input.aiModel || input.prompt
          ? {
              generator: input.generator,
              prompt: input.prompt,
              model: input.aiModel,
            }
          : undefined,
      timestamp: new Date().toISOString(),
    };
  }
}
