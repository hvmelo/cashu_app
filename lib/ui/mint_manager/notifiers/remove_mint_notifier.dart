import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/types.dart';
import '../../../domain/models/mint.dart';
import '../../core/providers/mint_providers.dart';

part 'remove_mint_notifier.g.dart';

/// Notifier for removing a mint
@riverpod
class RemoveMintNotifier extends _$RemoveMintNotifier {
  @override
  bool build(Mint mint) {
    // Initial state is just a completed future with no value
    // The loading and error states will be managed by AsyncValue
    return false;
  }

  /// Removes the mint
  Future<void> removeMint() async {
    // Set state to loading using the update method
    final result = await ref.read(removeMintProvider(mint.url).future);

    // Handle the result
    switch (result) {
      case Ok():
        // Set state to success
        state = true;
        break;
      case Error():
        state = false;
        break;
    }
  }
}
