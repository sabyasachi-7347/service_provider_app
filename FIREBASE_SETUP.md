# Firebase Setup Instructions for Service Provider App

## Current Status
I've set up the basic Firebase structure for your Flutter app, but due to connectivity issues with Firebase CLI, you'll need to complete the setup manually through the Firebase Console.

## What I've Already Done
1. ✅ Added Firebase dependencies to `pubspec.yaml`
2. ✅ Created `firebase_options.dart` with placeholder configuration
3. ✅ Modified `main.dart` to initialize Firebase
4. ✅ Created `.firebaserc` and `firebase.json` files
5. ✅ Created `FirebaseAuthService` for authentication
6. ✅ Installed Flutter dependencies

## Next Steps - Complete Firebase Setup

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "Service Provider App"
4. Project ID: `serviceproviderapp01`
5. Enable Google Analytics (optional)

### Step 2: Configure Android App
1. In Firebase Console, click "Add app" → Android
2. Package name: `com.example.service_provider_app`
3. App nickname: "Service Provider App Android"
4. Download `google-services.json`
5. Place it in `android/app/` folder
6. Add to `android/app/build.gradle.kts`:
   ```kotlin
   plugins {
       // ... existing plugins
       id("com.google.gms.google-services")
   }
   ```
7. Add to `android/build.gradle.kts`:
   ```kotlin
   dependencies {
       classpath("com.google.gms:google-services:4.4.0")
   }
   ```

### Step 3: Configure iOS App (if needed)
1. In Firebase Console, click "Add app" → iOS
2. Bundle ID: `com.example.serviceProviderApp`
3. App nickname: "Service Provider App iOS"
4. Download `GoogleService-Info.plist`
5. Add it to `ios/Runner/` folder via Xcode (not just file system)

### Step 4: Configure Web App (if needed)
1. In Firebase Console, click "Add app" → Web
2. App nickname: "Service Provider App Web"
3. Copy the Firebase config object

### Step 5: Update firebase_options.dart
Replace the placeholder values in `lib/firebase_options.dart` with actual values from Firebase Console:

```dart
// Replace YOUR_*_API_KEY, YOUR_*_APP_ID, etc. with actual values
```

### Step 6: Enable Authentication
1. In Firebase Console, go to Authentication
2. Click "Get started"
3. Enable sign-in methods:
   - Email/Password
   - Phone (for OTP)

### Step 7: Set up Firestore Database
1. In Firebase Console, go to Firestore Database
2. Click "Create database"
3. Start in test mode (or set up security rules)
4. Choose a location close to your users

## Retry FlutterFire Configure
After creating the project in Firebase Console, try running:
```bash
dart pub global run flutterfire_cli:flutterfire configure --project=serviceproviderapp01
```

This should now work and automatically update your configuration files.

## Testing the Setup
Once configured, you can test Firebase integration:
```bash
flutter run
```

The app should start without Firebase-related errors.

## Available Firebase Services
The app is now set up with:
- **Firebase Auth**: For user authentication
- **Cloud Firestore**: For database operations
- **Firebase Storage**: For file uploads
- **FirebaseAuthService**: Custom service class for authentication operations

## Need Help?
If you encounter issues:
1. Check the Firebase Console for any setup warnings
2. Ensure `google-services.json` is in the correct location
3. Verify package names match between Firebase Console and your app
4. Check that Firebase project is active and not suspended

## Security Rules
Don't forget to set up proper Firestore security rules before deploying to production!
