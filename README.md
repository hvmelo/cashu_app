# Cashu Wallet

<img src="assets/images/cashu_logo.png" alt="Cashu Logo" width="100"/>

A reference implementation of a mobile wallet for the Cashu protocol - private, secure ecash for Bitcoin.

## What is Cashu?

Cashu is a privacy-focused ecash protocol for Bitcoin that enables:

- **Private transactions**: Using blind signatures to ensure the mint cannot track who is spending tokens
- **Offline payments**: Send and receive payments without requiring an internet connection
- **Programmable money**: Support for script conditions like time locks, public key locks, and more
- **Lightning Network integration**: Seamless interoperability with the Lightning Network

Cashu is designed to improve the experience for users of custodial services by bringing privacy, censorship resistance, and flexibility to Bitcoin transactions.

## Features

- 🔒 **Private Transactions**: Send and receive Cashu tokens with complete privacy
- ⚡ **Lightning Network Support**: Deposit and withdraw using Lightning Network
- 🌐 **Multi-Mint Support**: Connect to multiple mints to distribute trust
- 🔄 **Transaction History**: View your complete transaction history
- 🌙 **Dark Mode**: Toggle between light and dark themes
- 🌍 **Internationalization**: Supports multiple languages (currently English and Spanish)
- 📱 **Cross-Platform**: Built with Flutter for iOS and Android

## Screenshots

_Coming soon_

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository:

```bash
git clone https://github.com/hvmelo/cashu_app.git
cd cashu_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
# Development environment
flutter run --target lib/main_development.dart

# Staging environment (uses a real mint)
flutter run --target lib/main_staging.dart
```

## Project Structure

```
lib/
├── config/         # App configuration and providers
├── routing/        # App routing
├── ui/
│   ├── core/       # Core UI components, themes, and localization
│   └── home/       # Home screen and related widgets
└── main.dart       # App entry point
```

## Development

### Build Modes

The app supports different build configurations:

- **Development**: Uses a mock mint for testing
- **Staging**: Connects to a real mint
- **Production**: _Coming soon_

### Localization

The app supports multiple languages. To add a new language:

1. Create a new ARB file in `lib/ui/core/l10n/`
2. Run the localization generator:

```bash
flutter gen-l10n
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Cashu Protocol](https://github.com/cashubtc/cashu) - The core Cashu protocol
- [CDK Flutter](https://github.com/davidcaseria/cdk_flutter) - Cashu Development Kit for Flutter
