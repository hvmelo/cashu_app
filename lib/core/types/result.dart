// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Utility class to wrap result data
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Ok(): {
///     print(result.value);
///   }
///   case Error(): {
///     print(result.error);
///   }
/// }
/// ```
sealed class Result<T, E> {
  const Result();

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.ok(T value) = Ok<T, E>._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(
    E error, {
    StackTrace? stackTrace,
  }) = Error<T, E>._;

  bool get isOk => this is Ok;
  bool get isError => this is Error;

  /// Returns the contained [Ok] value, or null if the result is an [Error]
  T? get value {
    return switch (this) {
      Ok(value: final v) => v,
      Error() => null,
    };
  }

  /// Returns the contained [Error] value, or null if the result is [Ok]
  E? get error {
    return switch (this) {
      Ok() => null,
      Error(error: final e) => e,
    };
  }

  /// Maps a Result<`T`, `E`> to Result<`R`, `E`> by applying a function to the
  /// contained [Ok] value, leaving an [Error] value untouched.
  ///
  /// This function can be used to compose the results of two functions.
  Result<R, E> map<R>(R Function(T) mapper) {
    return switch (this) {
      Ok(value: final v) => Result.ok(mapper(v)),
      Error(error: final e, stackTrace: final st) =>
        Result.error(e, stackTrace: st),
    };
  }

  /// Maps a Result<`T`, `E`> to Result<`R`, `E`> by applying a function to the
  /// contained [Ok] value, leaving an [Error] value untouched.
  ///
  /// Alias for map() method.
  Result<R, E> mapOk<R>(R Function(T) mapper) => map(mapper);

  /// Maps a Result<`T`, `E`> to Result<`R`, `E`> by applying a function that returns
  /// a Result to the contained [Ok] value, leaving an [Error] value untouched.
  ///
  /// This method is useful for chaining together operations that might fail,
  /// without nesting Results.
  Result<R, E> flatMap<R>(Result<R, E> Function(T) mapper) {
    return switch (this) {
      Ok(value: final v) => mapper(v),
      Error(error: final e, stackTrace: final st) =>
        Result.error(e, stackTrace: st),
    };
  }

  /// Maps a Result<T, E> to Result<R, E> by applying a function that returns
  /// a Result to the contained [Ok] value, leaving an [Error] value untouched.
  ///
  /// Alias for flatMap() method.
  Result<R, E> andThen<R>(Result<R, E> Function(T) mapper) => flatMap(mapper);
}

/// Subclass of Result for values
final class Ok<T, E> extends Result<T, E> {
  const Ok._(this.value);

  /// Returned value in result
  @override
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// Subclass of Result for errors
final class Error<T, E> extends Result<T, E> {
  const Error._(
    this.error, {
    this.stackTrace,
  });

  /// Returned error in result
  @override
  final E error;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      'Result<$T>.error($error, ${stackTrace?.toString() ?? 'no stack trace'})';
}
