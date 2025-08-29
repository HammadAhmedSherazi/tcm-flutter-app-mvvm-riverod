import '../../export_all.dart';

class ApiResponse<T> {
  ApiResponse();

  Status status = Status.undertermined;

  ConnectionState connectionStatus = ConnectionState.none;

  T? data;

  String message = '';

  List errors = [];

  ApiResponse.undertermined() : status = Status.undertermined;

  ApiResponse.loading() : status = Status.loading;

  ApiResponse.completed(this.data) : status = Status.completed;

  ApiResponse.error() : status = Status.error;

  ApiResponse.loadingMore() : status = Status.loadingMore;

  ApiResponse.errors() : status = Status.error;
  ApiResponse.loadingProccess() : status = Status.loadingProcess;
}
