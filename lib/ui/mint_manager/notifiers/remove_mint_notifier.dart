// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../../../data/data_providers.dart';
// import '../../../domain/models/mint.dart';
// import '../../core/notifiers/current_mint_notifier.dart';

// part 'remove_mint_notifier.g.dart';

// /// Notifier for removing a mint
// @riverpod
// class RemoveMintNotifier extends _$RemoveMintNotifier {
//   @override
//   FutureOr<void> build(Mint mint) {
//     // Initial state is just a completed future with no value
//     // The loading and error states will be managed by AsyncValue
//     return Future.value();
//   }

//   /// Removes the mint
//   Future<void> removeMint() async {
//     // Set state to loading using the update method
//     state = const AsyncValue.loading();

//     // Use AsyncValue.guard to automatically handle errors
//     state = await AsyncValue.guard(() async {
//       final mintRepo = await ref.watch(mintRepositoryProvider.future);
//       await mintRepo.removeMint(ref.argument.mint.url);

//       // If this is the current mint, we need to select a different one
//       final currentMint = await ref.read(currentMintNotifierProvider.future);
//       if (currentMint?.mint.url == ref.argument.mint.url) {
//         // Get the first available mint that's not this one
//         final mints = await ref.read(listMintsProvider.future);
//         final otherMints =
//             mints.where((m) => m.mint.url != ref.argument.mint.url).toList();

//         if (otherMints.isNotEmpty) {
//           // Set another mint as the current mint
//           await ref
//               .read(currentMintNotifierProvider.notifier)
//               .setCurrentMint(otherMints.first.mint.url);
//         } else {
//           // No other mints available, clear the current mint
//           ref.invalidate(currentMintNotifierProvider);
//         }
//       }

//       return; // Return void
//     });
//   }
// }
