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
  String get homeScreenEcashMelt => 'Melt';

  @override
  String get homeScreenEcashMeltSubtitle => 'Exchange eCash for BTC';

  @override
  String get homeScreenEcashReceive => 'Receive';

  @override
  String get homeScreenEcashReceiveSubtitle => 'Receive eCash from someone';

  @override
  String get homeScreenMintEcash => 'Mint';

  @override
  String get homeScreenMintEcashSubtitle => 'Exchange BTC for eCash';

  @override
  String get drawerTitle => 'Cashu Wallet';

  @override
  String get drawerSubtitle => 'eCash for everyone';

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
  String get mintScreenTitle => 'Mint eCash';

  @override
  String get mintScreenMintCardTitle => 'Mint';

  @override
  String get mintScreenAmountInSatsLabel => 'Amount in sats';

  @override
  String get mintScreenCreateInvoice => 'Create Invoice';

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
  String get mintScreenError => 'Error creating invoice';

  @override
  String get mintScreenLoading => 'Creating invoice...';

  @override
  String get mintScreenAmountError => 'Please enter a valid amount';

  @override
  String get mintScreenAmountEmpty => 'Please enter an amount';
}
