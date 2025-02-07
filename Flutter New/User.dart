import 'package:matrimony_app/utils.dart';

class User {
  List<Map<String,dynamic>> userlist = [
    {
      Name: "John Doe",
      Address: "123 Main Street",
      Email: "johndoe@example.com",
      Mobile: "1234567890",
      City: "Rajkot",
      Gender: "Male",
      DOB: DateTime(2001, 1, 1),
      Hobbies : {
      "Reading Or Writing": false,
      "Arts & Craft": true,
      "Sports": false,
      },
      Password: "Meet@2023",
      Favorite: false,
    },
{
  Name: "Jane Smith",
  Address: "456 Oak Avenue",
  Email: "janesmith@example.com",
  Mobile: "9876543210",
  City: "Ahmedabad",
  Gender: "Female",
  DOB: DateTime(2003, 1, 1),
  Hobbies: {
    "Reading Or Writing": true,
    "Arts & Craft": false,
    "Sports": true
  },
  Password: "Meet@2023",
  Favorite: true
},
{
  Name: "David Lee",
  Address: "789 Pine Street",
  Email: "davidlee@example.com",
  Mobile: "5551234567",
  City: "Surat",
  Gender: "Male",
  DOB: DateTime(2000, 1, 1),
  Hobbies: {
    "Reading Or Writing": false,
    "Arts & Craft": true,
    "Sports": true
  },
  Password: "Meet@2023",
  Favorite: true
},
{
  Name: "Emily Brown",
  Address: "101 Maple Drive",
  Email: "emilybrown@example.com",
  Mobile: "1112223333",
  City: "Vadodara",
  Gender: "Female",
  DOB: DateTime(2004, 1, 1),
  Hobbies: {
    "Reading Or Writing": true,
    "Arts & Craft": false,
    "Sports": false
  },
  Password: "Meet@2023",
  Favorite: true
}
  ];

  void addUserToList(String name, String address, String email,String mobile,String city,String gender,DateTime dob,Map<String, bool> hobbies, String password, bool favorite){
    Map<String,dynamic> user = {};
    user[Name] =name;
    user[Address] = address;
    user[Email] = email;
    user[Mobile] = mobile;
    user[City] = city;
    user[Gender] = gender;
    user[DOB] = dob;
    user[Hobbies] = hobbies;
    user[Password] = password;
    user[Favorite] = favorite;
    userlist.insert(0, user);
  }

  List<Map<String,dynamic>> getUserList(){
    return userlist;
  }

  void deleteUser(int index){
    userlist.removeAt(index);
  }

  void updateUserInList(int index,String name, String address, String email,String mobile,String city,String gender,DateTime dob,Map<String, bool> hobbies, String password, bool favorite){
    Map<String,dynamic> user = {};
    user[Name] =name;
    user[Address] = address;
    user[Email] = email;
    user[Mobile] = mobile;
    user[City] = city;
    user[Gender] = gender;
    user[DOB] = dob;
    user[Hobbies] = hobbies;
    user[Password] = password;
    user[Favorite] = favorite;
    userlist[index] = user;
  }
  
}