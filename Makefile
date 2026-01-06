# Makefile for Flutter project with FVM
# ========================
# Variables
# ========================
FVM       := fvm
FLUTTER   := fvm flutter
DART      := fvm dart
APP_NAME  := MyApp
.PHONY: help clean get run-dev run-prod build-apk build-ios test format analyze upgrade generate icons rebuild l10n run_flavor
# ========================
# Help commands
# ========================
help:
	@echo "Available commands:"
	@echo "  get               - Install dependencies"
	@echo "  clean             - Clean project"
	@echo "  run-dev           - Run dev with keys (single line)"
	@echo "  run-prod          - Run prod with keys (single line)"
	@echo "  build-apk         - Build APK for production"
	@echo "  build-ios         - Build IPA for production"
	@echo "  test              - Run tests"
	@echo "  format            - Format code"
	@echo "  analyze           - Analyze code"
	@echo "  upgrade           - Update dependencies"
	@echo "  generate          - Generate code (build_runner)"
	@echo "  icons             - Generate icons"
	@echo "  l10n              - Generate localization"
	@echo "  rebuild           - Full rebuild"
	@echo "  run_flavor        - Run flutter_flavorizr"
# ========================
# Basic commands
# ========================
get:
	@echo "Installing dependencies..."
	$(FLUTTER) pub get
clean:
	@echo "Cleaning project..."
	$(FLUTTER) clean
	$(FLUTTER) pub get
# ========================
# Run
# ========================
# Dev run (pass keys in command line)
run-dev:
	$(FLUTTER) run --debug --flavor dev lib/targets/dev.dart \
		--dart-define=SUPABASE_URL=$(SUPABASE_URL) \
		--dart-define=SUPABASE_ANON_KEY=$(SUPABASE_ANON_KEY)
# Prod run (pass keys in command line)
run-prod:
	$(FLUTTER) run --release --flavor prod lib/targets/prod.dart \
		--dart-define=SUPABASE_URL=$(SUPABASE_URL) \
		--dart-define=SUPABASE_ANON_KEY=$(ANON_KEY)
# ========================
# Builds
# ========================
build-apk:
	$(FLUTTER) build apk --release --flavor prod lib/main_prod.dart \
		--dart-define=SUPABASE_URL=$(SUPABASE_URL) \
		--dart-define=SUPABASE_ANON_KEY=$(ANON_KEY)
build-ios:
	$(FLUTTER) build ipa --release --flavor prod lib/main_prod.dart \
		--dart-define=SUPABASE_URL=$(SUPABASE_URL) \
		--dart-define=SUPABASE_ANON_KEY=$(ANON_KEY)
# ========================
# Utilities
# ========================
test:
	$(FLUTTER) test
format:
	$(DART) format .
analyze:
	$(FLUTTER) analyze
upgrade:
	$(FLUTTER) pub upgrade
generate:
	$(DART) run build_runner build --delete-conflicting-outputs
icons:
	$(DART) run flutter_launcher_icons
l10n:
	$(FLUTTER) gen-l10n
rebuild: clean get
	@echo "Full rebuild completed!"
run_flavor:
	$(FLUTTER) pub run flutter_flavorizr