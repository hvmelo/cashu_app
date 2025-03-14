/// An error that occurs in unexpected situations.
///
/// This exception can wrap another exception that caused the error,
/// along with an optional stack trace for better debugging.
class UnexpectedError implements Exception {
  /// A descriptive message about the error.
  final String? message;

  /// The original exception that caused this error, if any.
  final Object? cause;

  /// The stack trace associated with the error, if available.
  final StackTrace? stackTrace;

  /// Creates a new [UnexpectedError].
  ///
  /// The [message] parameter is required and should describe the error.
  /// The [cause] parameter is optional and represents the original exception.
  /// The [stackTrace] parameter is optional and represents the stack trace where the error occurred.
  UnexpectedError(
      {this.message = 'An unexpected error occurred.',
      this.cause,
      this.stackTrace});

  @override
  String toString() {
    final buffer = StringBuffer('UnexpectedError: $message');

    if (cause != null) {
      buffer.write('\nCause: $cause');
    }

    if (stackTrace != null) {
      buffer.write('\nStack trace: $stackTrace');
    }

    return buffer.toString();
  }
}
