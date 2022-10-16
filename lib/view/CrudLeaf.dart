import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:tobaccov2/view/HomePage.dart';
import '../model/DatabaseModel.dart';
import '../service/RequestServiceHelper.dart';

class GetData extends StatefulWidget {
  const GetData({Key? key}) : super(key: key);
  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> with AutomaticKeepAliveClientMixin {
  late RequestService service;
  List<LeafDetails>? leafDetails;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  @override
  void initState() {
    service = RequestService();
    nameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Quality Grade of Tobacco"),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: customFloatButton(context),
      body: FutureBuilder<List<LeafModel>?>(
        future: service.getData(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            if (snap.hasData) {
              return ListView.builder(
                itemCount: snap.data?.length,
                itemBuilder: (context, index) {
                  var model = LeafModel();
                  model = snap.data![index];
                  leafDetails = model.leafDetails;
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: FocusedMenuHolder(
                            menuWidth: MediaQuery.of(context).size.width * 0.5,
                            onPressed: () {},
                            menuItems: <FocusedMenuItem>[
                              FocusedMenuItem(
                                  title: const Text("Delete"),
                                  onPressed: () {
                                    service
                                        .deleteData(model.leafId!)
                                        .then((value) => {
                                              if (value!)
                                                {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            "Deleted Succesfuly")),
                                                  ),
                                                  setState(() {})
                                                }
                                            });
                                  },
                                  trailingIcon: const Icon(Icons.delete))
                            ],
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomePage(
                                              details: model.leafDetails,
                                              appBarname: model.name!,
                                              leafId: model.leafId!,
                                            )));
                              },
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://media.istockphoto.com/photos/young-green-tobacco-leaves-plantation-in-the-tobacco-field-background-picture-id1209180744"),
                                ),
                                title: Text(model.name.toString()),
                                trailing:
                                    Text("id: " + model.leafId.toString()),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            } else {
              return const Text("data");
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  SpeedDial customFloatButton(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      overlayOpacity: 0,
      backgroundColor: Colors.green,
      children: [
        SpeedDialChild(
            onTap: () {
              setState(() {});
            },
            child: const Icon(Icons.refresh),
            backgroundColor: Colors.green.shade300),
        SpeedDialChild(
          onTap: () {
            _createLeafDialog(context);
          },
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  Future<void> _createLeafDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Leaf Name ? ",
              style: TextStyle(color: Colors.green),
            ),
            content: Form(
              key: formKey,
              child: TextFormField(
                autofocus: true,
                cursorColor: Colors.green,
                controller: nameController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "It cant be Empty";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var result = service.createLeaf(nameController.text);
                      result.then((value) => {
                            if (value!)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Created"))),
                                setState(() {
                                  Navigator.pop(context);
                                })
                              }
                          });
                    }
                  },
                  child: const Text("CREATE"))
            ],
          );
        });
  }

  @override
  //Scroll işlemi için..
  bool get wantKeepAlive => true;
}
