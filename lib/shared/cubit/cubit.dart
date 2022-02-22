import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_application/shared/cubit/states.dart';
import '../../modules/archived_tasks.dart';
import '../../modules/done_tasks.dart';
import '../../modules/new_tasks.dart';


class AppCubit extends Cubit<AppStates>
{
  int currentScreen = 0;
  Database database;
  bool isOpenBottomSheet = false;
  IconData fabIcon = Icons.edit;
  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> screens =
  const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles =
  const [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List <Map> newTasks = [];
  List <Map> doneTasks = [];
  List <Map> archivedTasks = [];
  AppCubit() : super(AppInitialState());



  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon
  })
  {
    isOpenBottomSheet = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void changeCurrentIndex(int index)
  {
    currentScreen = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase()
   async {
     database =  await openDatabase('todo.db', version: 1,
      onCreate: (db,version)  {
        if (kDebugMode) {
          print('Database is Created');
        }
         db.execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
        if (kDebugMode) {
          print('Table is Created');
        }
      },

      onOpen: (db){
        getDataFromDatabase(db);
        if (kDebugMode) {
          print('Database is Opened');
        }
      },
    );
  }

   insertToDatabase(
      String title,
      String time,
      String date,
      ) async
  {
    await database.transaction((txn)
      async {
      assert(txn != null);
      txn.rawInsert('INSERT INTO Tasks(title,date,time,status) VALUES("$title","$time","$date","New")',
      ).then((value) {
        if (kDebugMode) {
          print("INSERTED");
        }
        emit(AppInsertToDataBaseState());
        getDataFromDatabase(database);
      }).catchError((error)
      {
        if (kDebugMode) {
          print("ERROR:${error.toString()}");
        }
      });
    }
    );
  }
  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetFromDataBaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value)
    {

      value.forEach((element) {
        if(element['status']=='New')
        {
          newTasks.add(element);
        }
        else if(element['status']=='Done')
        {
          doneTasks.add(element);
        }
        else
        {
          archivedTasks.add(element);
        }
      });
      database = value;
      emit(AppGetFromDataBaseState());
    });
  }

  void deleteData(int id)
  async{
    {
      database.rawDelete(
        'DELETE FROM Tasks WHERE id = ?',
        [id],
      ).then((value)
      {
        getDataFromDatabase(database);
        emit(AppDeleteDataBaseState());});
    }

  }

   void updateDate(
  {
    @required String status,
    @required int id,
    }
      ) async{
        database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
        [status, id],
        ).then((value)
      {
        getDataFromDatabase(database);
        emit(AppUpdateDataBaseState());});
  }
}