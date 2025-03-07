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

  /// No description provided for @homeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Cashu'**
  String get homeScreenTitle;

  /// No description provided for @homeScreenCurrentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get homeScreenCurrentBalance;

  /// No description provided for @homeScreenRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get homeScreenRecentTransactions;

  /// No description provided for @homeScreenCurrentMint.
  ///
  /// In en, this message translates to:
  /// **'Current Mint'**
  String get homeScreenCurrentMint;

  /// No description provided for @homeScreenMintNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get homeScreenMintNotConnected;

  /// No description provided for @homeScreenSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get homeScreenSend;

  /// No description provided for @homeScreenReceive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get homeScreenReceive;

  /// No description provided for @homeScreenScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get homeScreenScan;

  /// No description provided for @homeScreenEcash.
  ///
  /// In en, this message translates to:
  /// **'Ecash'**
  String get homeScreenEcash;

  /// No description provided for @homeScreenEcashSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get homeScreenEcashSend;

  /// No description provided for @homeScreenEcashSendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send eCash to someone'**
  String get homeScreenEcashSendSubtitle;

  /// No description provided for @homeScreenEcashMelt.
  ///
  /// In en, this message translates to:
  /// **'Melt'**
  String get homeScreenEcashMelt;

  /// No description provided for @homeScreenEcashMeltSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange eCash for BTC'**
  String get homeScreenEcashMeltSubtitle;

  /// No description provided for @homeScreenEcashReceive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get homeScreenEcashReceive;

  /// No description provided for @homeScreenEcashReceiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive eCash from someone'**
  String get homeScreenEcashReceiveSubtitle;

  /// No description provided for @homeScreenMintEcash.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get homeScreenMintEcash;

  /// No description provided for @homeScreenMintEcashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange BTC for eCash'**
  String get homeScreenMintEcashSubtitle;

  /// No description provided for @drawerTitle.
  ///
  /// In en, this message translates to:
  /// **'Cashu Wallet'**
  String get drawerTitle;

  /// No description provided for @drawerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'eCash for everyone'**
  String get drawerSubtitle;

  /// No description provided for @drawerMenuHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get drawerMenuHome;

  /// No description provided for @drawerMenuTransactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get drawerMenuTransactionHistory;

  /// No description provided for @drawerMenuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerMenuSettings;

  /// No description provided for @drawerMenuDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get drawerMenuDarkMode;

  /// No description provided for @drawerMenuLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get drawerMenuLightMode;

  /// No description provided for @drawerMenuAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get drawerMenuAbout;

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

  /// No description provided for @mintScreenAmountError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get mintScreenAmountError;

  /// No description provided for @mintScreenAmountEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get mintScreenAmountEmpty;

  /// No description provided for @generalUnknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get generalUnknownError;
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
