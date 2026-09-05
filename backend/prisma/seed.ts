import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('🧹 Cleaning database...');
  await prisma.c2paTemplate.deleteMany();
  await prisma.exportRecord.deleteMany();
  await prisma.imageHistory.deleteMany();
  await prisma.c2paManifest.deleteMany();
  await prisma.imageMetadata.deleteMany();
  await prisma.image.deleteMany();
  await prisma.project.deleteMany();
  await prisma.userSetting.deleteMany();
  await prisma.refreshToken.deleteMany();
  await prisma.user.deleteMany();

  console.log('🌱 Starting database seeding...');

  // Create password hashes
  const adminPasswordHash = await bcrypt.hash('Admin@123456', 12);
  const userPasswordHash = await bcrypt.hash('User@123!', 12);

  // 1. Create Users
  const admin = await prisma.user.create({
    data: {
      email: 'admin@imageprovenance.local',
      username: 'admin',
      passwordHash: adminPasswordHash,
      displayName: 'System Admin',
      isActive: true,
      settings: {
        create: {
          theme: 'dark',
          language: 'en',
          compressionDefault: 'balanced',
          exportFormat: 'jpeg',
          autoScan: true,
          autoSave: true,
          maxUploadSizeMb: 100,
        },
      },
    },
  });
  console.log(`✅ Seeded admin user: ${admin.email}`);

  const sampleUser = await prisma.user.create({
    data: {
      email: 'user@c2pastudio.com',
      username: 'user_c2pa',
      passwordHash: userPasswordHash,
      displayName: 'Eka Wijaya',
      isActive: true,
      settings: {
        create: {
          theme: 'dark',
          language: 'id',
          compressionDefault: 'balanced',
          exportFormat: 'png',
          autoScan: true,
          autoSave: true,
          maxUploadSizeMb: 50,
        },
      },
    },
  });
  console.log(`✅ Seeded regular user: ${sampleUser.email}`);

  // 2. Create Projects for Eka
  const project1 = await prisma.project.create({
    data: {
      userId: sampleUser.id,
      name: 'Verifikasi C2PA Kampanye',
      description: 'Project ini berisi aset-aset gambar digital untuk kampanye pemasaran 2026 yang diverifikasi menggunakan metadata C2PA.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe',
      status: 'ACTIVE',
      totalImages: 2,
      totalSizeBytes: 4084000n,
    },
  });

  const project2 = await prisma.project.create({
    data: {
      userId: sampleUser.id,
      name: 'Arsip Foto Kamera Sony',
      description: 'Foto mentah dari kamera Sony Alpha 7 III dengan geotagging GPS dan Exif utuh.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1452780212940-6f5c0d14d83a',
      status: 'ACTIVE',
      totalImages: 1,
      totalSizeBytes: 2548000n,
    },
  });
  console.log('✅ Seeded projects');

  // 3. Create Images
  // Image 1: C2PA Verified
  const image1 = await prisma.image.create({
    data: {
      projectId: project1.id,
      originalFilename: 'c2pa_verified_banner.png',
      sanitizedFilename: 'c2pa_verified_banner_1783307.png',
      mimeType: 'image/png',
      sizeBytes: 1536000n,
      width: 1200,
      height: 800,
      format: 'png',
      status: 'READY',
      imagekitFileId: 'file_c2pa_banner_123',
      imagekitUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5',
      imagekitPath: '/uploads/c2pa_verified_banner_1783307.png',
      hasExif: true,
      hasIptc: false,
      hasXmp: true,
      hasGps: false,
      hasC2pa: true,
      c2paVerified: true,
    },
  });

  // Image 2: AI Generated with Prompt Info
  const image2 = await prisma.image.create({
    data: {
      projectId: project1.id,
      originalFilename: 'ai_creative_art.png',
      sanitizedFilename: 'ai_creative_art_1783308.png',
      mimeType: 'image/png',
      sizeBytes: 2548000n,
      width: 1024,
      height: 1024,
      format: 'png',
      status: 'READY',
      imagekitFileId: 'file_ai_art_456',
      imagekitUrl: 'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e',
      imagekitPath: '/uploads/ai_creative_art_1783308.png',
      hasExif: false,
      hasIptc: false,
      hasXmp: true,
      hasGps: false,
      hasC2pa: true,
      c2paVerified: true,
    },
  });

  // Image 3: Raw Camera Photo with Exif & GPS
  const image3 = await prisma.image.create({
    data: {
      projectId: project2.id,
      originalFilename: 'jakarta_skyline.jpg',
      sanitizedFilename: 'jakarta_skyline_1783309.jpg',
      mimeType: 'image/jpeg',
      sizeBytes: 2548000n,
      width: 1920,
      height: 1080,
      format: 'jpeg',
      status: 'READY',
      imagekitFileId: 'file_jakarta_sky_789',
      imagekitUrl: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e',
      imagekitPath: '/uploads/jakarta_skyline_1783309.jpg',
      hasExif: true,
      hasIptc: true,
      hasXmp: true,
      hasGps: true,
      hasC2pa: false,
      c2paVerified: null,
    },
  });
  console.log('✅ Seeded images');

  // 4. Create Image Metadata
  await prisma.imageMetadata.create({
    data: {
      imageId: image1.id,
      cameraModel: 'Virtual C2PA Camera',
      cameraMake: 'C2PA Alliance',
      software: 'Adobe Photoshop 2026',
      colorProfile: 'sRGB',
      capturedAt: new Date('2026-05-15T10:30:00Z'),
      exifData: { ColorSpace: 1, Software: 'Adobe Photoshop 2026' },
    },
  });

  await prisma.imageMetadata.create({
    data: {
      imageId: image2.id,
      software: 'Stable Diffusion v2.1',
      capturedAt: new Date('2026-06-01T12:00:00Z'),
      xmpData: { generator: 'Stable Diffusion v2.1', aiModel: 'SD-2.1' },
    },
  });

  await prisma.imageMetadata.create({
    data: {
      imageId: image3.id,
      cameraModel: 'ILCE-7M3 (Sony Alpha 7 III)',
      cameraMake: 'Sony',
      lensModel: 'FE 28-70mm F3.5-5.6 OSS',
      software: 'Sony Camera Firmware 3.10',
      colorProfile: 'sRGB',
      focalLength: '35mm',
      aperture: 'f/8.0',
      shutterSpeed: '1/250s',
      iso: '100',
      capturedAt: new Date('2026-07-01T17:45:00Z'),
      latitude: -6.2088,
      longitude: 106.8456,
      altitude: 12.5,
      exifData: { Make: 'Sony', Model: 'ILCE-7M3', FNumber: 8, ISO: 100, FocalLength: 35 },
      gpsData: { GPSLatitude: -6.2088, GPSLongitude: 106.8456, GPSAltitude: 12.5 },
    },
  });
  console.log('✅ Seeded image metadata');

  // 5. Create C2PA Manifests
  await prisma.c2paManifest.create({
    data: {
      imageId: image1.id,
      isCustom: false,
      isVerified: true,
      creator: 'Digital Provenance Studio',
      organization: 'C2PA Alliance',
      website: 'https://c2pastudio.com',
      license: 'CC BY-NC 4.0',
      copyright: 'Copyright © 2026 Digital Provenance Studio. All rights reserved.',
      generator: 'C2PA Studio v1.0.0',
      timestamp: new Date('2026-05-15T10:35:00Z'),
      manifestJson: {
        active_manifest: 'c2pa_verified_banner_1783307',
        manifests: {
          c2pa_verified_banner_1783307: {
            claim: { assertions: [] },
            signature_info: { issuer: 'DigiCert Trusted G4 Code Signing', time: '2026-05-15T10:35:00Z' },
          },
        },
      },
    },
  });

  await prisma.c2paManifest.create({
    data: {
      imageId: image2.id,
      isCustom: true,
      isVerified: true,
      creator: 'Stable Diffusion AI Generator',
      organization: 'Stability AI',
      website: 'https://stability.ai',
      generator: 'Stable Diffusion WebUI',
      aiModel: 'SDXL 1.0',
      prompt: 'A futuristic city skyline in digital cyberpunk art style, vibrant neon colors, highly detailed, 8k resolution',
      negativePrompt: 'blurry, low quality, photorealistic, bad anatomy',
      timestamp: new Date('2026-06-01T12:00:00Z'),
      manifestJson: {
        generator: 'Stability AI Generator',
        assertions: [
          { label: 'c2pa.training-mining', data: { entries: { '*': { allowed: false } } } },
        ],
      },
    },
  });
  console.log('✅ Seeded C2PA manifests');

  // 6. Create C2PA Templates for Eka
  await prisma.c2paTemplate.create({
    data: {
      userId: sampleUser.id,
      name: 'Template Atribusi Standar',
      creator: 'Eka Wijaya Studio',
      organization: 'Eka Wijaya Photography',
      website: 'https://ekawijaya.com',
      license: 'CC BY-SA 4.0',
      copyright: 'Copyright © 2026 Eka Wijaya. All rights reserved.',
      isDefault: true,
    },
  });

  await prisma.c2paTemplate.create({
    data: {
      userId: sampleUser.id,
      name: 'Template Gambar AI-Attribution',
      creator: 'Eka Wijaya AI Workspace',
      organization: 'Eka Wijaya Labs',
      generator: 'Stable Diffusion v2.1',
      aiModel: 'SD-2.1-custom-finetuned',
      workflow: 'Text-to-Image Generation',
      source: 'AI Generator Pipeline',
      isDefault: false,
    },
  });
  console.log('✅ Seeded templates');

  // 7. Create Image History Records
  await prisma.imageHistory.create({
    data: {
      imageId: image1.id,
      action: 'UPLOADED',
      description: 'Gambar berhasil diunggah ke ImageKit.',
    },
  });

  await prisma.imageHistory.create({
    data: {
      imageId: image1.id,
      action: 'C2PA_CREATED',
      description: 'Tanda tangan digital C2PA terdeteksi dan berhasil diverifikasi.',
    },
  });

  await prisma.imageHistory.create({
    data: {
      imageId: image3.id,
      action: 'UPLOADED',
      description: 'Foto mentah dari kamera diunggah.',
    },
  });

  await prisma.imageHistory.create({
    data: {
      imageId: image3.id,
      action: 'METADATA_SCANNED',
      description: 'Metadata EXIF dan GPS berhasil di-scan dari koordinat Jakarta.',
    },
  });
  console.log('✅ Seeded image history');

  console.log('🎉 Database seeding completed successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
