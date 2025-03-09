// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cashu_app/data/repositories/mint_info/mint_info_repository.dart';

import '../../../domain/models/mint_info.dart';
import '../../../utils/result.dart';
import '../../services/mint_info_client.dart';

class MintInfoRepositoryRemote implements MintInfoRepository {
  const MintInfoRepositoryRemote();

  @override
  Future<MintInfo> getMintInfo(String mintUrl) async {
    final mintInfoClient = MintInfoClient(mintUrl);
    final result = await mintInfoClient.getMintInfo();

    return switch (result) {
      Ok(value: final mintInfo) => mintInfo,
      Error(error: final error) => throw error,
    };
  }
}
