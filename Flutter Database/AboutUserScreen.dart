import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrimony_app/AddUserScreen.dart';
import 'package:matrimony_app/User.dart';
import 'package:matrimony_app/UserListScreen.dart';
import 'package:matrimony_app/utils.dart';

class AboutUser extends StatefulWidget {
  final User users;
  final Map<String, dynamic> user;
  const AboutUser({super.key, required this.users, required this.user});
  @override
  State<AboutUser> createState() => _AboutUserState();
}

class _AboutUserState extends State<AboutUser> {
  bool _isLoading = false;
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _userData = Map<String, dynamic>.from(widget.user);
  }

  Future<void> _refreshUserData() async {
    setState(() => _isLoading = true);
    try {
      await widget.users.getUserList();
      final updatedUser = widget.users.userlist.firstWhere(
        (user) => user[USER_ID] == _userData[USER_ID],
        orElse: () => _userData,
      );
      setState(() {
        _userData = updatedUser;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error refreshing user data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isLoading = true);
    try {
      await widget.users.updateUserInList(
        _userData[USER_ID],
        _userData[Name],
        _userData[Address],
        _userData[Email],
        _userData[Mobile],
        _userData[City],
        _userData[Gender],
        _userData[DOB],
        Map<String, bool>.from(_userData[Hobbies]),
        _userData[Password],
        !_userData[Favorite],
      );
      await _refreshUserData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_userData[Favorite] ? 
            "Added to favorites" : 
            "Removed from favorites"
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating favorite: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser() async {
    setState(() => _isLoading = true);
    try {
      await widget.users.deleteUser(_userData[USER_ID]);
      Navigator.of(context).pop(); // Close dialog
      Navigator.of(context).pop(); // Close AboutUser screen
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${_userData[Name]} deleted successfully"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting user: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: const Color(0xFFFFFFFF)),
              ),
            ),
            title: const Text(
              'User Details',
              style: TextStyle(
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF778D), Colors.white],
                stops: [0.0, 0.3],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey[50],
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Color(0xFFFF778D).withOpacity(0.9),
                                          Color(0xFFFF778D).withOpacity(0.5),
                                          Color(0xFFFF778D).withOpacity(0.0),
                                        ],
                                        stops: const [0.0, 0.5, 1.0],
                                      ),
                                    ),
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/images/person.png'),
                                        backgroundColor: Colors.white,
                                        radius: 60.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "${_userData[Name]}",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Card(
                                        elevation: 2,
                                        color: const Color(0xFFFF778D),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AddUserScreen(
                                                  users: widget.users,
                                                  user: _userData,
                                                ),
                                              ),
                                            ).then((value) async {
                                              await _refreshUserData();
                                            });
                                          },
                                          icon: const Icon(Icons.edit,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Card(
                                        elevation: 2,
                                        color: const Color(0xFFFF778D),
                                        child: IconButton(
                                          onPressed: _isLoading ? null : () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text("Delete User"),
                                                content: Text(
                                                  "Are you sure you want to delete ${_userData[Name]}?"
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("Cancel"),
                                                    onPressed: () => Navigator.pop(context),
                                                  ),
                                                  TextButton(
                                                    child: const Text("Delete"),
                                                    onPressed: _deleteUser,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.delete,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Card(
                                        elevation: 2,
                                        color: const Color(0xFFFF778D),
                                        child: IconButton(
                                          icon: Icon(
                                            _userData[Favorite] 
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: Colors.white,
                                          ),
                                          onPressed: _isLoading ? null : _toggleFavorite,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(children: [
                                // About Section
                                Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "About",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFF778D),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Name
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "Name",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "${_userData[Name]}",
                                                  style:
                                                      const TextStyle(fontSize: 16),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Gender
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "Gender",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "${_userData[Gender]}",
                                                  style:
                                                      const TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Date of Birth
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "Date of Birth",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "${DateFormat('dd/MM/yyyy').format(_userData[DOB])}",
                                                  style:
                                                      const TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Address Details Section
                                Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Address Details",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFF778D),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Address
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "Address",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "${_userData[Address]}",
                                                  style:
                                                      const TextStyle(fontSize: 16),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // City
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "City",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "${_userData[City]}",
                                                  style:
                                                      const TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // State
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "State",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "Gujarat",
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Country
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "Country",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "India",
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Personal Details Section
                                Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Personal Details",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFF778D),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Hobbies
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "Hobbies",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "${_userData[Hobbies]?.entries.where((entry) => entry.value == true).map((entry) => entry.key).join(', ')}",
                                                  style:
                                                      const TextStyle(fontSize: 16),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Contact Details Section
                                Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Contact Details",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFF778D),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Email
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "Email ID",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "${_userData[Email]}",
                                                  style:
                                                      const TextStyle(fontSize: 16),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Phone
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "Phone Number",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "${_userData[Mobile]}",
                                                  style:
                                                      const TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF778D),
              ),
            ),
          ),
      ],
    );
  }
}
