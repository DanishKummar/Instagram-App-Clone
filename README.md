# 📸 Instagram Clone — Flutter Social Media App

A feature-rich **Instagram-inspired social media application** built with Flutter and Dart. The project combines Firebase for authentication and real-time data management with Supabase for media storage, providing a foundation for a modern social networking experience.

The app includes social features such as posts, stories, reels, user profiles, following, likes, comments, and media sharing.

## ✨ Features

- **User Authentication** — Sign up, log in, and recover forgotten passwords using Firebase Authentication.
- **Home Feed** — Browse posts shared by users.
- **Stories** — Upload and view user stories.
- **Reels** — Explore short-form video content.
- **Create Posts** — Work with image and other media content.
- **Likes and Comments** — Interact with posts and reels.
- **Follow System** — Follow users and build a social network.
- **User Profiles** — View profile information and user content.
- **Search** — Discover users and explore content.
- **Media Storage** — Use Supabase for storing and retrieving media files.
- **Audio Playback** — Support audio playback for media content.
- **Share Posts** — Share content using links and dynamic-link functionality.
- **Dark and Light Themes** — Switch between different app appearances.
- **Responsive UI** — Use Flutter ScreenUtil for adapting layouts to different screen sizes.
- **State Management** — Manage application state with GetX.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Application programming language |
| Firebase Authentication | User authentication |
| Cloud Firestore | User data and social content |
| Supabase | Media storage and retrieval |
| GetX | State management and navigation |
| Flutter ScreenUtil | Responsive UI scaling |
| Image Picker | Selecting images from the device |
| File Picker | Selecting files |
| Video Player | Video playback |
| Just Audio | Audio playback |
| Cached Network Image | Efficient image loading and caching |
| Share Plus | Sharing content |
| Lottie | Animations |

## 🏗️ Architecture

The project follows a modular structure that separates UI screens, reusable components, controllers, and data models.

```text
lib/
├── Components/       # Reusable UI components
├── Controllers/      # State management and app logic
├── Customs/          # Custom UI elements
├── Models/           # Data models
├── Sections/         # Feature-specific UI sections
├── Views/            # Application screens
├── services/         # Application services
├── firebase_options.dart
└── main.dart         # Application entry point
```

This structure helps keep the code organized and makes individual features easier to maintain and extend.

## 🚀 Getting Started

Follow these steps to run the project locally.

### Prerequisites

Make sure you have installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/)
- A Firebase project
- A Supabase project

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
```

Navigate to the project directory:

```bash
cd YOUR_REPOSITORY
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

1. Create a project in the [Firebase Console](https://console.firebase.google.com/).
2. Register your Android or iOS application.
3. Enable Firebase Authentication and configure the required sign-in methods.
4. Create a Cloud Firestore database.
5. Configure Firebase for Flutter using the [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup).

Ensure that the generated Firebase configuration matches your application.

### 4. Configure Supabase

1. Create a project in the [Supabase Dashboard](https://supabase.com/dashboard).
2. Configure the storage bucket or buckets required by your application.
3. Set the Supabase project URL and appropriate publishable/anonymous client key in your app's configuration.

**Security note:** Never commit private API keys, service-role keys, passwords, or other secrets to GitHub. Use environment-based configuration where appropriate and configure access policies for your storage buckets.

### 5. Run the application

Connect an Android device or start an emulator, then execute:

```bash
flutter run
```

To check your Flutter installation:

```bash
flutter doctor
```

## 🔐 Security and Configuration

Before running the application, verify that:

- Firebase Authentication is configured correctly.
- Firestore security rules restrict access to authorized data.
- Supabase Storage policies control who can upload, read, or delete files.
- Any required configuration values are supplied securely.
- No private credentials are included in the repository.

The application requires valid backend configuration to use its online features.

## 📱 Screens and Modules

The project includes screens and modules for:

- Authentication and account recovery
- Home feed
- User profiles
- Search and user discovery
- Posts and comments
- Stories
- Reels
- Media uploading and playback
- Post and reel sharing
- Theme management

## 🎯 Project Goals

This project was developed to practice and demonstrate:

- Cross-platform mobile development with Flutter
- Firebase authentication and database integration
- Cloud media storage using Supabase
- State management using GetX
- Building reusable and modular UI components
- Implementing common social networking features
- Integrating image, video, and audio content
- Managing application navigation and user interactions

## 🔮 Future Improvements

Potential improvements include:

- Push notifications
- Direct messaging and real-time chat
- Improved content recommendations
- Pagination and feed performance optimization
- Enhanced search and filtering
- Automated tests and CI/CD
- Improved security rules and error handling

## 👨‍💻 Author

**Danish**

Computer Systems Engineering Student | Flutter Developer | Data Science Enthusiast

- GitHub: [@DanishKummar](https://github.com/DanishKummar)
- LinkedIn: [Connect with me](https://www.linkedin.com/in/danish-kumar-859b4a283/)

---

⭐ If you find this project interesting, consider giving the repository a star!
---

⭐ If you find this project interesting, consider giving the repository a star!

## 📄 License

This project is intended for educational and portfolio purposes. Add a `LICENSE` file to the repository if you want to specify the terms under which others may use, modify, or distribute your code.

---

⭐ If you find this project interesting, consider giving the repository a star!
