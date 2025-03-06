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
  String get homeScreenMintNotConnected => 'Not connected';

  @override
  String get homeScreenSend => 'Send';

  @override
  String get homeScreenReceive => 'Receive';

  @override
  String get homeScreenScan => 'Scan';

  @override
  String get homeScreenEcash => 'Ecash';

  @override
  String get homeScreenEcashSend => 'Send';

  @override
  String get homeScreenEcashSendSubtitle => 'Send eCash to someone';

  @override
  String get homeScreenEcashMelt => 'Pay';

  @override
  String get homeScreenEcashMeltSubtitle => 'Pay Lightning Network invoice';

  @override
  String get homeScreenEcashReceive => 'Receive';

  @override
  String get homeScreenEcashReceiveSubtitle => 'Receive eCash from someone';

  @override
  String get homeScreenMintEcash => 'Mint';

  @override
  String get homeScreenMintEcashSubtitle => 'Mint eCash via Lightning Network';

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

  @override
  String get mintScreenTitle => 'Mint';

  @override
  String get mintScreenSubtitle => 'Enter the amount in sats to mint';

  @override
  String get mintScreenAmountHint => 'Amount in sats';

  @override
  String get mintScreenGenerateInvoice => 'Generate Invoice';

  @override
  String get mintScreenInvoiceTitle => 'Lightning Invoice';

  @override
  String get mintScreenInvoiceSubtitle => 'Scan this QR code to pay the invoice';

  @override
  String get mintScreenCopyInvoice => 'Copy Invoice';

  @override
  String get mintScreenInvoiceCopied => 'Invoice copied to clipboard';

  @override
  String get mintScreenClose => 'Close';

  @override
  String get mintScreenError => 'Error generating invoice';

  @override
  String get mintScreenLoading => 'Generating invoice...';
}
