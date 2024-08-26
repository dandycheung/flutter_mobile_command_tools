class CommandResponseModel {
  bool isSuccess = false;
  dynamic data;

  CommandResponseModel(this.isSuccess, this.data);

  @override
  String toString() {
    return 'CommandResultModel{isSuccess: $isSuccess, data: $data}';
  }
}
