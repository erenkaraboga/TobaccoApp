import 'dart:ffi';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tobaccov2/view/deneme.dart';



import '../main.dart';
import 'GetLeafs.dart';
import 'PostImage.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key,}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}
Future main()async {
  runApp(const MyApp());

}
class _HomePageState extends State<HomePage> {
  final screens= [
    PostData(),
    GetData(),
  ];
  int index = 1;
  @override
  Widget build(BuildContext context) {
    final items=<Widget>[
      Icon(CupertinoIcons.photo_camera,color: Colors.grey.shade800,),
      Icon(CupertinoIcons.down_arrow,color: Colors.grey.shade800,),

    ];
    return Scaffold(
      bottomNavigationBar:buildCurvedNavigationBar(items),
      body: screens[index],
    );
  }
  CurvedNavigationBar buildCurvedNavigationBar(List<Widget> items) {
    return CurvedNavigationBar(items: items,
      color: Colors.green.shade300,
      height: 60,
      index: index,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeOutCubic,
      onTap:(index)=>setState(() {
        this.index=index;
      }),
    );
  }
}
