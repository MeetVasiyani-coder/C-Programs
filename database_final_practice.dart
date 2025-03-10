import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApiPractice(),
    )
  );
}

class ApiPractice extends StatefulWidget {
  const ApiPractice({super.key});

  @override
  State<ApiPractice> createState() => _ApiPracticeState();
}

class _ApiPracticeState extends State<ApiPractice> {

  static const baseUrl = 'https://67b41a64392f4aa94fa953b7.mockapi.io/Demo';

  List<Map<String,dynamic>> userlist = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  void initState(){
    super.initState();
    setState(() {
      getUsers();
    });
  }

  Future<void> getUsers() async{
    final response = await http.get(Uri.parse(baseUrl));
    setState(() {
      List<dynamic> temp = json.decode(response.body);
      userlist = temp.map((user) => user as Map<String,dynamic>).toList();  
    });
  }

  Future<void> addUser(String name,String city) async{
    final response = await http.post(Uri.parse(baseUrl),body : {
      "Name" : name,
      "City" : city
    });

    getUsers();
  }

  Future<void> deleteUser(String? id) async{
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    getUsers();
  }

  Future<void> updateUser(String id,String name,String city) async{
    final response = await http.put(Uri.parse('$baseUrl/$id'),body : {
      "Name" : name,
      "City": city
    });

    getUsers();
  }

  void clearControllers(){
    nameController.clear();
    cityController.clear();
  }

  Future<dynamic> showBottomSheet(String? id) async{
    return showModalBottomSheet(context: context, builder: (context) {
      return Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Name"
            ),
          ),

          TextFormField(
            controller: cityController,
            decoration: InputDecoration(
              labelText: "City"
            ),
          ),

          ElevatedButton(onPressed: (){
            if(id != null){
              updateUser(id, nameController.text, cityController.text).then((value) {
                Navigator.pop(context);
                setState(() {
                  clearControllers();
                  getUsers();
                });
              },);
            }
            else{
              addUser(nameController.text, cityController.text).then((value) {
                Navigator.pop(context);
                setState(() {
                  clearControllers();
                  getUsers();
                });
              },);
            }
          }, child: Text("Save"))
        ],
      );
    },).whenComplete(() {
          clearControllers();
          getUsers();
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD"),
        actions: [
          IconButton(onPressed:() {
            showBottomSheet(null).then((value) {
              setState(() {
                getUsers();
              });
            },);
          }, icon: Icon(Icons.add))
        ],
      ),

      body: ListView.builder(itemCount: userlist.length,itemBuilder: (context, index) {
        return ListTile(
          title: Text(userlist[index]['Name']),
          subtitle: Text(userlist[index]['City']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              IconButton(onPressed: () {
                nameController.text = userlist[index]['Name'];
                cityController.text = userlist[index]['City'];
                showBottomSheet(userlist[index]['id']).then((value) {
                  setState(() {
                    getUsers();
                  });
                },);
              }, icon: Icon(Icons.edit)),

              IconButton(onPressed: () {
                deleteUser(userlist[index]['id']).then((value) {
                  setState(() {
                    getUsers();
                  });
                },);
              }, icon: Icon(Icons.delete)),

            ],
          ),
        );
      },)

    );
  }
}

