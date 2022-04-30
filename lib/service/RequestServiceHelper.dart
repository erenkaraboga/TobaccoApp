import 'dart:convert';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:dio/dio.dart';
import '../model/DatabaseModel.dart';
import '../model/PillowResponseModel.dart';
import 'package:http/http.dart'as http;
class RequestService{
  late FormData formData;
  final cloudinary = Cloudinary(
      "225548188944398",
      "S0s1UsBPu3luxg5afZX_LyBNv-U",
      "dinqa9wqr"
  );
  String _BASE_URL="http://c635-88-232-9-195.ngrok.io/upload";
  String _DbBASE_URL='https://10.0.2.2:5001/api/Leafs/';
  String _DbBASE_URLDetail='https://10.0.2.2:5001/api/LeafDetails';
  RequestService(){
    formData=FormData();
  }
  Future<List<LeafModel>?> getData() async{
    try{
      var _response = await http.get(Uri.parse(_DbBASE_URL));
      if(_response.statusCode==200){
        final parsed = json.decode(_response.body).cast<Map<String, dynamic>>();
        return parsed.map<LeafModel>((json) => LeafModel.fromJson(json)).toList();
      }
    }on Exception catch(ex){
      print(ex.toString());
    }
  }
  Future<bool?> createDetail(int leafId,double cct,String url,DateTime time) async {
    formData = FormData.fromMap({
      "LeafId": leafId,
      "CCT" :cct,
      "Url": url,
      "Time":time,
    });
    final response = await Dio().post(_DbBASE_URLDetail, data: formData);
    if(response.statusCode==201){
      return true;
    }else{
      return false;
    }
  }
  Future<bool?> deleteData(int id) async {
    formData= FormData.fromMap({
      "LeafId":id,
    });
    final response = await Dio().delete("$_DbBASE_URL$id", data: formData,queryParameters: {
      "LeafId":id,
    });
    if(response.statusCode==200){
      return true;
    }else{
      return false;
    }
  }
  Future<bool?> createLeaf(String name) async {
      formData = FormData.fromMap({
        "name": name,
      });
    final response = await Dio().post(_DbBASE_URL, data: formData);
    if(response.statusCode==201){
      return true;
    }else{
      return false;
    }
  }

  Future<CloudinaryResponse> uploadImage(file) async{
    final response = await cloudinary.uploadFile(
        filePath: file.path,
        resourceType: CloudinaryResourceType.image,
        folder: "/leaf"
    );
    return response;
  }
  Future<ResponseModel> calculateCCT(file) async {
      formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path)
      });
      final response = await Dio().post(_BASE_URL, data: formData);
      return ResponseModel.fromJson(response.data);
    }

}
