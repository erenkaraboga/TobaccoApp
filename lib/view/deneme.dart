import 'package:flutter/material.dart';
class deneme extends StatefulWidget {
  const deneme({Key? key}) : super(key: key);

  @override
  _denemeState createState() => _denemeState();
}

class _denemeState extends State<deneme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView.builder(scrollDirection: Axis.horizontal,itemCount: 10,itemBuilder: (context,index){
        return Column(
          children:  [
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(0, 400, 0, 0),
              child: Image(image: NetworkImage("https://media.istockphoto.com/photos/young-green-tobacco-leaves-plantation-in-the-tobacco-field-background-picture-id1209180744"),
              height: 150,
              width: 150,
              ),
            )
          ],
        );

      }),

    );
  }
}
