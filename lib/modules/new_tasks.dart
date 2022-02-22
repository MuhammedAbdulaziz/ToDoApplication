import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application/shared/components/components.dart';
import 'package:todo_application/shared/cubit/cubit.dart';
import 'package:todo_application/shared/cubit/states.dart';



class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return BlocConsumer<AppCubit,AppStates>(
          listener: (context, states){},
          builder: (context, states){
          var tasks = AppCubit.get(context).newTasks;
            return taskBuilder(tasks: tasks,);
        }
    );
  }
}
