
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import '../service/RequestServiceHelper.dart';
class PostData extends StatefulWidget {
  const PostData({Key? key}) : super(key: key);
  @override
  _PostDataState createState() => _PostDataState();
}
class _PostDataState extends State<PostData> {
  late RequestService serviceHelper;

  double? CCT=0.0;
  String? textCCT="__";

  String? url ="";
  File? image;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    serviceHelper= RequestService();
  }
  Future<void>_showChoiceDialog(BuildContext context)
  {
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.green),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.green,),
              ListTile(
                onTap: (){
                  getImage(ImageSource.gallery);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.green,),
              ),

              Divider(height: 1,color: Colors.green,),
              ListTile(
                onTap: (){
                  getImage(ImageSource.camera);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.green,),
              ),
            ],
          ),
        ),
      );
    });
  }
  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if(pickedFile==null){
      image=null;
    }
    final tempImage= File(pickedFile!.path);
    setState(() {
      image = tempImage;
      Navigator.pop(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tobacco"),backgroundColor: Colors.green,),
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      body: Column(
        children: [
          Form(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  InkWell(
                      onTap: (){
                        _showChoiceDialog(context);
                      },
                      child: ImagePickerCircleButton
                  ),
                  const SizedBox(height: 30),
                  SendIconButton,
                  Card(
                  shadowColor: Colors.green,
                    child: Text("CCT = " + textCCT.toString(),textAlign: TextAlign.values.first,style: const TextStyle(
                      fontSize: 20,

                    ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Card get ImagePickerCircleButton{
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 30,
        color: Colors.white,
        child: Column(
          children: [
            CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 80,
                child: image != null
                    ? CircleAvatar(
                  backgroundColor: Colors.transparent,
                    radius: 90,
                    backgroundImage: FileImage(
                      File(image!.path),
                    )
                )
                    :  const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/icons/leaves.png',
                  ),
                    radius: 70,

                )

            ),
            const Text("Pick Image",style: TextStyle(fontSize: 20),)
          ],
        )
    );
  }
  IconButton get SendIconButton{
    return  IconButton(
        iconSize: 60,
        onPressed: (){
          if(image!=null){
            var uploadResult=serviceHelper.uploadImage(image);
            uploadResult.then((value) => {
              url=value.url
            });
            var CCTresult = serviceHelper.calculateCCT(image);
            CCTresult.then((value) => {
              if(value.cct!>0){
                setState(() {
                  CCT = value.cct;
                  textCCT=value.cct.toString();
                }),
                scaffoldKey.currentState?.showSnackBar(
                    const SnackBar(content: Text("Calculated Succesfuly"))),
                    serviceHelper.createDetail(1, CCT!, url!, DateTime.now())
              }
              else{
                scaffoldKey.currentState?.showSnackBar(
                const SnackBar(content: Text("Error")))
              }
            }
            );
          }else{
            scaffoldKey.currentState?.showSnackBar(
                const SnackBar(content: Text("Resim Seçiniz")));
          }
        },
        icon: Image.asset("assets/icons/calculator.png",height: 50,width: 60,)
    );
  }
}
