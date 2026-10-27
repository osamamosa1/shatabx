import 'package:flutter/material.dart';

import '../../config/locale/app_localizations.dart';
import '../utils/values/app_colors.dart';
import '../utils/values/text_styles.dart';
import 'my_default_button.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.tr(message),
              textAlign: TextAlign.center,
              style: TextStyles.regular16(color: AppColors.text),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              MyDefaultButton(text: context.tr('retry'), onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
