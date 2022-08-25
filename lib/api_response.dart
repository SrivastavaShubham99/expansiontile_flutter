class ApiResponse<T> {
  int? code;
  T? dataResponse;
  bool? isSuccess;

  ApiResponse.success(T? data) {
    dataResponse = data;
    isSuccess = true;
  }

  ApiResponse.failure(T? data) {
    dataResponse = data;
    isSuccess = false;
  }

  ApiResponse.error(T? response) {
    dataResponse = response;
    isSuccess = false;
  }
}