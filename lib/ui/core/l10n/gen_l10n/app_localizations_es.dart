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
  String get homeScreenCurrentBalance => 'Saldo actual';

  @override
  String get homeScreenRecentTransactions => 'Transacciones recientes';

  @override
  String get homeScreenCurrentMint => 'Mint actual';

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
  String get homeScreenEcashSend => 'Enviar';

  @override
  String get homeScreenEcashSendSubtitle => 'Enviar eCash a alguien';

  @override
  String get homeScreenEcashMelt => 'Derretir';

  @override
  String get homeScreenEcashMeltSubtitle => 'Cambiar eCash por BTC';

  @override
  String get homeScreenEcashReceive => 'Recibir';

  @override
  String get homeScreenEcashReceiveSubtitle => 'Recibir eCash de alguien';

  @override
  String get homeScreenMintEcash => 'Mint';

  @override
  String get homeScreenMintEcashSubtitle => 'Cambiar BTC por eCash';

  @override
  String get drawerTitle => 'Cashu Wallet';

  @override
  String get drawerSubtitle => 'eCash para todos';

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

  @override
  String get mintScreenTitle => 'Mint';

  @override
  String get mintScreenMintCardTitle => 'Mint';

  @override
  String get mintScreenAmountInSatsLabel => 'Cantidad en sats';

  @override
  String get mintScreenCreateInvoice => 'Crear Factura';

  @override
  String get mintScreenInvoiceTitle => 'Factura de Lightning';

  @override
  String get mintScreenInvoiceSubtitle => 'Escanea este código QR para pagar la factura';

  @override
  String get mintScreenCopyInvoice => 'Copiar Factura';

  @override
  String get mintScreenInvoiceCopied => 'Factura copiada al portapapeles';

  @override
  String get mintScreenClose => 'Cerrar';

  @override
  String get mintScreenError => 'Error creando la factura';

  @override
  String get mintScreenLoading => 'Creando factura...';

  @override
  String get mintScreenAmountError => 'Por favor, ingrese una cantidad válida';

  @override
  String get mintScreenAmountEmpty => 'Por favor, ingrese una cantidad';
}
