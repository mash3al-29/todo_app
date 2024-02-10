

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget DefaultButton({
  bool isUpperCase = false,
  double width = double.infinity,
  Color color = Colors.tealAccent,
  double radius = 0.0,
  @required Function function,
  @required String text,
  double elevation = 20,
  Color textColor = Colors.white,
}) => Container(

  width: width,
  height: 40,
  decoration: BoxDecoration(
    borderRadius: BorderRadiusDirectional.circular(radius),
    color: color,
  ),
  child: MaterialButton(
    elevation: elevation,
    height: 40,
    onPressed: function,
    child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: textColor,
      ),
    ),
  ),
);

Widget DefaultTextFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  @required String LabelText,
  Function SubmitFunction,
  Function ChangeFunction,
  IconData prefixicon,
  @required Function validate,
  IconData SufixIcon,
  bool isObscure = false,
  Function isSuffixpressed,
  Function onTap,
  bool enabled,
}) => TextFormField(
  controller: controller,
  onFieldSubmitted: SubmitFunction,
  onChanged: ChangeFunction ,
  enabled: enabled,
  keyboardType: type ,
  obscureText: isObscure,
  onTap: onTap,
  decoration: InputDecoration(
    labelText: LabelText,
    prefixIcon: Icon(
      prefixicon,
    ),
    suffixIcon: SufixIcon!= null ? IconButton(icon : Icon(SufixIcon),onPressed: isSuffixpressed, ): null,
    border: OutlineInputBorder(),
  ),

  validator: validate,
);

Widget DefaultListOfItems(Map Model , context) => Dismissible(
  key: Key('${Model['id']}'),
  child:Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${Model['time']}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),),
          ),
          SizedBox(width: 25,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${Model['title']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 5,),
                Text('${Model['date']}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[400],
                  ),),
                SizedBox(width: 5,),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.check_box,color: Colors.green,),
                  onPressed: (){
                    TodoAppCubit.get(context).UpdateDataBase('DONE', Model['id']);
              }),
              SizedBox(width: 5,),
              IconButton(
                  icon: Icon(Icons.archive,color: Colors.red,),
                  onPressed: (){
                    TodoAppCubit.get(context).UpdateDataBase('ARCHIVED', Model['id']);
              }),
            ],
          ),
        ],
      ),
    ),
  onDismissed: (direction){
    TodoAppCubit.get(context).DeleteDatabase(Model['id']);
  },
);


Widget BuildItems(List<Map> tasks , String text){

    return ConditionalBuilder(
    condition: tasks.length == 0,
    builder: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu,size: 100,),
          Text(
            text,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),),
        ],
      ),
    ),
    fallback: (context) =>
        ListView.separated(
        itemBuilder:
            (context,index) => DefaultListOfItems(tasks[index],context),
        separatorBuilder: (context,index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[400],
          ),
        ),
        itemCount: tasks.length),
  );

}

