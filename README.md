📌 Note about web dependency

⚠️ Attention: This project uses Flutter 3.38.1.
The package shared_preferences_web pulls in an incompatible version of web (1.1.1), which breaks Android/iOS builds.
To fix this, we added an override in pubspec.yaml:

dependency_overrides:
  web: 0.5.1


This is a temporary workaround until a compatible version of the package is released.
When updating dependencies, always check for web compatibility first.