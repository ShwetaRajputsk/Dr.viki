# Dr. Viki - AI-Powered Wellness App

A Flutter application that provides AI-powered Dosha analysis and wellness guidance.

## Features

- **AI-Powered Dosha Analysis**: Complete analysis flow with questions and results
- **Community Features**: User discussions and wellness sharing
- **Firebase Integration**: Authentication and data storage
- **Multi-language Support**: English and Hindi translations
- **Modern UI**: Beautiful, responsive design with wellness-focused branding

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Firebase project setup
- Groq API key for AI features

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/ShwetaRajputsk/Dr.viki.git
cd Dr.viki
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Environment Variables

Create a `.env` file in the root directory with your API keys:

```env
GROQ_API_KEY=your_groq_api_key_here
```

### 4. Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add your Android and iOS apps to the project
3. Download and place the configuration files:
   - `google-services.json` in `android/app/`
   - `GoogleService-Info.plist` in `ios/Runner/` and `macos/Runner/`

### 5. Run the App

```bash
# For development with environment variables
flutter run --dart-define=GROQ_API_KEY=your_api_key_here

# Or build for production
flutter build apk --dart-define=GROQ_API_KEY=your_api_key_here
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── home_page.dart           # Main home screen
├── disease_detect.dart      # AI Dosha analysis
├── community.dart           # Community features
├── bottom_navigation_bar.dart # Custom navigation
├── services/
│   └── auth_service.dart    # Firebase authentication
└── assets/
    ├── images/              # App images
    ├── fonts/               # Custom fonts
    └── translations/        # Multi-language support
```

## Key Features

### AI Dosha Analysis
- Multi-step questionnaire
- Real-time analysis
- Detailed results with recommendations
- Beautiful UI with animations

### Community
- User discussions
- Wellness sharing
- Real-time updates
- Firebase integration

### Authentication
- Email/password login
- Google Sign-In
- Profile management
- Secure data storage

## Building for Production

### Android APK
```bash
flutter build apk --dart-define=GROQ_API_KEY=your_api_key_here
```

### iOS
```bash
flutter build ios --dart-define=GROQ_API_KEY=your_api_key_here
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please open an issue on GitHub or contact the development team.
