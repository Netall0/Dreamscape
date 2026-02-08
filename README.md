# 💜 Dreamscape

A Flutter application for managing sleep, alarms, and relaxing sounds.

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run
flutter run
```

## 📦 Tech Stack

- **Flutter 3.38.1+** / **Dart 3.10.0+**
- **[flutter_bloc](https://github.com/felangel/bloc)** - state management
- **[Drift](https://github.com/simolus3/drift)** - local SQLite database
- **[GoRouter](https://github.com/flutter/packages/tree/main/packages/go_router)** - declarative navigation
- **[Supabase](https://github.com/supabase/supabase-flutter)** - backend services
- **[Mason](https://github.com/felangel/mason)** - template-based code scaffolding

## 🎨 Features

- Local notifications with timezone support via [flutter_local_notifications](https://github.com/MaikuB/flutter_local_notifications)
- Audio player with [just_audio](https://github.com/ryanheise/just_audio)
- [Lottie](https://github.com/xvrh/lottie-flutter) animations
- Custom icon fonts (AppIcons)
- Drift database for persistent storage
- Supabase cloud integration
- Image picker functionality

## 🛠️ Development Tools

- **[flutter_gen](https://github.com/FlutterGen/flutter_gen)** - asset code generation
- **[drift_dev](https://github.com/simolus3/drift)** - database code generation
- **[build_runner](https://github.com/dart-lang/build)** - build system
- **[flavorizr](https://github.com/AngeloAvv/flutter_flavorizr)** - flavor configuration
- **[mason](https://github.com/felangel/mason)** - code template scaffolding

## 📁 Project Structure

```
lib/
├── core/
│   └── gen/                   # Generated files
    feture/
    └── alarm                  # Alarm features
    └── app                    # Application features
    └── auth                   # Authentication features
    └── home                   # Home features
    └── settings               # Settings features
    └── initialization         # Initialization features
    └── stats                  # Stats features
├── package/
│   └── uikit/        # UI components
└── ...
```

## 🔮 TODO

### 🎯 Critical
- [ ] **Golden Test** - add basic golden tests for main screens


### 🔧 Tech Debt
- [ ] Setup CI/CD pipeline
- [ ] Add comprehensive linter rules
- [ ] Refactor legacy code

### 📚 Documentation
- [ ] API documentation
- [ ] Mason template usage guide

### 😴idc
- [ ] update init flow((List<RECORD>) steps))


---

<p align="center">Made with 💜 by <a href="https://github.com/Netall0">Netall0</a></p>
