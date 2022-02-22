import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_application/shared/cubit/cubit.dart';



Widget defaultButton ({
  double width = double.infinity,
  Color background = Colors.blue,
  bool uppercase = true,
  double radius = 3,
  @required Function function ,
  @required String text,
}) =>  Container(
  width: width,
  height: 40.0,
  child: MaterialButton(
    onPressed:() => function,
    child: Text(
      uppercase? text.toUpperCase() : text.toLowerCase(),
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
);

Widget defaultFormField(
    {
      @required TextEditingController controller,
      @required TextInputType type,
      @required Function validate,
      @required String label,
      bool isPass = false,
      Function onSubmit,
      Function onChange,
      Function onTap,
      Function suffixPressed,
      bool isClickable = true,
      IconData prefix,
      IconData suffix,
    }
    ) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPass,
  validator: validate,
  onFieldSubmitted:(String value)=>onSubmit,
  onChanged: (String value)=>onChange,
  onTap: onTap,
  enabled: isClickable,
  decoration:  InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefix),
    suffixIcon:suffix!=null?
    IconButton(
      onPressed:()=>suffixPressed,
      icon:Icon(suffix),
    ):null,
    border: const OutlineInputBorder(),

  ),
);

Widget buildTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children:  [

         CircleAvatar(

          radius: 40.0,

          child: Text(

            '${model['date']}',

          ),

        ),

        const SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                '${model['title']}',

                style: const TextStyle(

                  fontWeight: FontWeight.bold,

                ),

              ),

              const SizedBox(

                height: 10.0,

              ),

              Text(

                '${model['time']}',

                style: const TextStyle(

                  color: Colors.grey,

                ),

              ),

            ],

          ),

        ),

        const SizedBox(

          width: 20.0,

        ),

        IconButton(

            onPressed:()

              {

                AppCubit.get(context).updateDate(status: 'Done', id: model['id'],);

              } ,

            icon: const Icon(

              Icons.check_box,

              color: Colors.green,)),

        IconButton(

            onPressed:()

            {

              AppCubit.get(context).updateDate(status: 'Archive', id: model['id'],);

            } ,

            icon: const Icon(

              Icons.archive,

              color: Colors.black45,

            )),

      ],

    ),

  ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(model['id'],);
  },
);

Widget taskBuilder({@required List<Map> tasks}) => ConditionalBuilder(condition: tasks.isNotEmpty,
  builder:(context) =>  ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          size:100.0,
          color: Colors.grey,
        ),
        Text(
          "No Tasks Yet !! Please Add New Tasks",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
);