import 'package:flutter/material.dart';
import 'package:matrimony_app/AboutUserScreen.dart';
import 'package:matrimony_app/AddUserScreen.dart';
import 'package:matrimony_app/User.dart';
import 'package:matrimony_app/home_screen.dart';
import 'package:matrimony_app/utils.dart';

class UserList extends StatefulWidget {
  final User users;
  final bool favourite;
  const UserList({super.key, required this.users, required this.favourite});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<Map<String, dynamic>> filteredUsers = [];
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateFilteredUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void updateFilteredUsers() {
    if (searchQuery.isNotEmpty) {
      filterUsers(searchQuery);
      return;
    }

    setState(() {
      if (widget.favourite) {
        filteredUsers =
            widget.users.userlist.where((user) => user[Favorite]).toList();
      } else {
        filteredUsers = widget.users.userlist;
      }
    });
  }

  void filterUsers(String query) {
    searchQuery = query;
    setState(() {
      if (query.isEmpty) {
        updateFilteredUsers();
      } else {
        filteredUsers = widget.users.userlist.where((user) {
          bool matchesQuery = user[Name]
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
          return widget.favourite
              ? user[Favorite] && matchesQuery
              : matchesQuery;
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
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        title: Text(
          widget.favourite ? 'Favourite Users' : 'All Users',
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
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 16.0),
            icon: const Icon(Icons.person_add_sharp, color: Colors.white, size: 35),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddUserScreen(users: widget.users, user: null, fromUserList: true)),
              ).then((value) {
                setState(() {
                  updateFilteredUsers();
                });
              });
            },
          ),
        ],
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
                      child: Expanded(
                        child: Container(
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
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search people & places",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: const Icon(Icons.search,
                                  color: Color(0xFFFF778D)),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: Color(0xFFFF778D)),
                                      onPressed: () {
                                        _searchController.clear();
                                        filterUsers('');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                            onChanged: filterUsers,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: filteredUsers.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widget.favourite
                                      ? Icon(Icons.favorite_border,
                                          size: 80, color: Colors.grey[300])
                                      : Icon(Icons.person_search,
                                          size: 80, color: Colors.grey[300]),
                                  const SizedBox(height: 16),
                                  Text(
                                    widget.favourite
                                        ? "No Favourite Users Found"
                                        : "No Users Found",
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AboutUser(
                                          users: widget.users,
                                          user: user,
                                        ),
                                      ),
                                    ).then((value) {
                                      setState(() {
                                        updateFilteredUsers();
                                      });
                                    });
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
                                                child: const Icon(Icons.person,
                                                    color: Color(0xFFFF778D),
                                                    size: 28),
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
                                                  widget.favourite
                                                      ? IconButton(
                                                          icon: const Icon(
                                                            Icons.favorite,
                                                            color: Color(
                                                                0xFFFF778D),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              user[Favorite] =
                                                                  !user[
                                                                      Favorite];
                                                              filteredUsers
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "${user[Name]} removed from favorites successfully"),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : IconButton(
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
                                                                  !user[
                                                                      Favorite];
                                                            });
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
                                                                  (context) {
                                                                return AboutUser(
                                                                  users: widget
                                                                      .users,
                                                                  user: user,
                                                                );
                                                              },
                                                            ));
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AddUserScreen(
                                                                            users:
                                                                                widget.users,
                                                                            user:
                                                                                user,
                                                                          )),
                                                            ).then((value) {
                                                              setState(() {
                                                                updateFilteredUsers();
                                                              });
                                                            });
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
                                                                      if (widget
                                                                          .favourite) {
                                                                        widget
                                                                            .users
                                                                            .userlist
                                                                            .removeWhere((element) =>
                                                                                element[Name] ==
                                                                                user[Name]);
                                                                      } else {
                                                                        widget
                                                                            .users
                                                                            .deleteUser(index);
                                                                      }
                                                                      Navigator.pop(
                                                                          context);
                                                                      setState(
                                                                          () {
                                                                        updateFilteredUsers();
                                                                      });
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              Text("${user[Name]} deleted successfully"),
                                                                          backgroundColor:
                                                                              Colors.green,
                                                                          duration:
                                                                              const Duration(seconds: 2),
                                                                        ),
                                                                      );
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
    );
  }
}
