/// A generic failure class that can store any error object.
///
/// Similar to [Unit], this provides a standardized way to handle failures across the application.
final class Failure {
  final Object error;

  const Failure(this.error);

  @override
  String toString() => 'Failure($error)';
}
