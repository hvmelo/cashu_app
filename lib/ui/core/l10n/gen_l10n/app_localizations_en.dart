// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeScreenTitle => 'Cashu';

  @override
  String get homeScreenCurrentBalance => 'Current Balance';

  @override
  String get homeScreenRecentTransactions => 'Recent Transactions';

  @override
  String get homeScreenCurrentMint => 'Current Mint';

  @override
  String get homeScreenSend => 'Send';

  @override
  String get homeScreenReceive => 'Receive';

  @override
  String get homeScreenScan => 'Scan';

  @override
  String get drawerTitle => 'Cashu Wallet';

  @override
  String get drawerSubtitle => 'Ecash for everyone';

  @override
  String get drawerMenuHome => 'Home';

  @override
  String get drawerMenuTransactionHistory => 'Transaction History';

  @override
  String get drawerMenuSettings => 'Settings';

  @override
  String get drawerMenuDarkMode => 'Dark Mode';

  @override
  String get drawerMenuLightMode => 'Light Mode';

  @override
  String get drawerMenuAbout => 'About';
}
