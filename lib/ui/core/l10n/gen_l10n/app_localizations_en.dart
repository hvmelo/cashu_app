// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navBarWallet => 'Wallet';

  @override
  String get navBarMints => 'Mints';

  @override
  String get navBarHistory => 'History';

  @override
  String get navBarSettings => 'Settings';

  @override
  String get walletScreenCurrentBalance => 'Current Balance';

  @override
  String get walletScreenRecentTransactions => 'Recent Transactions';

  @override
  String get walletScreenCurrentMint => 'Current Mint';

  @override
  String get walletScreenMintNotConnected => 'Not connected';

  @override
  String get walletScreenSend => 'Send';

  @override
  String get walletScreenSendSubtitle => 'Send eCash to someone';

  @override
  String get walletScreenReceive => 'Receive';

  @override
  String get walletScreenReceiveSubtitle => 'Receive eCash from someone';

  @override
  String get walletScreenMint => 'Mint';

  @override
  String get walletScreenMintSubtitle => 'Exchange BTC for eCash';

  @override
  String get walletScreenMelt => 'Melt';

  @override
  String get walletScreenMeltSubtitle => 'Exchange eCash for BTC';

  @override
  String get currentMintCardTitle => 'Current Mint';

  @override
  String get currentMintCardNoMintSelected => 'No mint selected';

  @override
  String get currentMintCardSelectMint => 'Select Mint';

  @override
  String get currentMintCardErrorLoadingMintData => 'Failed to load mint data';

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
  String mintScreenAmountTooLarge(Object maxAmount) {
    return 'The amount is too large. The maximum amount is $maxAmount sats.';
  }

  @override
  String get mintScreenAmountNegativeOrZero => 'The amount cannot be negative or zero.';

  @override
  String get mintScreenAmountInvalidFormat => 'The amount is not a valid number.';

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
  String get addMintScreenErrorEmptyUrl => 'Mint URL is required';

  @override
  String get addMintScreenErrorInvalidUrl => 'Please enter a valid URL';

  @override
  String get addMintScreenErrorUnknown => 'An unknown error occurred';

  @override
  String get addMintScreenPasteFromClipboard => 'Paste from clipboard';

  @override
  String get mintManagerScreenTitle => 'Manage Mints';

  @override
  String get mintManagerScreenRefresh => 'Refresh mints';

  @override
  String get mintManagerScreenNoMints => 'No mints added yet';

  @override
  String get mintManagerScreenAddMintPrompt => 'Add a mint to start using your wallet';

  @override
  String get mintManagerScreenAddMintButton => 'Add Mint';

  @override
  String get mintManagerScreenCurrentMint => 'Current';

  @override
  String get mintManagerScreenSetAsCurrentButton => 'Set as current mint';

  @override
  String get mintManagerScreenEditButton => 'Edit mint';

  @override
  String get mintManagerScreenDeleteButton => 'Delete mint';

  @override
  String get mintManagerScreenDeleteMintTitle => 'Delete Mint';

  @override
  String mintManagerScreenDeleteMintConfirmation(Object mintName) {
    return 'Are you sure you want to delete $mintName?';
  }

  @override
  String get mintManagerScreenEditMintTitle => 'Edit Mint';

  @override
  String get mintManagerScreenMintDetailsTitle => 'Mint Details';

  @override
  String get mintManagerScreenMintUrl => 'URL';

  @override
  String get mintManagerScreenMintNickname => 'Nickname';

  @override
  String get mintManagerScreenCloseButton => 'Close';

  @override
  String get mintManagerScreenMintMintCardCurrentLabel => 'Current';

  @override
  String get mintManagerScreenCopyToClipboard => 'Copy to clipboard';

  @override
  String get mintManagerScreenCopiedToClipboard => 'Copied to clipboard';

  @override
  String get mintManagerScreenErrorLoadingMintData => 'Failed to load mint data';

  @override
  String get editMintDialogTitle => 'Edit Mint';

  @override
  String get editMintDialogUrlLabel => 'URL';

  @override
  String get editMintDialogNicknameLabel => 'Nickname (Optional)';

  @override
  String get editMintDialogNicknameHint => 'Enter a friendly name';

  @override
  String get editMintDialogSetAsCurrentButton => 'Set as current';

  @override
  String get editMintDialogMintUpdated => 'Mint updated successfully';

  @override
  String get editMintDialogDeleteMintTitle => 'Delete Mint';

  @override
  String editMintDialogDeleteMintConfirmation(Object mintName) {
    return 'Are you sure you want to delete $mintName?';
  }

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
  String get generalSaveButtonLabel => 'Save';

  @override
  String get generalCancelButtonLabel => 'Cancel';

  @override
  String get generalDeleteButtonLabel => 'Delete';

  @override
  String get generalUnknownError => 'An unknown error occurred';

  @override
  String get generalNicknameEmpty => 'Nickname cannot be empty';

  @override
  String generalNicknameTooLong(Object maxLength) {
    return 'Nickname cannot be longer than $maxLength characters';
  }

  @override
  String get generalNicknameInvalidCharacters => 'Use only letters, numbers, or - _ . < > + # &';

  @override
  String get errorCardTitle => 'Error';

  @override
  String get errorCardGenericMessage => 'Something went wrong. Please try again.';

  @override
  String get errorCardRetryButtonLabel => 'Retry';

  @override
  String get errorCardDetailsLabel => 'Technical details';
}
