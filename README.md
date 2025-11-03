# 🍷☕ Drink Your Wine - POS & Inventory System

A comprehensive Point of Sale and Inventory Management System built with Flutter for **Drink Your Wine Cafe**.

## 📋 Features

- **📊 Dashboard** - Real-time overview of sales, inventory, and key metrics
- **🛒 Point of Sale (POS)** - Fast and intuitive checkout system
- **📦 Inventory Management** - Track products, stock levels, and suppliers
- **👥 Employee Management** - Manage staff, roles, and permissions
- **📈 Reports & Analytics** - Generate sales, inventory, and performance reports
- **⚙️ Settings** - Configure system preferences and business settings

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Supabase account (for backend)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd drink_your_wine_pos
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Create a Supabase project at [supabase.com](https://supabase.com)
   - Copy your project URL and anon key
   - Add them to `lib/config/supabase_config.dart`

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── config/          # App configuration (theme, routes, constants)
├── models/          # Data models
├── providers/       # State management
├── screens/         # UI screens
├── services/        # Backend services
├── utils/           # Helper functions
├── widgets/         # Reusable widgets
└── main.dart        # App entry point
```

## 🛠️ Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** Provider
- **Backend:** Supabase
- **Local Storage:** SharedPreferences

## 📱 Screens Overview

### Authentication
- Splash Screen
- Login Screen

### Main Features
- **Dashboard** - Sales overview and quick actions
- **POS** - Product selection and checkout
- **Inventory** - View, add, edit products
- **Employees** - Manage staff members
- **Reports** - Sales and inventory analytics
- **Settings** - App configuration

## 🎨 Design System

The app uses a custom theme inspired by coffee and wine aesthetics:
- **Primary Color:** Coffee Brown (#6B4226)
- **Secondary Color:** Wine Red (#8B1538)
- **Accent Color:** Gold (#D4AF37)

## 🔐 Security Notes

- Never commit sensitive credentials (API keys, passwords)
- Use environment variables for configuration
- Implement proper authentication and authorization
- Follow Supabase Row Level Security (RLS) best practices

## 📝 Development

### Running Tests
```bash
flutter test
```

### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is proprietary software for Drink Your Wine Cafe.

## 👨‍💻 Developer

Built with ❤️ for Drink Your Wine Cafe

---

**Note:** This is an active development project. Features and documentation will be updated regularly."# Drink-Your-Wine" 
