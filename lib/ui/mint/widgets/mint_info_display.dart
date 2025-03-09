// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cashu_app/config/app_providers.dart';
import 'package:cashu_app/domain/models/mint_info.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MintInfoDisplay extends HookConsumerWidget {
  const MintInfoDisplay({
    super.key,
    required this.mintUrl,
  });

  final String mintUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mintInfoAsync = ref.watch(mintInfoProvider(mintUrl));

    return mintInfoAsync.when(
      data: (mintInfo) => _MintInfoContent(mintInfo: mintInfo),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: ${error.toString()}'),
      ),
    );
  }
}

class _MintInfoContent extends StatelessWidget {
  const _MintInfoContent({
    required this.mintInfo,
  });

  final MintInfo mintInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mintInfo.name,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              mintInfo.description,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Version: ${mintInfo.version}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Pubkey: ${mintInfo.pubkey}',
              style: theme.textTheme.bodyMedium,
            ),
            if (mintInfo.motd.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Message of the day:',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                mintInfo.motd,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
