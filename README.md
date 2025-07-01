# Pomodoro App

A modern, cross-platform Pomodoro timer app built with Flutter. Stay focused, boost your productivity, and track your work and break sessions with ease.

## Features

- **Pomodoro Timer:** Start, pause, and reset customizable Pomodoro sessions.
- **Breaks:** Automatic short and long breaks between focus sessions.
- **Statistics:** Track your focus and break history with beautiful charts.
- **To-Do List:** Manage your daily tasks and mark them as completed.
- **Motivational Quotes:** Get inspired with a new quote every session.
- **Notifications:** Receive notifications when your Pomodoro or break ends (with vibration support).
- **Settings:** Change timer durations, enable/disable notifications, keep screen on, and more.
- **Dark & Light Theme:** Enjoy a beautiful interface in both light and dark modes.
- **Localization:** Supports English and Turkish languages.

## Screenshots

> _Add your screenshots here_

## Getting Started

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) (3.0 or higher recommended)
- Android Studio or Xcode (for mobile builds)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/pomodoro_app.git
   cd pomodoro_app
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```

### Building for Release

- **Android (AAB):**
  ```bash
  flutter build appbundle
  # Output: build/app/outputs/bundle/release/app-release.aab
  ```
- **iOS:**
  ```bash
  flutter build ios
  ```

## Folder Structure

- `lib/` - Main application code
- `assets/` - App icons, translations, and other assets
- `android/`, `ios/`, `macos/`, `linux/`, `windows/` - Platform-specific code
- `test/` - Unit and widget tests

## Customization
- Change Pomodoro and break durations in the settings screen.
- Enable/disable notifications and vibration.
- Switch between light and dark themes.
- Add your own motivational quotes in the assets/translations files.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)

---

**Made with Flutter ❤**
