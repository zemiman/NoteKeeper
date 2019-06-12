import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
//import 'package:FLUTTER_APP/models/note.dart';
class DatabaseHelper{
  static DatabaseHelper _databaseHelper;//singleton DatabaseHelper
  static Database _database;//singleton Database
  String noteTable="note_table";
  String colId='id';
  String colTitle='title';
  String colDescription='description';
  String colPriority='priority';
  String colDate='date';
  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if(_databaseHelper==null){
      _databaseHelper=DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async{
    if(_database==null){
      _database=await initializeDatabase();
    }
    return _database;
  }

  //get id => null;
  Future<Database> initializeDatabase() async{
    //get the directory path for both android and ios to store database:
    Directory directory=await getApplicationDocumentsDirectory();
    String path=directory.path+'notes.db';
    //open/create the databaseat a given path:
    var notesDatabase=await openDatabase(path, version:1, onCreate:_createDb);
    return notesDatabase;
  }
  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT'
    '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');

  }
  //Fetch Operation:get all note objects from database
Future<List<Map<String, dynamic>>> getNoteMapList() async {
  Database db=await this.database;
  //var result=await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
  var result=await db.query(noteTable, orderBy: '$colPriority ASC');
  return result;
}
//Insert Operation:insert a Note object to database
Future<int> insertNote(Note note) async{
  Database db=await this.database;
  var result=await db.insert(noteTable, note.toMap());
  return result;
}
//Update Operation:Update a Note object and save to database
Future<int> updateNote(Note note) async{
  Database db=await this.database;
  var result=await db.update(noteTable, note.toMap(), where: '$colId=?', whereArgs: [note.id]);
  return result;
}
//Delete operation:delete a Note object from database
Future<int> deleteNote(int id) async{
  Database db=await this.database;
  var result=await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
}
//Get number of Note objects in database
Future<int> getCount() async{
  Database db=await this.database;
  List<Map<String, dynamic>> x=await db.rawQuery('SELECT count(*) FROM $noteTable');
  int result=Sqflite.firstIntValue(x);
  return result;

}
//Get the 'Map List' [List[Map]] and convert to it into 'Note List' [List[Note]]
Future<List<Note>> getNoteList() async{
  var noteMapList=await getNoteMapList();// Get Map list from database:
  int count=noteMapList.length;
  List<Note> noteList=List<Note>();
  for(int i=0;i<count;i++){
    noteList.add(Note.fromMapObject(noteMapList[i]));
  }
  return noteList;
}

}