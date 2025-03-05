// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:cashu_app/config/providers.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

/// Staging config entry point.
/// Launch with `flutter run --target lib/main_staging.dart`.
/// Uses a real mint.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CdkFlutter.init();
  final path = await getApplicationDocumentsDirectory();

  final seedFile = File('${path.path}/seed.txt');

  String seed;
  if (await seedFile.exists()) {
    seed = await seedFile.readAsString();
  } else {
    seed = generateHexSeed();
    await seedFile.writeAsString(seed);
  }
  final db = WalletDatabase(path: '${path.path}/wallet.db');

  final wallet = Wallet.newFromHexSeed(
      mintUrl: 'https://mint.minibits.cash/Bitcoin',
      unit: 'sat',
      seed: seed,
      localstore: db);

  runApp(ProviderScope(
    overrides: [
      walletProvider.overrideWith((ref) => wallet),
    ],
    child: MainApp(),
  ));
}
