import 'result.dart';
import 'unit.dart';

/// Base class for all Value Objects
abstract class ValueObject<T, E> {
  /// The raw value
  T get value;

  /// Check if the value is valid
  bool get isValid;

  /// Get the error if the value is invalid
  E? get error;

  /// Validates the value
  Result<Unit, E> validate();
}

// Example of a concrete implementation using Freezed
// 
// ```dart
// part 'non_empty_string.freezed.dart';
// 
// @freezed
// class NonEmptyString with _$NonEmptyString implements ValueObject<String, String> {
//   // Private constructor and class
//   const NonEmptyString._();
//   const factory NonEmptyString._create(String value) = _NonEmptyString;
//   
//   // Static validation method
//   static Result<Unit, String> validate(String value) {
//     return value.isNotEmpty
//         ? Result.ok(unit)
//         : Result.error('String cannot be empty');
//   }
//   
//   // Factory that uses the static validation method
//   factory NonEmptyString(String input) {
//     // Optionally use the validation result here
//     final validationResult = validate(input);
//     
//     // Create the object regardless of validation
//     return NonEmptyString._create(input);
//   }
//   
//   // Required by ValueObject interface
//   @override
//   String get value;
//   
//   // Instance validate method uses the static validation
//   @override
//   Result<Unit, String> validate() => NonEmptyString.validate(value);
//   
//   @override
//   bool get isValid => validate().isOk;
//   
//   @override
//   String? get error {
//     final result = validate();
//     return result.isError ? (result as Error<Unit, String>).error : null;
//   }
// }
// ```
