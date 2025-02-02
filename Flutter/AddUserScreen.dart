import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimony_app/AboutUserScreen.dart';
import 'package:matrimony_app/FavouriteUserScreen.dart';
import 'package:matrimony_app/User.dart';
import 'package:matrimony_app/UserListScreen.dart';
import 'package:matrimony_app/utils.dart';
import 'package:intl/intl.dart';

class AddUserScreen extends StatefulWidget {
  final User users;
  final Map<String, dynamic>? user;
  final bool ? fromFavorite;
  final bool ? fromAboutUser;
  final int ? index;

  const AddUserScreen({super.key,required this.users, this.user, this.fromFavorite,this.index,this.fromAboutUser});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  DateTime? birthDate;
  String? selectedCity;
  String selectedGender = "Male";
  bool isobscurepassword = true;
  bool isobscureconfirmpassword = true;
  bool isfavorite = false;
  
  Map<String, bool> hobbies = {
    "Reading Or Writing": false,
    "Arts & Craft": false,
    "Sports": false,
  };

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    mobileController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  void clearFields() {
    nameController.clear();
    addressController.clear();
    emailController.clear();
    mobileController.clear();
    dobController.clear();
    passwordController.clear();
    confirmpasswordController.clear();
    setState(() {
      selectedCity = null;
      selectedGender = "";
      birthDate = null;
      hobbies = {
        "Reading Or Writing": false,
        "Arts & Craft": false,
        "Sports": false,
      };
    });
  }

