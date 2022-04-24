
import 'dart:core';
import 'package:flutter/material.dart';




import '../model/DatabaseModel.dart';
import '../service/RequestServiceHelper.dart';
import 'DetailPage.dart';


class GetData extends StatefulWidget {
  const GetData({Key? key}) : super(key: key);
  @override
  _GetDataState createState() => _GetDataState();
}
class _GetDataState extends State<GetData>with AutomaticKeepAliveClientMixin {
  late RequestService service;
  List<LeafDetails>? leafDetails;
  @override
  void initState() {
   service=new RequestService();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)
                          =>DetailPage(details:leafDetails,)));
                        },
                        child: ListTile(
                          leading: const CircleAvatar(
                          backgroundImage: NetworkImage("https://media.istockphoto.com/photos/young-green-tobacco-leaves-plantation-in-the-tobacco-field-background-picture-id1209180744"),
                          ),
                          title: Text(model.name.toString()),
                          trailing: Text("id: "+model.leafId.toString()),
                        ),
                      )
                    ],
                  );
                },
              );
            }
            else {
              return const Text("data");
            }
          }
          else{
            return const Center(
                child: CircularProgressIndicator(
                )
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
  bool get wantKeepAlive =>true;
}