# TextSnap - Text Extraction App

A Flutter mobile application that allows users to extract text from images using OCR (Optical Character Recognition).

## Architecture

This project follows **Clean Architecture** principles with the following layers:

### 📁 Project Structure

```
lib/
├── core/                           # Core utilities and shared code
│   ├── constants/                  # App-wide constants
│   ├── errors/                     # Error handling (failures & exceptions)
│   ├── network/                    # Network utilities
│   ├── theme/                      # App theming
│   └── utils/                      # Validators and helpers
│
├── features/                       # Feature modules
│   ├── auth/                       # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/       # Firebase Auth API calls
│   │   │   ├── models/            # Data models
│   │   │   └── repositories/      # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/          # Business entities (User)
│   │   │   ├── repositories/      # Repository contracts
│   │   │   └── usecases/          # Business logic (SignIn, SignUp, etc.)
│   │   └── presentation/
│   │       ├── bloc/              # State management
│   │       ├── pages/             # UI screens
│   │       └── widgets/           # Reusable widgets
│   │
│   └── text_extraction/           # Text extraction feature (coming soon)
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── injection_container.dart        # Dependency Injection setup
└── main.dart                       # App entry point
```

## Tech Stack

- **Flutter SDK**: ^3.10.7
- **State Management**: BLoC (flutter_bloc)
- **Dependency Injection**: GetIt
- **Firebase**: 
  - firebase_core
  - firebase_auth
  - cloud_firestore
- **Image Handling**: image_picker, image_cropper
- **OCR**: google_mlkit_text_recognition
- **Functional Programming**: dartz (Either pattern)

## Setup Instructions

### 1. Firebase Setup

Before running the app, you need to configure Firebase:

#### Option A: Using FlutterFire CLI (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure Firebase for your Flutter project
flutterfire configure
```

This will automatically:
- Create a Firebase project (or select an existing one)
- Register your app for Android/iOS
- Download the configuration files

#### Option B: Manual Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Add Android and/or iOS app
4. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
5. Place them in the appropriate directories:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### 2. Enable Firebase Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Enable **Email/Password** sign-in method

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

## Features

### ✅ Completed
- Clean Architecture implementation
- Firebase Authentication (Email/Password)
  - Sign Up
  - Sign In
  - Sign Out
  - Auth state persistence
- Form validation
- Loading states
- Error handling
- Custom UI components

### 🚧 In Progress
- Text extraction from images
- Image picker integration
- OCR implementation

### 📋 Planned
- Image cropping
- Extracted text history
- Share extracted text
- Copy to clipboard
- Dark mode

## Design Patterns Used

1. **Clean Architecture** - Separation of concerns across layers
2. **Repository Pattern** - Abstract data layer
3. **BLoC Pattern** - Predictable state management
4. **Dependency Injection** - Loose coupling
5. **Either Pattern** - Functional error handling

## Contributing

This is a personal project, but feel free to fork and modify as needed.

## License

MIT License
