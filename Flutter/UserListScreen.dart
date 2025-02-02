import 'package:flutter/material.dart';
import 'package:matrimony_app/AboutUserScreen.dart';
import 'package:matrimony_app/AddUserScreen.dart';
import 'package:matrimony_app/User.dart';
import 'package:matrimony_app/home_screen.dart';
import 'package:matrimony_app/utils.dart';

class UserList extends StatefulWidget {
  final User users;
  const UserList({super.key, required this.users});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.users.userlist;
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = widget.users.userlist;
      } else {
        filteredUsers = widget.users.userlist.where((user) {
          return user[Name]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user[City]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user[Email]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user[Mobile]
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (DateTime.now().year - user[DOB].year).toString().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => HomeScreen(users: widget.users)
                          ));
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        title: const Text(
          'All Users',
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color(0xFFF5F5F5),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search people & places",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: const Icon(Icons.search,
                              color: Color(0xFFFF778D)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        onChanged: filterUsers,
                      ),
                    ),
                    Expanded(
                      child: filteredUsers.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_search,
                                      size: 80, color: Colors.grey[300]),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No Users Found",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = filteredUsers[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AboutUser(
                                          users: widget.users,
                                          user: user,
                                          index: index,
                                          fromFavorite: false,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFF778D)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Icon(
                                                  Icons.person,
                                                  color: Color(0xFFFF778D),
                                                  size: 28,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${user[Name]}",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF2D3142),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "${DateTime.now().year - user[DOB].year} years",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[600],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  StatefulBuilder(
                                                    builder:
                                                        (context, setState) {
                                                      return IconButton(
                                                        icon: Icon(
                                                          user[Favorite]
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          color: const Color(
                                                              0xFFFF778D),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            user[Favorite] =
                                                                !user[Favorite];
                                                          });
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  PopupMenuButton(
                                                    icon: const Icon(
                                                        Icons.more_vert,
                                                        color:
                                                            Color(0xFF2D3142)),
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        child: ListTile(
                                                          leading: const Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.blue),
                                                          title: const Text(
                                                              'Edit'),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AddUserScreen(users: widget.users,
                                                                  user: user,
                                                                  fromFavorite:
                                                                      false,
                                                                  fromAboutUser:
                                                                      false,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        child: ListTile(
                                                          leading: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.red),
                                                          title: const Text(
                                                              'Delete'),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                title: const Text(
                                                                    "Delete User"),
                                                                content: Text(
                                                                    "Are you sure you want to delete ${user[Name]}?"),
                                                                actions: [
                                                                  TextButton(
                                                                    child: const Text(
                                                                        "Cancel"),
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                  ),
                                                                  TextButton(
                                                                    child: const Text(
                                                                        "Delete"),
                                                                    onPressed:
                                                                        () {
                                                                      widget
                                                                          .users
                                                                          .userlist
                                                                          .removeAt(
                                                                              index);
                                                                      Navigator.pop(
                                                                          context);
                                                                      setState(
                                                                          () {});
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(
                                                                        content: Text("${user[Name]} deleted successfully"),
                                                                        backgroundColor: Colors.green,
                                                                      ),);
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Divider(height: 24),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.location_on,
                                                        color:
                                                            Colors.orange[400],
                                                        size: 20),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        user[City],
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xFF2D3142),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.phone,
                                                        color: Colors.green,
                                                        size: 20),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        "+91 ${user[Mobile]}",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xFF2D3142),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(Icons.email,
                                                  color: Color(0xFFFF778D),
                                                  size: 20),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  user[Email],
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF2D3142),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(users: widget.users),
            ),
          );
        },
        backgroundColor: const Color(0xFFFF778D),
        label: const Row(
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Add User',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
