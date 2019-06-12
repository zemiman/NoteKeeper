import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_app/models/note.dart';
import 'package:flutter_app/utils/database_helper.dart';

class NoteDetail extends StatefulWidget{
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteDetailState(this.note, this.appBarTitle);
  }

}
class NoteDetailState extends State<NoteDetail>{
  DatabaseHelper helper=DatabaseHelper();
  String appBarTitle;
  Note note;
  static var _prioirties=["High","Low"];
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  NoteDetailState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle=Theme.of(context).textTheme.title;
    // TODO: implement build
    titleController.text=note.title;
    descriptionController.text=note.description;
    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child:Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            moveToLastScreen();
          },
        )
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, right: 10.0, left: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _prioirties.map((String dropDownStringItems){
                  return DropdownMenuItem<String>(
                    value: dropDownStringItems,
                    child: Text(dropDownStringItems),
                  );
                }).toList(),
                style: textStyle,
                value: getPriorityAsString(note.priority),
                onChanged: (selectedValue){
                  setState(() {
                    debugPrint("Usetr selected $selectedValue");
                    updatePriorityAsInt(selectedValue);
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 12.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value){
                  debugPrint("something is changed in the title text field!");
                  updateTitle();
                },
                decoration: InputDecoration(
                  labelText: 'title',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 12.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value){
                  debugPrint("something is changed in the description text field!");
                  updateDescription();
                },
                decoration: InputDecoration(
                  labelText: 'description',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text("Save",
                      textScaleFactor: 1.3,
                      ),
                      onPressed: (){
                        setState(() {
                         debugPrint("Save button clicked"); 
                         _saveNote();
                        });
                      },
                    ),
                  ),
                  Container(width: 5.0,),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text("Delete",
                      textScaleFactor: 1.3,
                      ),
                      onPressed: (){
                        setState(() {
                         debugPrint("Delete button clicked"); 
                         _delete();
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
  void moveToLastScreen(){
    Navigator.pop(context, true);
  }
  void updatePriorityAsInt(String value){
    switch(value){
      case "High":
        note.priority=1;
        break;
      case "Low":
        note.priority=2;
        break;
      default:
        note.priority=2; 
    }
  }
  String getPriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority=_prioirties[0];
        break;
      case 2:
        priority=_prioirties[1];
        break;
    }
    return priority;
  }
  void updateTitle(){
    note.title=titleController.text;

  }
  void updateDescription(){
    note.description=descriptionController.text;
  }
  void _delete() async{
    moveToLastScreen();
    //case 1: if user is trying to delete a new Note i.e he has come to the
    //detail page by pressing the FAB of NoteList page:
    if(note.id==null){
      _showAlertDialog('Status', 'No Note Was Deleted!');
      return;
    }
    int result=await helper.deleteNote(note.id);
    if(result!=0){
      _showAlertDialog('Status', 'Note Deleted successfully!');
    }else{
      _showAlertDialog('Status', 'Error Occured While Deleting Note!');
    }

    //case 2: user is trying to delete an old note that has already a valid id:
  }
  void _saveNote() async{
    moveToLastScreen();
    note.date=DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id!=null){
      result=await helper.updateNote(note);//this is an Update operation:
    }else{
      result=await helper.insertNote(note);
    }
    if(result!=0){
      _showAlertDialog('Status', 'Note Saved successfully!');
    }else{
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }
  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog=AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_)=>alertDialog
    );
  }

}