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
  String get navBarHome => 'Home';

  @override
  String get navBarMints => 'Mints';

  @override
  String get navBarHistory => 'History';

  @override
  String get navBarSettings => 'Settings';

  @override
  String get currentMintCardTitle => 'Current Mint';

  @override
  String get currentMintCardNoMintSelected => 'No mint selected';

  @override
  String get currentMintCardSelectMint => 'Select Mint';

  @override
  String get mintScreenTitle => 'Mint';

  @override
  String get mintScreenMintCardTitle => 'Mint';

  @override
  String get mintScreenAmountInSatsLabel => 'Amount in sats';

  @override
  String get mintScreenCreateInvoice => 'Create Invoice';

  @override
  String get mintScreenInvoiceTitle => 'Lightning Invoice';

  @override
  String get mintScreenInvoiceSubtitle => 'Scan to pay the Lightning invoice';

  @override
  String get mintScreenCopyInvoice => 'Copy Invoice';

  @override
  String get mintScreenInvoiceCopied => 'Invoice copied to clipboard';

  @override
  String get mintScreenNoMintSelected => 'No mint selected';

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

  @override
  String get addMintScreenTitle => 'Add Mint';

  @override
  String get addMintScreenDescription => 'Add a new mint to your wallet. You can add any Cashu mint by entering its URL.';

  @override
  String get addMintScreenUrlLabel => 'Mint URL';

  @override
  String get addMintScreenUrlRequired => 'Mint URL is required';

  @override
  String get addMintScreenUrlInvalid => 'Please enter a valid URL';

  @override
  String get addMintScreenNicknameLabel => 'Nickname (Optional)';

  @override
  String get addMintScreenNicknameHint => 'A friendly name for this mint';

  @override
  String get addMintScreenAddButton => 'Add Mint';

  @override
  String get addMintScreenSuccess => 'Mint added successfully';

  @override
  String get addMintScreenPasteFromClipboard => 'Paste from clipboard';

  @override
  String get manageMintScreenTitle => 'Manage Mints';

  @override
  String get manageMintScreenRefresh => 'Refresh mints';

  @override
  String get manageMintScreenNoMints => 'No mints added yet';

  @override
  String get manageMintScreenAddMintPrompt => 'Add a mint to start using your wallet';

  @override
  String get manageMintScreenAddMintButton => 'Add Mint';

  @override
  String get manageMintScreenCurrentMint => 'Current';

  @override
  String get manageMintScreenSetAsCurrentButton => 'Set as current mint';

  @override
  String get manageMintScreenEditButton => 'Edit mint';

  @override
  String get manageMintScreenDeleteButton => 'Delete mint';

  @override
  String get manageMintScreenDeleteMintTitle => 'Delete Mint';

  @override
  String manageMintScreenDeleteMintConfirmation(String mintName) {
    return 'Are you sure you want to delete $mintName?';
  }

  @override
  String get manageMintScreenEditMintTitle => 'Edit Mint';

  @override
  String get manageMintScreenSaveButton => 'Save';

  @override
  String get manageMintScreenMintDetailsTitle => 'Mint Details';

  @override
  String get manageMintScreenMintUrl => 'URL';

  @override
  String get manageMintScreenMintNickname => 'Nickname';

  @override
  String get manageMintScreenCloseButton => 'Close';

  @override
  String get manageMintScreenCopyToClipboard => 'Copy to clipboard';

  @override
  String get manageMintScreenCopiedToClipboard => 'Copied to clipboard';

  @override
  String get transactionHistoryScreenTitle => 'Transaction History';

  @override
  String get transactionHistoryScreenDescription => 'View your transaction history';

  @override
  String get transactionHistoryScreenEmpty => 'No transactions yet';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get settingsScreenAppearanceTitle => 'Appearance';

  @override
  String get settingsScreenAboutTitle => 'About';

  @override
  String get settingsScreenVersionTitle => 'Version';

  @override
  String get generalCancelButtonLabel => 'Cancel';

  @override
  String get generalUnknownError => 'An unknown error occurred';
}
