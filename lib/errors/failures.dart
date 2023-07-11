abstract class Failure {}

//TODO1 implement failures
class ServerFailure extends Failure {
  final String message;

  ServerFailure(this.message);
}
