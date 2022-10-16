import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tobaccov2/view/DetailPage.dart';

import '../main.dart';
import '../model/DatabaseModel.dart';
import 'CrudLeaf.dart';
import 'PostImage.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.details,
    required this.appBarname,
    required this.leafId
  }) : super(key: key);
  final List<LeafDetails>? details;
  final String appBarname;
  final int leafId;
  @override
  State<HomePage> createState() => _HomePageState();
}

Future main() async {
  runApp(const MyApp());
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          bottom: const TabBar(
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: 'Take'),
              Tab(
                text: 'History',
              ),
            ],
          ),
          title: const Text("Tobacco"),
        ),
        body: TabBarView(
          children: [ PostData(leafId: widget.leafId), DetailPage(details: widget.details)],
        ),
      ),
    );
  }
}
