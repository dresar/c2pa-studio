import ImageKit from 'imagekit';
import { env } from './env';

// ─────────────────────────────────────────────
// ImageKit Client Singleton
// ─────────────────────────────────────────────
let imagekitInstance: ImageKit | null = null;

export function getImageKitClient(): ImageKit {
  if (!imagekitInstance) {
    imagekitInstance = new ImageKit({
      publicKey: env.IMAGEKIT_PUBLIC_KEY,
      privateKey: env.IMAGEKIT_PRIVATE_KEY,
      urlEndpoint: env.IMAGEKIT_URL_ENDPOINT,
    });
  }
  return imagekitInstance;
}

export interface ImageKitUploadResult {
  fileId: string;
  url: string;
  filePath: string;
  name: string;
  size: number;
  width?: number;
  height?: number;
  thumbnailUrl?: string;
}
