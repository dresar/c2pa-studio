# Image Provenance Studio

Image Provenance Studio is an enterprise-grade workspace for managing image metadata, compression, and Content Credentials (C2PA). It features a modern, responsive Flutter frontend and a robust Node.js/Fastify backend.

## 🚀 Features

- **C2PA Integration:** View, verify, and inject C2PA Content Credentials.
- **Advanced Processing:** Compress, resize, and convert images (JPEG, PNG, WebP, TIFF).
- **Metadata Management:** Read and remove EXIF, IPTC, and GPS data.
- **Projects & Workspaces:** Organize your image workflow efficiently.
- **Enterprise Grade Backend:** Fastify + Prisma + PostgreSQL + Redis/BullMQ.

## 🛠️ Tech Stack

### Frontend (Flutter)
- **Framework:** Flutter (Web, Desktop, Mobile)
- **State Management:** Riverpod & Freezed
- **Routing:** GoRouter
- **Networking:** Dio
- **UI:** Custom Glassmorphism Theme, Responsive Framework, Flutter Animate

### Backend (Node.js)
- **Framework:** Fastify (TypeScript)
- **Database:** PostgreSQL (via Prisma)
- **Queue/Workers:** BullMQ + Redis
- **Image Processing:** Sharp, ExifTool, C2PA-Node
- **Storage:** Local + ImageKit

---

## 🏃 Getting Started

### 1. Running the Backend

Ensure you have PostgreSQL and Redis running.

```bash
cd backend
npm install
# Configure your .env (see .env.example)
npx prisma migrate dev
npm run dev
```

### 2. Running the Frontend (Flutter)

```bash
cd flutter_app
flutter pub get
# Run code generation if needed
dart run build_runner build -d
# Run the app (Desktop or Web recommended)
flutter run -d windows # or macOS/linux/chrome
```

## 📦 Deployment

The backend is configured to bundle into a single `app.js` via `tsup`, making it easy to deploy to environments like cPanel Node.js App Manager. Please check the `deployment_guide.md` in the artifacts directory for more details.

## 📄 License
Internal proprietary software.
