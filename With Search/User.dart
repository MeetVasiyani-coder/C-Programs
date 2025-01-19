import 'package:crud_demo/utils.dart';

class User{
  List<Map<String,dynamic>> userlist = [];
  List<Map<String,dynamic>> temp = [];
  
  void add(String name,String phone,String email){
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

  void resetUserList() {
    userlist = temp;
  }

  void searchUser(searchData) {
    List<Map<String,dynamic>> searched = [];
    temp = userlist;
    for (var element in userlist) {
      if (element[NAME]
              .toString()
              .toLowerCase()
              .contains(searchData.toString().toLowerCase())) {
        searched.add(element);
      }
    }

    userlist = searched;
  }

}