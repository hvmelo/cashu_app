import 'package:cashu_app/ui/core/l10n/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
