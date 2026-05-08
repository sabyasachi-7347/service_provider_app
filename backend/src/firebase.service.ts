import { Injectable } from '@nestjs/common';
import {
  ServiceAccount,
  applicationDefault,
  cert,
  getApps,
  initializeApp,
} from 'firebase-admin/app';
import { Firestore, getFirestore } from 'firebase-admin/firestore';

@Injectable()
export class FirebaseService {
  readonly db: Firestore;

  constructor() {
    if (getApps().length === 0) {
      initializeApp(this.getFirebaseOptions());
    }

    this.db = getFirestore();
  }

  private getFirebaseOptions() {
    const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;

    if (serviceAccountJson) {
      const serviceAccount = JSON.parse(serviceAccountJson) as ServiceAccount & {
        project_id?: string;
        private_key?: string;
      };

      if (serviceAccount.private_key) {
        serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, '\n');
      }

      return {
        credential: cert(serviceAccount),
        projectId: serviceAccount.project_id ?? process.env.FIREBASE_PROJECT_ID,
      };
    }

    return {
      credential: applicationDefault(),
      projectId: process.env.FIREBASE_PROJECT_ID,
    };
  }
}