/*

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DatabaseFinalPractice(),
    )
  );
}

class MyDatabase{

  static const String TABLE_NAME = 'myTable';
  static const String NAME = 'name';
  static const String CITY = 'city';
  static const String USER_ID = 'User_Id';

  int DB_VERSION = 1;

  Future<Database> initDatabase() async{
    Database db = await openDatabase('${getDatabasesPath()}/database.db',
      onCreate: (db, version) {
        db.execute(
          '''
          CREATE TABLE $TABLE_NAME(
          $USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $NAME TEXT NOT NULL,
          $CITY TEXT NOT NULL
          )
          '''
        );
      },
      version: DB_VERSION
    );
    return db;
  }
}

class DatabaseFinalPractice extends StatefulWidget {
  const DatabaseFinalPractice({super.key});

  @override
  State<DatabaseFinalPractice> createState() => _DatabaseFinalPracticeState();
}

class _DatabaseFinalPracticeState extends State<DatabaseFinalPractice> {
  List<Map<String,dynamic>> User = [];
  List<Map<String,dynamic>> filteredUser = [];


  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  void initState(){
    super.initState();
    setState(() {
      getUsers();
      filteredUser = User;
    });
  }

  Future<void> getUsers() async{
    final db  = await MyDatabase().initDatabase();
    User = await db.query(MyDatabase.TABLE_NAME);
    filteredUser = User;
    setState(() {});
  }

  Future<void> addUser(String Name, String City) async{
    final db = await MyDatabase().initDatabase();
    await db.insert(MyDatabase.TABLE_NAME, {
      MyDatabase.NAME : Name,
      MyDatabase.CITY : City
    });
    getUsers();
  }

  Future<void> updateUser(int User_Id,String Name, String City) async{
    final db = await MyDatabase().initDatabase();
    await db.update(MyDatabase.TABLE_NAME, {
      MyDatabase.NAME : Name,
      MyDatabase.CITY : City
    },
    where: 'User_Id = ?',
    whereArgs: [User_Id]
    );
    getUsers();
  }

  Future<void> deleteUser(int User_Id) async{
    final db = await MyDatabase().initDatabase();
    await db.delete(MyDatabase.TABLE_NAME,
    where: 'User_Id = ?',
    whereArgs: [User_Id]
    );
    getUsers();
  }

  void searchUsers(String? search){
    if(search!.isEmpty){
      filteredUser = User;
    }
    else{
      filteredUser = User.where((element) {
       return element[MyDatabase.NAME].toString().toLowerCase().contains(search.toLowerCase());
      },).toList();
    }
    setState(() {});
  }

  void clearControllers(){
    nameController.clear();
    cityController.clear();
  }

  Future<dynamic> showBottomSheet(int? User_Id) async {
    return showModalBottomSheet(context: context, builder: (context) {
      return Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Name"
            ),
          ),

          TextFormField(
            controller: cityController,
            decoration: InputDecoration(
              labelText: "City"
            ),
          ),

          ElevatedButton(onPressed: (){
            if(User_Id != null){
              updateUser(User_Id, nameController.text, cityController.text).then((value) {
                Navigator.pop(context);
                setState(() {
                  clearControllers();
                  getUsers();
                });
              },);
            }
            else{
              addUser(nameController.text, cityController.text).then((value) {
                Navigator.pop(context);
                setState(() {
                  clearControllers();
                  getUsers();
                });
              },);
            }
          }, child: Text("Save"))
        ],
      );
    },).whenComplete(() {
      clearControllers();
      setState(() {
        getUsers();
      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD"),
        actions: [
          IconButton(onPressed: (){
            showBottomSheet(null).then((value) {
              setState(() {
                getUsers();
              });
            },);
          }, icon: Icon(Icons.add))
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search"
              ),
              onChanged: (value) {
                searchUsers(value);
              },
            ),
          ),
          Expanded(child: 
            ListView.builder(
              itemCount: filteredUser.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredUser[index][MyDatabase.NAME]),
                  subtitle: Text(filteredUser[index][MyDatabase.CITY]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        nameController.text = filteredUser[index][MyDatabase.NAME];
                        cityController.text = filteredUser[index][MyDatabase.CITY];
                        showBottomSheet(filteredUser[index][MyDatabase.USER_ID]).then((value) {
                          setState(() {
                            getUsers();
                          });
                        },);
                      }, icon: Icon(Icons.edit)),

                      IconButton(onPressed: (){
                        deleteUser(filteredUser[index][MyDatabase.USER_ID]).then((value) {
                          setState(() {
                            getUsers();
                          });
                        },);
                      }, icon: Icon(Icons.delete))
                    ],
                  ),
                );
              },)
          ),
        ],
      ),
    );
  }
}

*/

