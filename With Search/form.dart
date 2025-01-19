// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:crud_demo/utils.dart';
import 'package:flutter/material.dart';

class UserForm extends StatelessWidget {
  UserForm({super.key, required this.nameController, required this.emailController, required this.phoneController});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Form"),),
      body: 
      Padding(padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Enter your name"
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email"
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone",
                hintText: "Enter your phone"
              ),),
            ElevatedButton(
              onPressed: (){
                Map<String,dynamic> map = {};
                map[NAME] = nameController.text;
                map[EMAIL] = emailController.text;
                map[PHONE] = phoneController.text;
                Navigator.pop(context,map);
                },
              child: Text("Submit"),
            )
          ],
        ),
        ),
      );
  }
}