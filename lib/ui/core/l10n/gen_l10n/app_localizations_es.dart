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
  String get drawerMenuManageMints => 'Mints';

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
  String get mintScreenNoMintSelected => 'No mint selected';

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
  String get generalCancelButtonLabel => 'Cancel';

  @override
  String get generalUnknownError => 'An unknown error occurred';
}
