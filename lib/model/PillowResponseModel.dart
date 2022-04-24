class ResponseModel {
  double? cct;
  ResponseModel({this.cct});
  ResponseModel.fromJson(Map<String, dynamic> json) {
    cct = json['CCT'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['CCT'] = cct;
    return data;
  }
}