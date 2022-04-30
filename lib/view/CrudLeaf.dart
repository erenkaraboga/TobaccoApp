
import 'dart:core';
import 'package:flutter/material.dart';
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
class _GetDataState extends State<GetData>with AutomaticKeepAliveClientMixin {
  late RequestService service;
  List<LeafDetails>? leafDetails;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
   service=new RequestService();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(centerTitle:true,title: Text("Quality Grade of Tobacco"),backgroundColor: Colors.green,),
      floatingActionButton: floatingActionButton,
      body: FutureBuilder<List<LeafModel>?>(
        future: service.getData(),
        builder: (context, snap){
          if(snap.connectionState==ConnectionState.done){
            if(snap.hasData){
              return ListView.builder(
                itemCount: snap.data?.length,
                itemBuilder: (context,index){
                  var model = LeafModel();
                  model=snap.data![index];
                  leafDetails=model.leafDetails;
                  return Column(
                    children: [
                      InkWell(
                        onTap: (){},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: FocusedMenuHolder(
                           menuWidth: MediaQuery.of(context).size.width*0.5,
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)
                              =>HomePage(details: model.leafDetails, appBarname:model.name!,)));
                            },
                            menuItems: <FocusedMenuItem>[
                              FocusedMenuItem(title: Text("Delete"), onPressed: (){
                                service.deleteData(model.leafId!).then((value) => {
                                  if(value!){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: const Text("Deleted Succesfuly")),
                                    ),
                                setState(() {

                                })}
                                });
                              },trailingIcon: Icon(Icons.delete))
                            ],
                            child: ListTile(
                              leading: const CircleAvatar(
                              backgroundImage: NetworkImage("https://media.istockphoto.com/photos/young-green-tobacco-leaves-plantation-in-the-tobacco-field-background-picture-id1209180744"),
                              ),
                              title: Text(model.name.toString()),
                              trailing: Text("id: "+model.leafId.toString()),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            }
            else {
              return const Text("data");
            }} else{
            return const Center(
                child: CircularProgressIndicator()
            );
          }
        },
      ),
    );
  }
  FloatingActionButton get floatingActionButton{
    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: const Icon(Icons.refresh),
      onPressed:(){
        setState(() {

        });
      },
    );
  }
  @override
  //Scroll işlemi için..
  bool get wantKeepAlive =>true;
}