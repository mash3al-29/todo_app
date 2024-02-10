
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:flutter/rendering.dart';

class TodoAppCubit extends Cubit<TodoCubitstates>{
  TodoAppCubit() : super(Init_to_do_cubit());

  static TodoAppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    new_tasks_screen(),
    done_tasks_screen(),
    archived_tasks_screen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  int currentIndex = 0;
  Database database;
  List<Map> Newtasks = [];
  List<Map> Donetasks = [];
  List<Map> Archivedtasks = [];
  IconData icon = Icons.edit;
  bool sheetshown = false;

  ScrollController scrollController = new ScrollController();
  bool show = true;
  bool visible = true;

  void Equalismcurrentindexandindex(index){
    currentIndex = index;
    emit(ChangeAppNavBarCubit());
  }
  void createDatabase(){
    openDatabase(
        'to-do.db',
        version: 1,
        onCreate: (database, version) async {
          print('database created');
          await database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) =>
              print('Table Created')
          ).catchError((error) {
            print('Error while creating table ${error.toString()}');
          });
        },
        onOpen: (database) {
          GetFromDatabase(database);
        }
    ).then((value) {
      database = value;
      emit(ChangeCreateDatabase());
    });
  }

  Future insertDatabase(
      String title,
      String time,
      String date,) async {
    return await database.transaction((trans) async {
      await trans.rawInsert(
        'INSERT INTO tasks (title , time , date , status) VALUES("$title","$time","$date","NEW")',)
          .then((value) =>
          print('$value Inserted'));
          emit(ChangeInsertDatabase());
          GetFromDatabase(database);
    }
    );
  }

  void GetFromDatabase(database) {

    Newtasks = [];
    Donetasks = [];
    Archivedtasks = [];

    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if(element['status'] == 'NEW'){
          Newtasks.add(element);
        }else if(element['status'] == 'DONE'){
          Donetasks.add(element);
        }else{
          Archivedtasks.add(element);
        }
      });
      emit(ChangeGetDatabase());
      print(value);
    }
    );
  }

  void UpdateDataBase(String status, int id)
  {
      database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]
      ).then((value) {
          GetFromDatabase(database);
          emit(ChangeUpdateDatabase());
     }).catchError((error){
       print('error is ${error.toString()}');
      });
  }

  void DeleteDatabase (int id)
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id])
    .then((value) {
      GetFromDatabase(database);
      emit(ChangeDeleteDatabase());

    }).catchError((error){
      print('error is ${error.toString()}');
    });
  }

  void ChangeBottomSheetIcon({
  @required IconData iconfab,
})
  {
    icon = iconfab;
    emit(ChangeBottomSheet());
  }


  void FadeOut(){
    visible = false;
    emit(Fadeout());
  }


  void FadeIn(){
    visible = true;
    emit(Fadein());
  }


  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        FadeOut();
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        FadeIn();
      }
    });
  }


}