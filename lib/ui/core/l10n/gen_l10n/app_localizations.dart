import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @navBarWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get navBarWallet;

  /// No description provided for @navBarMints.
  ///
  /// In en, this message translates to:
  /// **'Mints'**
  String get navBarMints;

  /// No description provided for @navBarHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navBarHistory;

  /// No description provided for @navBarSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navBarSettings;

  /// No description provided for @walletScreenCurrentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get walletScreenCurrentBalance;

  /// No description provided for @walletScreenRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get walletScreenRecentTransactions;

  /// No description provided for @walletScreenCurrentMint.
  ///
  /// In en, this message translates to:
  /// **'Current Mint'**
  String get walletScreenCurrentMint;

  /// No description provided for @walletScreenMintNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get walletScreenMintNotConnected;

  /// No description provided for @walletScreenSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get walletScreenSend;

  /// No description provided for @walletScreenSendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send eCash to someone'**
  String get walletScreenSendSubtitle;

  /// No description provided for @walletScreenReceive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get walletScreenReceive;

  /// No description provided for @walletScreenReceiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive eCash from someone'**
  String get walletScreenReceiveSubtitle;

  /// No description provided for @walletScreenMint.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get walletScreenMint;

  /// No description provided for @walletScreenMintSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange BTC for eCash'**
  String get walletScreenMintSubtitle;

  /// No description provided for @walletScreenMelt.
  ///
  /// In en, this message translates to:
  /// **'Melt'**
  String get walletScreenMelt;

  /// No description provided for @walletScreenMeltSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange eCash for BTC'**
  String get walletScreenMeltSubtitle;

  /// No description provided for @currentMintCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Mint'**
  String get currentMintCardTitle;

  /// No description provided for @currentMintCardNoMintSelected.
  ///
  /// In en, this message translates to:
  /// **'No mint selected'**
  String get currentMintCardNoMintSelected;

  /// No description provided for @currentMintCardSelectMint.
  ///
  /// In en, this message translates to:
  /// **'Select Mint'**
  String get currentMintCardSelectMint;

  /// No description provided for @currentMintCardErrorLoadingMintData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load mint data'**
  String get currentMintCardErrorLoadingMintData;

  /// No description provided for @mintScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get mintScreenTitle;

  /// No description provided for @mintScreenMintCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get mintScreenMintCardTitle;

  /// No description provided for @mintScreenAmountInSatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount in sats'**
  String get mintScreenAmountInSatsLabel;

  /// No description provided for @mintScreenCreateInvoice.
  ///
  /// In en, this message translates to:
  /// **'Create Invoice'**
  String get mintScreenCreateInvoice;

  /// No description provided for @mintScreenInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Lightning Invoice'**
  String get mintScreenInvoiceTitle;

  /// No description provided for @mintScreenInvoiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan to pay the Lightning invoice'**
  String get mintScreenInvoiceSubtitle;

  /// No description provided for @mintScreenCopyInvoice.
  ///
  /// In en, this message translates to:
  /// **'Copy Invoice'**
  String get mintScreenCopyInvoice;

  /// No description provided for @mintScreenInvoiceCopied.
  ///
  /// In en, this message translates to:
  /// **'Invoice copied to clipboard'**
  String get mintScreenInvoiceCopied;

  /// No description provided for @mintScreenNoMintSelected.
  ///
  /// In en, this message translates to:
  /// **'No mint selected'**
  String get mintScreenNoMintSelected;

  /// No description provided for @mintScreenClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get mintScreenClose;

  /// No description provided for @mintScreenError.
  ///
  /// In en, this message translates to:
  /// **'Error creating invoice'**
  String get mintScreenError;

  /// No description provided for @mintScreenLoading.
  ///
  /// In en, this message translates to:
  /// **'Creating invoice...'**
  String get mintScreenLoading;

  /// No description provided for @mintScreenAmountTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The amount is too large. The maximum amount is {maxAmount} sats.'**
  String mintScreenAmountTooLarge(Object maxAmount);

  /// No description provided for @mintScreenAmountNegativeOrZero.
  ///
  /// In en, this message translates to:
  /// **'The amount cannot be negative or zero.'**
  String get mintScreenAmountNegativeOrZero;

  /// No description provided for @mintScreenAmountInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'The amount is not a valid number.'**
  String get mintScreenAmountInvalidFormat;

  /// No description provided for @addMintScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Mint'**
  String get addMintScreenTitle;

  /// No description provided for @addMintScreenDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a new mint to your wallet. You can add any Cashu mint by entering its URL.'**
  String get addMintScreenDescription;

  /// No description provided for @addMintScreenUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Mint URL'**
  String get addMintScreenUrlLabel;

  /// No description provided for @addMintScreenNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname (Optional)'**
  String get addMintScreenNicknameLabel;

  /// No description provided for @addMintScreenNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'A friendly name for this mint'**
  String get addMintScreenNicknameHint;

  /// No description provided for @addMintScreenAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Mint'**
  String get addMintScreenAddButton;

  /// No description provided for @addMintScreenSuccess.
  ///
  /// In en, this message translates to:
  /// **'Mint added successfully'**
  String get addMintScreenSuccess;

  /// No description provided for @addMintScreenPasteFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'Paste from clipboard'**
  String get addMintScreenPasteFromClipboard;

  /// No description provided for @mintManagerScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Mints'**
  String get mintManagerScreenTitle;

  /// No description provided for @mintManagerScreenNoMints.
  ///
  /// In en, this message translates to:
  /// **'No mints added yet'**
  String get mintManagerScreenNoMints;

  /// No description provided for @mintManagerScreenAddMintPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add a mint to start using your wallet'**
  String get mintManagerScreenAddMintPrompt;

  /// No description provided for @mintManagerScreenAddMintButton.
  ///
  /// In en, this message translates to:
  /// **'Add Mint'**
  String get mintManagerScreenAddMintButton;

  /// No description provided for @mintManagerScreenCurrentMint.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get mintManagerScreenCurrentMint;

  /// No description provided for @mintManagerScreenSetAsCurrentButton.
  ///
  /// In en, this message translates to:
  /// **'Set as current mint'**
  String get mintManagerScreenSetAsCurrentButton;

  /// No description provided for @mintManagerScreenEditButton.
  ///
  /// In en, this message translates to:
  /// **'Edit mint'**
  String get mintManagerScreenEditButton;

  /// No description provided for @mintManagerScreenDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete mint'**
  String get mintManagerScreenDeleteButton;

  /// No description provided for @mintManagerScreenDeleteMintTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Mint'**
  String get mintManagerScreenDeleteMintTitle;

  /// No description provided for @mintManagerScreenDeleteMintConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {mintName}?'**
  String mintManagerScreenDeleteMintConfirmation(Object mintName);

  /// No description provided for @mintManagerScreenEditMintTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Mint'**
  String get mintManagerScreenEditMintTitle;

  /// No description provided for @mintManagerScreenMintDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mint Details'**
  String get mintManagerScreenMintDetailsTitle;

  /// No description provided for @mintManagerScreenMintUrl.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get mintManagerScreenMintUrl;

  /// No description provided for @mintManagerScreenMintNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get mintManagerScreenMintNickname;

  /// No description provided for @mintManagerScreenCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get mintManagerScreenCloseButton;

  /// No description provided for @mintManagerScreenMintMintCardCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get mintManagerScreenMintMintCardCurrentLabel;

  /// No description provided for @mintManagerScreenCopyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get mintManagerScreenCopyToClipboard;

  /// No description provided for @mintManagerScreenCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get mintManagerScreenCopiedToClipboard;

  /// No description provided for @mintManagerScreenErrorLoadingMintData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load mint data'**
  String get mintManagerScreenErrorLoadingMintData;

  /// No description provided for @editMintDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Mint'**
  String get editMintDialogTitle;

  /// No description provided for @editMintDialogUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get editMintDialogUrlLabel;

  /// No description provided for @editMintDialogNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname (Optional)'**
  String get editMintDialogNicknameLabel;

  /// No description provided for @editMintDialogNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a friendly name'**
  String get editMintDialogNicknameHint;

  /// No description provided for @editMintDialogSetAsCurrentButton.
  ///
  /// In en, this message translates to:
  /// **'Set as current'**
  String get editMintDialogSetAsCurrentButton;

  /// No description provided for @editMintDialogMintUpdated.
  ///
  /// In en, this message translates to:
  /// **'Mint updated successfully'**
  String get editMintDialogMintUpdated;

  /// No description provided for @editMintDialogDeleteMintTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Mint'**
  String get editMintDialogDeleteMintTitle;

  /// No description provided for @editMintDialogDeleteMintConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {mintName}?'**
  String editMintDialogDeleteMintConfirmation(Object mintName);

  /// No description provided for @transactionHistoryScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistoryScreenTitle;

  /// No description provided for @transactionHistoryScreenDescription.
  ///
  /// In en, this message translates to:
  /// **'View your transaction history'**
  String get transactionHistoryScreenDescription;

  /// No description provided for @transactionHistoryScreenEmpty.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get transactionHistoryScreenEmpty;

  /// No description provided for @settingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenTitle;

  /// No description provided for @settingsScreenAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsScreenAppearanceTitle;

  /// No description provided for @settingsScreenAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsScreenAboutTitle;

  /// No description provided for @settingsScreenVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsScreenVersionTitle;

  /// No description provided for @generalSaveButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get generalSaveButtonLabel;

  /// No description provided for @generalCancelButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get generalCancelButtonLabel;

  /// No description provided for @generalDeleteButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get generalDeleteButtonLabel;

  /// No description provided for @generalUnknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get generalUnknownError;

  /// No description provided for @generalMintUrlEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mint URL cannot be empty'**
  String get generalMintUrlEmpty;

  /// No description provided for @generalMintUrlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get generalMintUrlInvalid;

  /// No description provided for @generalNicknameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nickname cannot be empty'**
  String get generalNicknameEmpty;

  /// No description provided for @generalNicknameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Nickname cannot be longer than {maxLength} characters'**
  String generalNicknameTooLong(Object maxLength);

  /// No description provided for @generalNicknameInvalidCharacters.
  ///
  /// In en, this message translates to:
  /// **'Use only letters, numbers, or - _ . < > + # &'**
  String get generalNicknameInvalidCharacters;

  /// No description provided for @errorCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorCardTitle;

  /// No description provided for @errorCardGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorCardGenericMessage;

  /// No description provided for @errorCardRetryButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errorCardRetryButtonLabel;

  /// No description provided for @errorCardDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Technical details'**
  String get errorCardDetailsLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
