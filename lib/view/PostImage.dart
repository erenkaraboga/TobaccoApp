import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../service/RequestServiceHelper.dart';
import 'CrudLeaf.dart';

class PostData extends StatefulWidget {
  const PostData({Key? key, required this.leafId}) : super(key: key);
  final int leafId;
  @override
  _PostDataState createState() => _PostDataState();
}

bool isloading = false;

class _PostDataState extends State<PostData> {
  late RequestService serviceHelper;

  late TextEditingController nameController;
  double? CCT = 0.0;
  String? textCCT = "__";
  String? url = "";
  File? image;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    serviceHelper = RequestService();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Form(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                              onTap: () {
                                _showChoiceDialog(context);
                              },
                              child: ImagePickerCircleButton),
                          const SizedBox(height: 30),
                          SendButton(),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 300,
                            height: 200,
                            child: Card(
                              elevation: 10,
                              child: Column(children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Analysis Report",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  shadowColor: Colors.green,
                                  child: Text(
                                    "CCT = " + textCCT.toString(),
                                    textAlign: TextAlign.values.first,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "The CCT value of the leaf shot is 4.975 K. The Quality grade value of the leaf shot is 79%. It is not ideal cured ",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }

  InkWell SendButton() {
    return InkWell(
      onTap: () {
        setState(() {
           isloading = true;
        });
       
        if (image != null) {
          var uploadResult = serviceHelper.uploadImage(image);
          uploadResult.then((value) => {
                url = value.url,
                //serviceHelper.createDetail(1, 0, url!, DateTime.now())
              });
          var CCTresult = serviceHelper.calculateCCT(image);
          CCTresult.then((value) => {
                if (value.cct! > 0)
                  {
                    setState(() {
                      CCT = value.cct;
                      textCCT = value.cct.toString();
                    }),
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Calculated Succesfuly"))),
                    serviceHelper.createDetail(
                        widget.leafId, CCT!, url!, DateTime.now()),
                   setState(() {
                      isloading = false;
                   }),
                    
                  }
                else
                  {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Error")))
                  }
              });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Resim Seçiniz")));
        }
      },
      child: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        padding: const EdgeInsetsDirectional.fromSTEB(35, 10, 35, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.green),
        child: const Text(
          "Analysis",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) {
      image = null;
    }
    final tempImage = File(pickedFile!.path);
    setState(() {
      image = tempImage;
      Navigator.pop(context);
    });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.green),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.green,
                  ),
                  ListTile(
                    onTap: () {
                      getImage(ImageSource.gallery);
                    },
                    title: const Text("Gallery"),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.green,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.green,
                  ),
                  ListTile(
                    onTap: () {
                      getImage(ImageSource.camera);
                    },
                    title: const Text("Camera"),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Card get ImagePickerCircleButton {
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
                        ))
                    : const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(
                          'assets/icons/leaves.png',
                        ),
                        radius: 70,
                      )),
            const Text(
              "Pick Image",
              style: TextStyle(fontSize: 20),
            )
          ],
        ));
  }
}
