
import 'package:crud_demo/utils.dart';

class User{
  List<Map<String,dynamic>> userlist = [];
  
  void addUserInList(String name,String phone,String email){
    Map<String,dynamic> map = {};
    map[NAME] = name;
    map[PHONE] = phone;
    map[EMAIL] = email;
    userlist.add(map);
  }

  List<Map<String,dynamic>> getUserInList(){
    return userlist;
  }

  void deleteUserInList(id){
    userlist.removeAt(id);
  }

  void updateUserInList(int id, String name, String phone, String email) {
    Map<String, dynamic> map = {};
    map[NAME] = name;
    map[PHONE] = phone;
    map[EMAIL] = email;
    userlist[id] = map;
  }

}