abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure() : super('Error del servidor');
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('Error de conexión');
}
