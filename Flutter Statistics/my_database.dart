import 'package:matrimony_app/utils.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static const String TBL_USER = 'Tbl_User';
  static const String USER_ID = 'User_Id';

  int DB_VERSION = 1;

  Future<Database> initDatabase() async {
    Database db = await openDatabase('${await getDatabasesPath()}/Matrimony.db',
        onCreate: (db, version) {
      db.execute('''
          CREATE TABLE $TBL_USER(
            $USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $Name TEXT NOT NULL,
            $Address TEXT NOT NULL,
            $Email TEXT NOT NULL,
            $Mobile TEXT NOT NULL,
            $City TEXT NOT NULL,
            $Gender TEXT NOT NULL,
            $DOB TEXT NOT NULL,
            $Hobbies TEXT NOT NULL,
            $Password TEXT NOT NULL,
            $Favorite BOOLEAN NOT NULL
          );
          ''');
    }, version: DB_VERSION);
    return db;
  }
}
