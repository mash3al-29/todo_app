import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class new_tasks_screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit,TodoCubitstates>(
      listener: (context,state){
      },
      builder: (context,state){
        return BuildItems(
            TodoAppCubit.get(context).Newtasks,'No New Added Tasks Yet, Add Some Tasks!'
        );
      },);

  }
}