/*
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DatabaseFinalPractice(),
    )
  );
}

class MyDatabase{

  static const String TABLE_NAME = 'myTable';
  static const String NAME = 'name';
  static const String CITY = 'city';
  static const String USER_ID = 'User_Id';

  int DB_VERSION = 1;

  Future<Database> initDatabase() async{
    Database db = await openDatabase('${getDatabasesPath()}/database.db',
      onCreate: (db, version) {
        db.execute(
          '''
          CREATE TABLE $TABLE_NAME(
          $USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $NAME TEXT NOT NULL,
          $CITY TEXT NOT NULL
          )
          '''
        );
      },
      version: DB_VERSION
    );
    return db;
  }
}

class DatabaseFinalPractice extends StatefulWidget {
  const DatabaseFinalPractice({super.key});

  @override
  State<DatabaseFinalPractice> createState() => _DatabaseFinalPracticeState();
}

class _DatabaseFinalPracticeState extends State<DatabaseFinalPractice> {
  List<Map<String,dynamic>> User = [];
  List<Map<String,dynamic>> filteredUser = [];


  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  void initState(){
    super.initState();
    setState(() {
      getUsers();
      filteredUser = User;
    });
  }

  Future<void> getUsers() async{
    final db  = await MyDatabase().initDatabase();
    User = await db.query(MyDatabase.TABLE_NAME);
    filteredUser = User;
    setState(() {});
  }

  Future<void> addUser(String Name, String City) async{
    final db = await MyDatabase().initDatabase();
    await db.insert(MyDatabase.TABLE_NAME, {
      MyDatabase.NAME : Name,
      MyDatabase.CITY : City
    });
    getUsers();
  }

  Future<void> updateUser(int User_Id,String Name, String City) async{
    final db = await MyDatabase().initDatabase();
    await db.update(MyDatabase.TABLE_NAME, {
      MyDatabase.NAME : Name,
      MyDatabase.CITY : City
    },
    where: 'User_Id = ?',
    whereArgs: [User_Id]
    );
    getUsers();
  }

  Future<void> deleteUser(int User_Id) async{
    final db = await MyDatabase().initDatabase();
    await db.delete(MyDatabase.TABLE_NAME,
    where: 'User_Id = ?',
    whereArgs: [User_Id]
    );
    getUsers();
  }

  void searchUsers(String? search){
    if(search!.isEmpty){
      filteredUser = User;
    }
    else{
      filteredUser = User.where((element) {
       return element[MyDatabase.NAME].toString().toLowerCase().contains(search.toLowerCase());
      },).toList();
    }
    setState(() {});
  }

  void clearControllers(){
    nameController.clear();
    cityController.clear();
  }

  void sortUsersByName() {
    filteredUser.sort((a, b) => a[MyDatabase.NAME].compareTo(b[MyDatabase.NAME]));
    setState(() {});
  }

  void sortUsersByCity() {
    filteredUser.sort((a, b) => a[MyDatabase.CITY].compareTo(b[MyDatabase.CITY]));
    setState(() {});
  }

  Future<dynamic> showBottomSheet(int? User_Id) async {
    return showModalBottomSheet(context: context, builder: (context) {
      return Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Name"
            ),
          ),

          TextFormField(
            controller: cityController,
            decoration: InputDecoration(
              labelText: "City"
            ),
          ),

          ElevatedButton(onPressed: (){
            if(User_Id != null){
              updateUser(User_Id, nameController.text, cityController.text).then((value) {
                Navigator.pop(context);
                setState(() {
                  clearControllers();
                  getUsers();
                });
              },);
            }
            else{
              addUser(nameController.text, cityController.text).then((value) {
                Navigator.pop(context);
                setState(() {
                  clearControllers();
                  getUsers();
                });
              },);
            }
          }, child: Text("Save"))
        ],
      );
    },).whenComplete(() {
      clearControllers();
      setState(() {
        getUsers();
      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD"),
        actions: [
          IconButton(onPressed: (){
            showBottomSheet(null).then((value) {
              setState(() {
                getUsers();
              });
            },);
          }, icon: Icon(Icons.add)),
          IconButton(onPressed: () {
            sortUsersByName();
          }, icon: Icon(Icons.sort_by_alpha)),
          IconButton(onPressed: () {
            sortUsersByCity();
          }, icon: Icon(Icons.location_city)),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search"
              ),
              onChanged: (value) {
                searchUsers(value);
              },
            ),
          ),
          Expanded(child: 
            ListView.builder(
              itemCount: filteredUser.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredUser[index][MyDatabase.NAME]),
                  subtitle: Text(filteredUser[index][MyDatabase.CITY]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        nameController.text = filteredUser[index][MyDatabase.NAME];
                        cityController.text = filteredUser[index][MyDatabase.CITY];
                        showBottomSheet(filteredUser[index][MyDatabase.USER_ID]).then((value) {
                          setState(() {
                            getUsers();
                          });
                        },);
                      }, icon: Icon(Icons.edit)),

                      IconButton(onPressed: (){
                        deleteUser(filteredUser[index][MyDatabase.USER_ID]).then((value) {
                          setState(() {
                            getUsers();
                          });
                        },);
                      }, icon: Icon(Icons.delete))
                    ],
                  ),
                );
              },)
          ),
        ],
      ),
    );
  }
}
*/
