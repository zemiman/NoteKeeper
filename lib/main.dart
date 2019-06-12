 import 'package:flutter/material.dart';
import 'package:flutter_app/app_screens/note_detail.dart';
import 'package:flutter_app/app_screens/note_list.dart';

 void main()=>runApp(MyApp());
 class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: NoteList(),   
    );
  }
}