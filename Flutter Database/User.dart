import 'dart:convert';
import 'package:matrimony_app/my_database.dart';
import 'package:matrimony_app/utils.dart';

class User {
  List<Map<String, dynamic>> userlist = [];

  Future<void> addUserToList(
      String name,
      String address,
      String email,
      String mobile,
      String city,
      String gender,
      DateTime dob,
      Map<String, bool> hobbies,
      String password,
      bool favorite) async {
    final db = await MyDatabase().initDatabase();
    final jsonHobbies = jsonEncode(hobbies);

    Map<String, dynamic> map = {};
    map[Name] = name;
    map[Address] = address;
    map[Email] = email;
    map[Mobile] = mobile;
    map[City] = city;
    map[Gender] = gender;
    map[DOB] = dob.toIso8601String();
    map[Hobbies] = jsonHobbies;
    map[Password] = password;
    map[Favorite] = favorite ? 1 : 0;

    await db.insert(MyDatabase.TBL_USER, map);

    await getUserList();
  }

  Future<List<Map<String, dynamic>>> getUserList() async {
    final db = await MyDatabase().initDatabase();
    final result = await db.query(MyDatabase.TBL_USER);

    userlist = result
        .map((json) => {
              USER_ID: json[USER_ID],
              Name: json[Name],
              Address: json[Address],
              Email: json[Email],
              Mobile: json[Mobile],
              City: json[City],
              Gender: json[Gender],
              DOB: DateTime.parse(json[DOB] as String),
              Hobbies:
                  Map<String, bool>.from(jsonDecode(json[Hobbies] as String)),
              Password: json[Password],
              Favorite: json[Favorite] == 1,
            })
        .toList();

    return userlist;
  }

  Future<void> deleteUser(int id) async {
    final db = await MyDatabase().initDatabase();
    await db.delete(MyDatabase.TBL_USER,
        where: '${MyDatabase.USER_ID} = ?', whereArgs: [id]);

    await getUserList();
  }

  Future<void> updateUserInList(
      int id,
      String name,
      String address,
      String email,
      String mobile,
      String city,
      String gender,
      DateTime dob,
      Map<String, bool> hobbies,
      String password,
      bool favorite) async {
    final db = await MyDatabase().initDatabase();

    final jsonHobbies = jsonEncode(hobbies);

    Map<String, dynamic> map = {};
    map[Name] = name;
    map[Address] = address;
    map[Email] = email;
    map[Mobile] = mobile;
    map[City] = city;
    map[Gender] = gender;
    map[DOB] = dob.toIso8601String();
    map[Hobbies] = jsonHobbies;
    map[Password] = password;
    map[Favorite] = favorite ? 1 : 0;

    await db.update(MyDatabase.TBL_USER, map,
        where: '${MyDatabase.USER_ID} = ?', whereArgs: [id]);

    await getUserList();
  }
}
