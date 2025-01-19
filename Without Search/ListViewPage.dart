import 'package:crud_demo/User.dart';
import 'package:crud_demo/form.dart';
import 'package:crud_demo/utils.dart';
import 'package:flutter/material.dart';


class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {

  User _user = User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List Demo"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return UserForm(
                  nameController: TextEditingController(),
                  emailController: TextEditingController(),
                  phoneController: TextEditingController(),
                );
            },
            )).then((value){
              if(value != null){
                _user.userlist.add(value);
                setState(() {});
                }
            });
          }, icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _user.userlist.isEmpty
          ?
            Expanded(child: Center(child: Text("No User Found")),)
          :
        Expanded(
          child: ListView.builder(
          itemCount: _user.userlist.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(
                    builder: (context) => UserForm(
                      nameController: TextEditingController(text: _user.userlist[index][NAME]),
                      emailController: TextEditingController(text: _user.userlist[index][EMAIL]),
                      phoneController: TextEditingController(text: _user.userlist[index][PHONE]),
                    ),
                  ),
                ).then((value) {
                  if (value != null) {
                    _user.updateUserInList(index, value[NAME], value[PHONE], value[EMAIL]);
                    setState(() {});
                  }
                });
              },
              title: Text(_user.userlist[index][NAME]),
              subtitle: Text("${_user.userlist[index][EMAIL]}\n${_user.userlist[index][PHONE]}"),
              trailing:
                  IconButton(onPressed: (){
                    _user.deleteUserInList(index);
                    setState(() {});
                  }, icon: Icon(Icons.delete)),
            );
          },
        ))
        ],
      ),
    );
  }
}