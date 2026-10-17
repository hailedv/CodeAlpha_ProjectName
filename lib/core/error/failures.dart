import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Failure when cache operations fail
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure when server operations fail
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure when validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Failure when file operations fail
class FileFailure extends Failure {
  const FileFailure(super.message);
}
