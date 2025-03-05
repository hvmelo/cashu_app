// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get homeScreenTitle => 'Cashu';

  @override
  String get homeScreenCurrentBalance => 'Saldo Actual';

  @override
  String get homeScreenRecentTransactions => 'Transacciones Recientes';

  @override
  String get homeScreenCurrentMint => 'Mint Actual';

  @override
  String get homeScreenMintNotConnected => 'No conectado';

  @override
  String get homeScreenSend => 'Enviar';

  @override
  String get homeScreenReceive => 'Recibir';

  @override
  String get homeScreenScan => 'Escanear';

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
  String get drawerSubtitle => 'Ecash para Todos';

  @override
  String get drawerMenuHome => 'Inicio';

  @override
  String get drawerMenuTransactionHistory => 'Historial de Transacciones';

  @override
  String get drawerMenuSettings => 'Ajustes';

  @override
  String get drawerMenuDarkMode => 'Modo Oscuro';

  @override
  String get drawerMenuLightMode => 'Modo Claro';

  @override
  String get drawerMenuAbout => 'Acerca';
}
