
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class done_tasks_screen extends StatelessWidget {
  const done_tasks_screen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit,TodoCubitstates>(
      listener: (context,state){
      },
      builder: (context,state){
        return  BuildItems(TodoAppCubit.get(context).Donetasks,'No Done Tasks Yet, Finish Some Tasks Now!');
      },);
  }
}
