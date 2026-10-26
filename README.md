# Flow Board - README

Flow Board is a Flutter application built with Clean Architecture and Cubit
for state management. It is a read-only, staff/exhibition-facing dashboard
that subscribes to the fleet's MQTT traffic (a `#` wildcard, plus
`beta/flowhub/leader/update` and `beta/system/heartbeat/+`) and renders a
live log of every message the fleet exchanges, alongside each device's
online/offline state and the Leader's printer/Caye-connection status. It
does not send any control commands — display only.

## 1. Project Goals

- Show a live, scrolling log of fleet MQTT traffic for debugging/demo.
- Track each fleet device's online/offline state from heartbeat traffic.
- Surface FlowHub Leader's printer/Caye connection state (from
  `beta/flowhub/leader/update`).

## 2. Environment and Requirements

### 2.1 SDK

- Flutter: 3.32.8 (locked in `.fvmrc`)
- Dart SDK: `>=3.8.0 <4.0.0` (from pubspec)

### 2.2 Required Toolchain Versions

- FVM: recommended (for team-wide Flutter version consistency)
- Java (JDK): 17+ (JDK 17 LTS recommended)
- Gradle Wrapper: 8.12 (`android/gradle/wrapper/gradle-wrapper.properties`)
- Android Gradle Plugin (AGP): 8.9.1 (`android/settings.gradle.kts`)
- Kotlin Android Plugin: 2.1.0 (`android/settings.gradle.kts`)
- compileSdk / minSdk / targetSdk: 36 / 23 / 35 (org-wide fleet standard —
  minSdk 23 covers the oldest device in the fleet, an Android 6 FrameTV)

### 2.3 Verify Local Environment

```bash
fvm use 3.32.8
fvm flutter --version
fvm dart --version
java -version
```

Optional Android check:

```bash
cd android
./gradlew -version
```

### 2.4 Core Packages

- flutter_bloc
- get_it + injectable
- freezed
- mqtt_client

## 3. Quick Setup

```bash
fvm use
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter analyze --no-fatal-infos
```

## 4. Testing

```bash
fvm flutter test
```

No real test suite exists yet — only the default `test/widget_test.dart`
scaffold.

## 5. Running by Environment

The project has two real entrypoints:

- Dev: `lib/main_dev.dart`
- Prod: `lib/main_prod.dart`

`lib/main.dart` is the plain Flutter-template default and does **not**
initialize DI — always run via one of the two entrypoints above.

```bash
# Run
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor prod -t lib/main_prod.dart

# Build APK
flutter build apk --flavor dev -t lib/main_dev.dart --debug
flutter build apk --flavor prod -t lib/main_prod.dart --release
```

Both entrypoints: `WidgetsFlutterBinding.ensureInitialized()` →
`LocalSubnetResolver.resolve()` (unawaited — detects this site's subnet so
the broker IP never needs to be re-entered) → `setupLocator(Env.dev()/
Env.prod())` → `runApp(...)`.

Output APK filename: `CafeBeta_FlowBoard_<version>.<buildNumber>-<flavor>.apk`
(see `android/app/build.gradle.kts`'s `applicationVariants.all` block).

## 6. Folder Structure

```text
lib/
  core/
    constants/         # network topics, shared constants
    di/                # get_it + injectable config
    env/               # environment model
  data/
    repositories/       # repository implementations
    sources/
      remote/           # MQTT datasource
  domain/
    entities/           # fleet device, MQTT message entities
    repositories/        # repository contracts
    usecases/            # business use cases
  presentation/
    cubit/               # state management (Cubit + State)
    screens/             # UI screens
    widgets/             # reusable widgets
```

## 7. Project Rules

### 7.1 Clean Architecture

- Presentation calls use cases, not data sources directly.
- Cubit does not access data layer classes directly.
- Domain does not depend on Flutter widgets.

### 7.2 Generated Files

Do not edit directly — edit the source and re-run build_runner:

- `*.freezed.dart`
- `di.config.dart`

### 7.3 index.dart Barrel Export Rule

Each feature/layer folder exposes its public files through `index.dart`.
Add new public files to the matching `index.dart` in the same change.

### 7.4 Version Naming Rule

`pubspec.yaml` version format: `MAJOR.MINOR.DATE+BUILD`

```yaml
version: 0.10.1004+01
```

- `MAJOR`: breaking release line
- `MINOR`: feature milestone line
- `DATE`: release date (`MMDD`)
- `BUILD`: same-day build count — bump by hand before every same-day rebuild

## 8. Common Troubleshooting

### 8.1 App starts but DI is missing

Running `lib/main.dart` does not initialize DI. Use an environment
entrypoint instead:

```bash
flutter run -t lib/main_dev.dart
```

### 8.2 Duplicate injectable registrations

Make sure no two classes are registered as the same abstract type under the
same scope.

## 9. References

- Flutter docs: https://docs.flutter.dev/
- Bloc library: https://bloclibrary.dev/
- Freezed: https://pub.dev/packages/freezed
- Injectable: https://pub.dev/packages/injectable
- GetIt: https://pub.dev/packages/get_it
- mqtt_client: https://pub.dev/packages/mqtt_client
