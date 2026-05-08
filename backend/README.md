# Service Provider Backend

NestJS API for the current Flutter service provider app flow.

## Run

```bash
npm install
npm run start:dev
```

The API runs on `http://localhost:3000/api` by default. Set `PORT` to change the port.

## Firebase / Firestore

This backend uses Firebase Admin SDK and Cloud Firestore for persistence.

1. Create a Firebase Admin SDK service account in Firebase Console.
2. Download the JSON key into `backend/serviceAccountKey.json`.
3. Copy `.env.example` to `.env` and set:

```bash
FIREBASE_PROJECT_ID=serviceproviderapp01
GOOGLE_APPLICATION_CREDENTIALS=./serviceAccountKey.json
```

Never commit service account JSON files. They are ignored by `.gitignore`.

On first API use, Firestore is seeded only if each collection is empty. Collections:

- `users`
- `consumers`
- `serviceProviders`
- `requests`
- `feedback`

## Main Endpoints

- `GET /api/health`
- `POST /api/auth/login`
- `GET /api/metadata`
- `GET /api/admin/summary`
- `GET /api/consumers`
- `GET /api/consumers/:id`
- `PATCH /api/consumers/:id`
- `GET /api/service-providers`
- `POST /api/service-providers`
- `GET /api/service-providers/:id`
- `GET /api/service-providers/:id/dashboard`
- `GET /api/requests`
- `POST /api/requests`
- `PATCH /api/requests/:id/status`
- `POST /api/feedback`

## Flutter Flow Mapping

- Admin dashboard: `GET /api/admin/summary`
- All consumers: `GET /api/consumers`
- User details: `GET /api/consumers/:id`, `PATCH /api/consumers/:id`
- Service providers: `GET /api/service-providers`, `POST /api/service-providers`
- Complaints / requests: `GET /api/requests`, `PATCH /api/requests/:id/status`
- Consumer request form: `POST /api/requests`
- Service provider dashboard: `GET /api/service-providers/:id/dashboard`

Data is persisted in Firestore. The current demo records are used only as first-run seed data for empty collections.
