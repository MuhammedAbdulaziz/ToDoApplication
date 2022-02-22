import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/shared/components/components.dart';
import 'package:todo_application/shared/cubit/cubit.dart';
import 'package:todo_application/shared/cubit/states.dart';




class HomeScreen extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state)
        {
          if(state is AppInsertToDataBaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context,state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Text(cubit.titles[cubit.currentScreen],),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetFromDataBaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentScreen],
              fallback: (context) =>
              const Center(child: CircularProgressIndicator(),),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isOpenBottomSheet) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(titleController.text, timeController.text, dateController.text);
                  }
                }
                else {
                  scaffoldKey.currentState.showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'MUST NOT BE EMPTY';
                                      }
                                      return null;
                                    },
                                    label: 'Task Title',
                                    prefix: Icons.title,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: timeController,
                                    type: TextInputType.text,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value.format(context).toString();
                                        //if (kDebugMode) {
                                          print(value.format(context));
                                        //}
                                      });
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'MUST NOT BE EMPTY';
                                      }
                                      return null;
                                    },
                                    label: 'Task Time',
                                    prefix: Icons.watch_later_outlined,
                                    // isClickable: false,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-03-25'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'MUST NOT BE EMPTY';
                                      }
                                      return null;
                                    },
                                    label: 'Task Date',
                                    prefix: Icons.date_range_sharp,
                                    // isClickable: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    elevation: 20.0,
                  ).closed
                      .then((value) {
                   cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon,),),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubit.get(context).currentScreen,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                AppCubit.get(context).changeCurrentIndex(index);
              },
              items:
              const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline_sharp,),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined,),
                    label: 'Archive'
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}