import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base class for all use cases that take [Params] and return [Type].
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Marker class for use cases that require no parameters.
class NoParams {}