  @override
  void initState(){
    super.initState();
    if(widget.user != null){
      nameController.text = widget.user![Name];
      addressController.text = widget.user![Address];
      emailController.text = widget.user![Email];
      mobileController.text = widget.user![Mobile];
      selectedCity = widget.user![City];
      selectedGender = widget.user![Gender];
      birthDate = widget.user![DOB];
      dobController.text = DateFormat('dd/MM/yyyy').format(birthDate!);
      hobbies = widget.user![Hobbies];
      passwordController.text = widget.user![Password];
      isfavorite = widget.user![Favorite];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        title: Text(
          widget.user == null ? "Registration" : "Edit User",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFFFF778D),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                // Form Container
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Name Field
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter FullName";
                          }
                          else if(!RegExp(r'^[a-zA-Z\s]{3,50}$').hasMatch(value)){
                            return "Enter a valid FullName (3-50 characters, alphabets only)";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          prefixIcon: Icon(Icons.person, color: Color(0xFFFF778D)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFF778D), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Address Field
                      TextFormField(
                        controller: addressController,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter Address";
                          }
                          return null;
                        },
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: "Address",
                          prefixIcon: Icon(Icons.home, color: Color(0xFFFF778D)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFF778D), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Email Field
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter Email Address";
                          }
                          else if(!RegExp(r'^[a-zA-Z0-9._%+]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)){
                            return "Enter a valid Email Address";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email, color: Color(0xFFFF778D)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFF778D), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Mobile Field
                      TextFormField(
                        controller: mobileController,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please enter Mobile Number";
                          }
                          else if(!RegExp(r'^\+?[0-9]{10}$').hasMatch(value)){
                            return "Enter a valid Mobile Number";
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                        decoration: InputDecoration(
                          labelText: "Mobile",
                          prefixIcon: Icon(Icons.phone, color: Color(0xFFFF778D)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFF778D), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),

                      SizedBox(height: 20),

                      // City Dropdown
                      DropdownButtonFormField(
                        validator: (value){
                          if(value == null){
                            return "Please select a City";
                          }
                          return null;
                        },
                        value: selectedCity,
                        hint: Text("Select City"),
                        items: [
                          DropdownMenuItem(child: Text("Rajkot"), value: "Rajkot"),
                          DropdownMenuItem(child: Text("Ahmedabad"), value: "Ahmedabad"),
                          DropdownMenuItem(child: Text("Surat"), value: "Surat"),
                          DropdownMenuItem(child: Text("Vadodara"), value: "Vadodara"),
                        ],
                        onChanged: (value){
                          setState(() {
                            selectedCity = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "City",
                          prefixIcon: Icon(Icons.location_city, color: Color(0xFFFF778D)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFF778D), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Gender Selection
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gender",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                              Expanded(
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                  selectedGender = "Male";
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                  color: selectedGender == "Male" ? Color.fromARGB(255, 248, 155, 170) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Color(0xFFFF778D)),
                                  ),
                                  child: Center(
                                  child: Text(
                                    "Male",
                                    style: TextStyle(
                                    color: selectedGender == "Male" ? Colors.white : Color(0xFFFF778D),
                                    fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ),
                                ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedGender = "Female";
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                  color: selectedGender == "Female" ? Color(0xFFFF778D) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Color(0xFFFF778D)),
                                  ),
                                  child: Center(
                                  child: Text(
                                    "Female",
                                    style: TextStyle(
                                    color: selectedGender == "Female" ? Colors.white : Color(0xFFFF778D),
                                    fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ),
                                ),
                                ),
                              ),
                              ],
                            ),
                            ],
                          ),
                          ),

                      SizedBox(height: 20),

                      // Date of Birth
                      TextFormField(
                        controller: dobController,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter Date of Birth";
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            initialDatePickerMode: DatePickerMode.year,
                            helpText: 'Select DOB',
                            cancelText: 'Cancel',
                            confirmText: 'Save',
                            errorFormatText: 'Enter valid date',
                            errorInvalidText: 'Enter date in valid range',
                            firstDate: DateTime(DateTime.now().year - 35),
                            lastDate: DateTime(DateTime.now().year - 18),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              birthDate = pickedDate;
                              dobController.text = DateFormat('dd/MM/yyyy').format(birthDate!);
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Date of Birth",
                          prefixIcon: Icon(Icons.calendar_today, color: Color(0xFFFF778D)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFF778D), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Hobbies Section
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hobbies",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                            CheckboxListTile(
                              title: Text("Reading Or Writing"),
                              value: hobbies["Reading Or Writing"],
                              activeColor: Color(0xFFFF778D),
                              onChanged: (bool? value) {
                                setState(() {
                                  hobbies["Reading Or Writing"] = value!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text("Arts & Craft"),
                              value: hobbies["Arts & Craft"],
                              activeColor: Color(0xFFFF778D),
                              onChanged: (bool? value) {
                                setState(() {
                                  hobbies["Arts & Craft"] = value!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text("Sports"),
                              value: hobbies["Sports"],
                              activeColor: Color(0xFFFF778D),
                              onChanged: (bool? value) {
                                setState(() {
                                  hobbies["Sports"] = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // Password Field
                      TextFormField(
                        controller: passwordController,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please enter Password";
                          }
                          else if(!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{5,}$').hasMatch(value)){
                            return "Enter a valid Password (5 characters, alphabets, numbers, special characters)";
                          }
                          return null;
                        },
                        obscureText: isobscurepassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock, color: Color(0xFFFF778D)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isobscurepassword ? Icons.visibility_off : Icons.visibility,
                              color: Color(0xFFFF778D),
                            ),
                            onPressed: () {
                              setState(() {
                                isobscurepassword = !isobscurepassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFF778D), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Confirm Password Field
                      TextFormField(
                        controller: confirmpasswordController,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Confirm Password";
                          }
                          else if(value != passwordController.text){
                            return "Password does not match";
                          }
                          return null;
                        },
                        obscureText: isobscureconfirmpassword,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFFF778D)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isobscureconfirmpassword ? Icons.visibility_off : Icons.visibility,
                              color: Color(0xFFFF778D),
                            ),
                            onPressed: () {
                              setState(() {
                                isobscureconfirmpassword = !isobscureconfirmpassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFF778D), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),

                      SizedBox(height: 30),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  if(widget.user == null){
                                    widget.users.addUserToList(
                                      nameController.text,
                                      addressController.text,
                                      emailController.text,
                                      mobileController.text,
                                      selectedCity!,
                                      selectedGender,
                                      birthDate!,
                                      hobbies,
                                      passwordController.text,
                                      isfavorite,
                                    );
                                  } else {
                                    widget.users.UpdateUserInList(
                                      widget.users.userlist.indexWhere((user) => user == widget.user),
                                      nameController.text,
                                      addressController.text,
                                      emailController.text,
                                      mobileController.text,
                                      selectedCity!,
                                      selectedGender,
                                      birthDate!,
                                      hobbies,
                                      passwordController.text,
                                      isfavorite,
                                    );
                                  }
                                  
                                  if (widget.fromAboutUser == true) {
                                    int userIndex = widget.fromFavorite == true
                                      ? widget.users.userlist.indexWhere((element) => element[Name] == nameController.text)
                                      : widget.index!;
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                      return AboutUser(users: widget.users, user: widget.users.userlist[userIndex], index: userIndex, fromFavorite: widget.fromFavorite!);
                                    }));
                                  }
                                  else if(widget.fromFavorite == true){
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (context) => FavouriteUser(users: widget.users)
                                    ));
                                  }
                                  else{
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (context) => UserList(users: widget.users)
                                    ));
                                  }
                                  clearFields();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF778D),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                            if (widget.user == null) 
                            Expanded(
                              child: ElevatedButton(
                              onPressed: clearFields,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Color(0xFFFF778D)),
                                ),
                              ),
                              child: Text(
                                "Reset",
                                style: TextStyle(
                                color: Color(0xFFFF778D),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                ),
                              ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}