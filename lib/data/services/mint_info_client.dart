// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:cashu_app/domain/models/mint_info.dart';
import 'package:cashu_app/utils/result.dart' show Result;
import 'package:http/http.dart' as http;

class MintInfoClient {
  MintInfoClient(this.mintUrl);

  final String mintUrl;

  Future<Result<MintInfo>> getMintInfo() async {
    try {
      final uri = Uri.parse('$mintUrl/info');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Result.ok(
          MintInfo.fromJson(json),
        );
      } else {
        return Result.error(HttpException(
            "Invalid response: ${response.statusCode} ${response.reasonPhrase}"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
