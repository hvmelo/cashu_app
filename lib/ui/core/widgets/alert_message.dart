import 'package:flutter/material.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';

enum AlertType {
  error,
  warning,
  info,
  success,
}

class AlertMessage extends StatelessWidget {
  final String message;
  final AlertType type;
  final IconData icon;
  final Color color;

  // Construtor privado para ser usado pelas factories
  const AlertMessage._({
    super.key,
    required this.message,
    required this.type,
    required this.icon,
    required this.color,
  });

  // Factory para criar um alerta de erro
  factory AlertMessage.error(
    String message, {
    Key? key,
    IconData icon = Icons.error_outline,
  }) {
    return AlertMessage._(
      key: key,
      message: message,
      type: AlertType.error,
      icon: icon,
      color: Colors.red,
    );
  }

  // Factory para criar um alerta de aviso
  factory AlertMessage.warning(
    String message, {
    Key? key,
    IconData icon = Icons.warning_amber_outlined,
  }) {
    return AlertMessage._(
      key: key,
      message: message,
      type: AlertType.warning,
      icon: icon,
      color: Colors.orange,
    );
  }

  // Factory para criar um alerta de informação
  factory AlertMessage.info(
    String message, {
    Key? key,
    IconData icon = Icons.info_outline,
  }) {
    return AlertMessage._(
      key: key,
      message: message,
      type: AlertType.info,
      icon: icon,
      color: Colors.blue,
    );
  }

  // Factory para criar um alerta de sucesso
  factory AlertMessage.success(
    String message, {
    Key? key,
    IconData icon = Icons.check_circle_outline,
  }) {
    return AlertMessage._(
      key: key,
      message: message,
      type: AlertType.success,
      icon: icon,
      color: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usar a cor do tema quando disponível
    final effectiveColor = switch (type) {
      AlertType.error => context.colorScheme.error,
      AlertType.warning => color,
      AlertType.info => context.colorScheme.primary,
      AlertType.success => color,
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: effectiveColor.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: effectiveColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: effectiveColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
