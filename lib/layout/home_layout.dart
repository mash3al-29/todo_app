import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';


class home_layout extends StatelessWidget {
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textcontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoAppCubit()..createDatabase()..handleScroll(),
      child: BlocConsumer<TodoAppCubit,TodoCubitstates>(
        listener: (context,state){
          if(state is ChangeInsertDatabase){
            Navigator.pop(context);
          }
        },
        builder:(context,state) {
         TodoAppCubit cubit = TodoAppCubit.get(context);
            return Scaffold(
          key: ScaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
          ),
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton:
          FloatingActionButton(
            onPressed: () {
                if (cubit.sheetshown) {
                  Navigator.pop(context);
                  cubit.sheetshown = false;
                  cubit.ChangeBottomSheetIcon(iconfab: Icons.edit);
                }
                else {
                  ScaffoldKey.currentState
                      .showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child: Container(
                            child: Form(
                              key: formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DefaultTextFormField(
                                    controller: textcontroller,
                                    prefixicon: Icons.title,
                                    type: TextInputType.text,
                                    LabelText: 'Task Title',
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return ('Title must not be empty');
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 15,),
                                  DefaultTextFormField(
                                    controller: timecontroller,
                                    prefixicon: Icons.watch_later_rounded,
                                    type: TextInputType.datetime,
                                    LabelText: 'Task Time',
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return ('Time must not be empty');
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timecontroller.text =
                                            value.format(context).toString();
                                      });
                                    },
                                  ),
                                  SizedBox(height: 15,),
                                  DefaultTextFormField(
                                    controller: datecontroller,
                                    prefixicon: Icons.calendar_today_outlined,
                                    type: TextInputType.datetime,
                                    LabelText: 'Task Date',
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return ('Date must not be empty');
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse(
                                            '3000-12-31'),
                                      ).then((value) {
                                        datecontroller.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    },
                                  ),
                                  SizedBox(height: 15,),
                                  DefaultButton(function: () {
                                    if (formkey.currentState.validate()) {
                                      cubit.insertDatabase(
                                          textcontroller.text,
                                          timecontroller.text,
                                          datecontroller.text).then((value) {
                                        textcontroller.clear();
                                        timecontroller.clear();
                                        datecontroller.clear();
                                      });
                                    }
                                  },
                                    text: 'Add Note',
                                    color: Colors.blue,
                                    radius: 30,
                                    textColor: Colors.grey[200],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    elevation: 20,
                  )
                      .closed
                      .then((value) {
                    cubit.sheetshown = false;
                    cubit.ChangeBottomSheetIcon(iconfab: Icons.edit);
                  });
                  cubit.sheetshown = true;
                  cubit.ChangeBottomSheetIcon(iconfab: Icons.add);
                }
              }
              ,
              child: Icon(cubit.icon),
              ),
          bottomNavigationBar: BottomNavigationBar(items:
          [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Tasks',),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box_outlined),
              label: 'Done',),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label: 'Archived',),
          ],
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.Equalismcurrentindexandindex(index);
            },
            type: BottomNavigationBarType.fixed,

          ),
        );
        }
      ),
    );
  }



//id,title,date,time
}

