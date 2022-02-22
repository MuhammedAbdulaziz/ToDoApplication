import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application/shared/cubit/states.dart';
import '../shared/components/components.dart';
import '../shared/cubit/cubit.dart';



class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
            var tasks = AppCubit.get(context).archivedTasks;
            return taskBuilder(tasks: tasks,);
        }
        );
  }
}
