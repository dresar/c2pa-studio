import { ExifTool, Tags } from 'exiftool-vendored';
import { logger } from '../utils/logger';
import { AppError } from '../utils/errors';

// ─────────────────────────────────────────────
// Metadata Engine — reads EXIF, IPTC, XMP, GPS, ICC
// Uses exiftool-vendored (production quality, battle-tested)
// ─────────────────────────────────────────────

export interface ParsedMetadata {
  exif: Record<string, unknown>;
  iptc: Record<string, unknown>;
  xmp: Record<string, unknown>;
  gps: GpsData | null;
  icc: Record<string, unknown>;

  // Parsed highlights
  cameraModel?: string;
  cameraMake?: string;
  lensModel?: string;
  software?: string;
  colorProfile?: string;
  focalLength?: string;
  aperture?: string;
  shutterSpeed?: string;
  iso?: string;
  capturedAt?: Date;
  modifiedAt?: Date;

  // Flags
  hasExif: boolean;
  hasIptc: boolean;
  hasXmp: boolean;
  hasGps: boolean;
  hasIcc: boolean;
}

export interface GpsData {
  latitude: number;
  longitude: number;
  altitude?: number;
  latitudeRef?: string;
  longitudeRef?: string;
}

// ─────────────────────────────────────────────
// Singleton ExifTool process
// ─────────────────────────────────────────────
let exiftoolInstance: ExifTool | null = null;

function getExifTool(): ExifTool {
  if (!exiftoolInstance) {
    exiftoolInstance = new ExifTool({ taskTimeoutMillis: 10_000 });
  }
  return exiftoolInstance;
}

export async function destroyExifTool(): Promise<void> {
  if (exiftoolInstance) {
    await exiftoolInstance.end();
    exiftoolInstance = null;
  }
}

export class MetadataService {
  // ─────────────────────────────────────────────
  // Parse all metadata from a file
  // ─────────────────────────────────────────────
  async parse(filePath: string): Promise<ParsedMetadata> {
    const exiftool = getExifTool();

    try {
      const tags: Tags = await exiftool.read(filePath);

      const gps = this.extractGps(tags);

      const exifFields = this.extractGroup(tags, [
        'Make', 'Model', 'LensModel', 'FocalLength', 'Aperture',
        'ShutterSpeedValue', 'ExposureTime', 'ISO', 'Flash', 'WhiteBalance',
        'ExposureMode', 'MeteringMode', 'ExifImageWidth', 'ExifImageHeight',
        'BitsPerSample', 'ColorSpace',
      ]);

      const iptcFields = this.extractGroup(tags, [
        'Caption-Abstract', 'ObjectName', 'Keywords', 'Category',
        'SupplementalCategories', 'CopyrightNotice', 'Credit', 'Source',
        'City', 'ProvinceState', 'CountryName',
      ]);

      const xmpFields = this.extractGroup(tags, [
        'XMPToolkit', 'Creator', 'Rights', 'Subject', 'Description',
        'Title', 'Rating', 'Label', 'CreateDate', 'ModifyDate',
        'CreatorTool', 'DocumentID', 'InstanceID',
      ]);

      const iccFields = this.extractGroup(tags, [
        'ProfileDescription', 'ProfileClass', 'ColorSpaceData',
        'ProfileConnectionSpace', 'ProfileFileSignature',
      ]);

      return {
        exif: exifFields,
        iptc: iptcFields,
        xmp: xmpFields,
        gps,
        icc: iccFields,

        cameraModel: tags.Model?.toString(),
        cameraMake: tags.Make?.toString(),
        lensModel: tags.LensModel?.toString(),
        software: tags.Software?.toString(),
        colorProfile: tags.ProfileDescription?.toString(),
        focalLength: tags.FocalLength?.toString(),
        aperture: tags.Aperture?.toString() ?? tags.FNumber?.toString(),
        shutterSpeed: tags.ExposureTime?.toString() ?? tags.ShutterSpeedValue?.toString(),
        iso: tags.ISO?.toString(),
        capturedAt: tags.DateTimeOriginal ? new Date(tags.DateTimeOriginal.toString()) : undefined,
        modifiedAt: tags.FileModifyDate ? new Date(tags.FileModifyDate.toString()) : undefined,

        hasExif: Object.keys(exifFields).length > 0,
        hasIptc: Object.keys(iptcFields).length > 0,
        hasXmp: Object.keys(xmpFields).length > 0,
        hasGps: gps !== null,
        hasIcc: Object.keys(iccFields).length > 0,
      };
    } catch (error) {
      logger.error({ err: error, filePath }, 'Failed to parse metadata');
      throw new AppError('Metadata parsing failed', 500, 'METADATA_PARSE_ERROR');
    }
  }

  // ─────────────────────────────────────────────
  // Extract GPS coordinates
  // ─────────────────────────────────────────────
  private extractGps(tags: Tags): GpsData | null {
    if (tags.GPSLatitude === undefined || tags.GPSLongitude === undefined) {
      return null;
    }

    const lat = typeof tags.GPSLatitude === 'number' ? tags.GPSLatitude : parseFloat(String(tags.GPSLatitude));
    const lon = typeof tags.GPSLongitude === 'number' ? tags.GPSLongitude : parseFloat(String(tags.GPSLongitude));

    if (isNaN(lat) || isNaN(lon)) return null;

    const latRef = tags.GPSLatitudeRef?.toString();
    const lonRef = tags.GPSLongitudeRef?.toString();

    return {
      latitude: latRef === 'S' ? -Math.abs(lat) : lat,
      longitude: lonRef === 'W' ? -Math.abs(lon) : lon,
      altitude: tags.GPSAltitude ? parseFloat(String(tags.GPSAltitude)) : undefined,
      latitudeRef: latRef,
      longitudeRef: lonRef,
    };
  }

  // ─────────────────────────────────────────────
  // Extract specific tags into a plain object
  // ─────────────────────────────────────────────
  private extractGroup(tags: Tags, keys: string[]): Record<string, unknown> {
    const result: Record<string, unknown> = {};
    for (const key of keys) {
      const val = (tags as Record<string, unknown>)[key];
      if (val !== undefined && val !== null) {
        result[key] = typeof val === 'object' ? JSON.parse(JSON.stringify(val)) : val;
      }
    }
    return result;
  }
}
