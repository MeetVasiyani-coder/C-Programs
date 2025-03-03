import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrimony_app/AboutUserScreen.dart';
import 'package:matrimony_app/AddUserScreen.dart';
import 'package:matrimony_app/User.dart';
import 'package:matrimony_app/home_screen.dart';
import 'package:matrimony_app/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimony_app/login_screen.dart';

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
  bool _isLoading = true;
  String sortBy = '';
  String sortOrder = '';
  RangeValues ageRange = RangeValues(18, 35);
  List<String> selectedCities = [];
  String selectedGender = '';
  bool isSelectionMode = false;
  Set<Map<String, dynamic>> selectedUsers = {};
  int? loggedInUserId;

  @override
  void initState() {
    super.initState();
    _getLoggedInUserId();
    loadUsers();
  }

  Future<void> _getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserId = prefs.getInt('userId');
    });
  }

  Future<void> loadUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.users.getUserList();
      if (sortBy.isNotEmpty ||
          selectedCities.isNotEmpty ||
          selectedGender.isNotEmpty) {
        applyFilters();
      } else {
        updateFilteredUsers();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading users: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        filteredUsers = List.from(widget.users.userlist);
      }
    });
  }

  void filterUsers(String query) {
    searchQuery = query;
    setState(() {
      if (query.isEmpty) {
        if (sortBy.isNotEmpty ||
            selectedCities.isNotEmpty ||
            selectedGender.isNotEmpty) {
          applyFilters();
        } else {
          updateFilteredUsers();
        }
      } else {
        // Get initial list based on favorite status
        List<Map<String, dynamic>> tempList = widget.favourite
            ? widget.users.userlist.where((user) => user[Favorite]).toList()
            : List.from(widget.users.userlist);

        // Apply existing filters first
        if (selectedGender.isNotEmpty) {
          tempList =
              tempList.where((user) => user[Gender] == selectedGender).toList();
        }

        if (selectedCities.isNotEmpty) {
          tempList = tempList
              .where((user) => selectedCities.contains(user[City]))
              .toList();
        }

        // Apply age range filter
        tempList = tempList.where((user) {
          int age = (DateTime.now().year - user[DOB].year).toInt();
          return age >= ageRange.start && age <= ageRange.end;
        }).toList();

        // Then apply search
        filteredUsers = tempList.where((user) {
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

        // Apply sorting if active
        if (sortBy == 'age') {
          filteredUsers.sort((a, b) {
            int ageA = (DateTime.now().year - a[DOB].year).toInt();
            int ageB = (DateTime.now().year - b[DOB].year).toInt();
            return sortOrder == 'asc'
                ? ageA.compareTo(ageB)
                : ageB.compareTo(ageA);
          });
        } else if (sortBy == 'name') {
          filteredUsers.sort((a, b) {
            return sortOrder == 'asc'
                ? a[Name].toString().compareTo(b[Name].toString())
                : b[Name].toString().compareTo(a[Name].toString());
          });
        }
      }
    });
  }

  void applyFilters() {
    setState(() {
      List<Map<String, dynamic>> tempList = widget.favourite
          ? widget.users.userlist.where((user) => user[Favorite]).toList()
          : List.from(widget.users.userlist);

      // Apply age range filter
      tempList = tempList.where((user) {
        int age = (DateTime.now().year - user[DOB].year).toInt();
        return age >= ageRange.start && age <= ageRange.end;
      }).toList();

      // Apply city filter
      if (selectedCities.isNotEmpty) {
        tempList = tempList
            .where((user) => selectedCities.contains(user[City]))
            .toList();
      }

      // Apply gender filter
      if (selectedGender.isNotEmpty) {
        tempList =
            tempList.where((user) => user[Gender] == selectedGender).toList();
      }

      // Apply sorting
      if (sortBy == 'age') {
        tempList.sort((a, b) {
          int ageA = (DateTime.now().year - a[DOB].year).toInt();
          int ageB = (DateTime.now().year - b[DOB].year).toInt();
          return sortOrder == 'asc'
              ? ageA.compareTo(ageB)
              : ageB.compareTo(ageA);
        });
      } else if (sortBy == 'name') {
        tempList.sort((a, b) {
          return sortOrder == 'asc'
              ? a[Name].toString().compareTo(b[Name].toString())
              : b[Name].toString().compareTo(a[Name].toString());
        });
      }

      filteredUsers = tempList;
    });
  }

  void resetFilters() {
    setState(() {
      sortBy = '';
      sortOrder = '';
      ageRange = RangeValues(18, 35);
      selectedCities = [];
      selectedGender = '';
      updateFilteredUsers();
    });
    Navigator.pop(context);
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  TextButton(
                    onPressed: resetFilters,
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Color(0xFFFF778D),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              // Sort Options
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  FilterChip(
                    label: Row(
                      children: [
                        Text(
                          sortBy == 'age' && sortOrder == 'asc'
                              ? 'Young to Old'
                              : sortBy == 'age' && sortOrder == 'desc'
                                  ? 'Old to Young'
                                  : 'Age',
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          sortBy == 'age' && sortOrder == 'asc'
                              ? Icons.arrow_upward
                              : sortBy == 'age' && sortOrder == 'desc'
                                  ? Icons.arrow_downward
                                  : Icons.unfold_more,
                          size: 18,
                        ),
                      ],
                    ),
                    selected: sortBy == 'age',
                    onSelected: (selected) {
                      setModalState(() {
                        if (sortBy != 'age') {
                          // First tap
                          sortBy = 'age';
                          sortOrder = 'asc'; // Young to Old
                        } else if (sortOrder == 'asc') {
                          // Second tap
                          sortOrder = 'desc'; // Old to Young
                        } else {
                          // Third tap
                          sortBy = '';
                          sortOrder = '';
                        }
                        applyFilters();
                      });
                    },
                    selectedColor: const Color(0xFFFF778D).withOpacity(0.2),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Row(
                      children: [
                        Text(
                          sortBy == 'name' && sortOrder == 'asc'
                              ? 'A to Z'
                              : sortBy == 'name' && sortOrder == 'desc'
                                  ? 'Z to A'
                                  : 'Name',
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          sortBy == 'name' && sortOrder == 'asc'
                              ? Icons.arrow_upward
                              : sortBy == 'name' && sortOrder == 'desc'
                                  ? Icons.arrow_downward
                                  : Icons.unfold_more,
                          size: 18,
                        ),
                      ],
                    ),
                    selected: sortBy == 'name',
                    onSelected: (selected) {
                      setModalState(() {
                        if (sortBy != 'name') {
                          // First tap
                          sortBy = 'name';
                          sortOrder = 'asc'; // A to Z
                        } else if (sortOrder == 'asc') {
                          // Second tap
                          sortOrder = 'desc'; // Z to A
                        } else {
                          // Third tap
                          sortBy = '';
                          sortOrder = '';
                        }
                        applyFilters();
                      });
                    },
                    selectedColor: const Color(0xFFFF778D).withOpacity(0.2),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Age Range
              const Text(
                'Age Range',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              RangeSlider(
                values: ageRange,
                min: 18,
                max: 35,
                divisions: 17,
                labels: RangeLabels(
                  ageRange.start.round().toString(),
                  ageRange.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setModalState(() {
                    ageRange = values;
                    applyFilters();
                  });
                },
                activeColor: const Color(0xFFFF778D),
              ),
              const SizedBox(height: 16),

              // Gender Filter
              const Text(
                'Gender',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Male', 'Female'].map((gender) {
                  return FilterChip(
                    label: Text(gender),
                    selected: selectedGender == gender,
                    onSelected: (selected) {
                      setModalState(() {
                        selectedGender = selected ? gender : '';
                        applyFilters();
                      });
                    },
                    selectedColor: const Color(0xFFFF778D).withOpacity(0.2),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // City Filter
              const Text(
                'City',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: widget.users.userlist
                    .map((user) => user[City].toString())
                    .toSet()
                    .map((city) {
                  return FilterChip(
                    label: Text(city),
                    selected: selectedCities.contains(city),
                    onSelected: (selected) {
                      setModalState(() {
                        if (selected) {
                          selectedCities.add(city);
                        } else {
                          selectedCities.remove(city);
                        }
                        applyFilters();
                      });
                    },
                    selectedColor: const Color(0xFFFF778D).withOpacity(0.2),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateAndDownloadPDF() async {
    setState(() => _isLoading = true);
    try {
      final pdf = pw.Document();

      for (var userData in selectedUsers) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      'User Details',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // Basic Information
                  pw.Text('Basic Information',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  _buildPDFRow('Name', userData[Name]),
                  _buildPDFRow('Gender', userData[Gender]),
                  _buildPDFRow('Date of Birth',
                      DateFormat('dd/MM/yyyy').format(userData[DOB])),
                  pw.SizedBox(height: 15),

                  // Address Details
                  pw.Text('Address Details',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  _buildPDFRow('Address', userData[Address]),
                  _buildPDFRow('City', userData[City]),
                  _buildPDFRow('State', 'Gujarat'),
                  _buildPDFRow('Country', 'India'),
                  pw.SizedBox(height: 15),

                  // Contact Details
                  pw.Text('Contact Details',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  _buildPDFRow('Email', userData[Email]),
                  _buildPDFRow('Phone', userData[Mobile]),
                  pw.SizedBox(height: 15),

                  // Hobbies
                  pw.Text('Hobbies',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  _buildPDFRow(
                      'Hobbies',
                      userData[Hobbies]
                              ?.entries
                              .where((entry) => entry.value == true)
                              .map((entry) => entry.key)
                              .join(', ') ??
                          ''),
                ],
              );
            },
          ),
        );

        // Add a page break if not the last user
        if (userData != selectedUsers.last) {
          pdf.addPage(pw.Page(build: (context) => pw.Container()));
        }
      }

      final dir = await getApplicationDocumentsDirectory();
      final String fileName = 'users_details.pdf';
      final file = File('${dir.path}/$fileName');

      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF generated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateAndDownloadExcel() async {
    setState(() => _isLoading = true);
    try {
      var excel = Excel.createExcel();
      var sheet = excel['Users'];

      // Add headers
      var headers = [
        'Name',
        'Gender',
        'Date of Birth',
        'Address',
        'City',
        'Email',
        'Phone',
        'Hobbies'
      ];
      sheet.appendRow(headers);

      // Add data
      for (var user in selectedUsers) {
        var row = [
          user[Name],
          user[Gender],
          DateFormat('dd/MM/yyyy').format(user[DOB]),
          user[Address],
          user[City],
          user[Email],
          user[Mobile],
          user[Hobbies]
                  ?.entries
                  .where((entry) => entry.value == true)
                  .map((entry) => entry.key)
                  .join(', ') ??
              ''
        ];
        sheet.appendRow(row);
      }

      final dir = await getApplicationDocumentsDirectory();
      final String fileName = 'users_data.xlsx';
      final file = File('${dir.path}/$fileName');

      await file.writeAsBytes(excel.encode()!);
      await OpenFile.open(file.path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Excel file generated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating Excel: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  pw.Widget _buildPDFRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Text(': '),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF778D),
        leading: isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  setState(() {
                    isSelectionMode = false;
                    selectedUsers.clear();
                  });
                },
              )
            : GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
              ),
        title: Text(
          isSelectionMode
              ? '${selectedUsers.length} Selected'
              : widget.favourite
                  ? 'Favourite Users'
                  : 'All Users',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          if (isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              onPressed: selectedUsers.isEmpty ? null : _generateAndDownloadPDF,
            ),
            IconButton(
              icon: const Icon(Icons.file_present, color: Colors.white),
              onPressed:
                  selectedUsers.isEmpty ? null : _generateAndDownloadExcel,
            ),
          ] else
            IconButton(
              padding: const EdgeInsets.only(right: 16.0),
              icon: const Icon(Icons.person_add_sharp,
                  color: Colors.white, size: 35),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddUserScreen(
                          users: widget.users, user: null, fromUserlist: true)),
                ).then((value) {
                  setState(() {
                    loadUsers();
                  });
                });
              },
            ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF778D),
                ),
              )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
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
                        const SizedBox(width: 8),
                        Container(
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
                          child: Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.filter_list,
                                    color: Color(0xFFFF778D)),
                                onPressed: showFilterBottomSheet,
                              ),
                              if (sortBy.isNotEmpty ||
                                  selectedCities.isNotEmpty ||
                                  selectedGender.isNotEmpty ||
                                  ageRange != const RangeValues(18, 35))
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF778D),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              return GestureDetector(
                                onTap: () {
                                  if (isSelectionMode) {
                                    setState(() {
                                      if (selectedUsers.contains(user)) {
                                        selectedUsers.remove(user);
                                        if (selectedUsers.isEmpty) {
                                          isSelectionMode = false;
                                        }
                                      } else {
                                        selectedUsers.add(user);
                                      }
                                    });
                                  } else {
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
                                        loadUsers();
                                      });
                                    });
                                  }
                                },
                                onLongPress: () {
                                  if (!isSelectionMode) {
                                    setState(() {
                                      isSelectionMode = true;
                                      selectedUsers.add(user);
                                    });
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: selectedUsers.contains(user)
                                        ? const Color(0xFFFF778D)
                                            .withOpacity(0.1)
                                        : Colors.white,
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
                                              padding: const EdgeInsets.all(8),
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
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${user[Name]}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF2D3142),
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
                                                          color:
                                                              Color(0xFFFF778D),
                                                        ),
                                                        onPressed: () async {
                                                          try {
                                                            await widget.users
                                                                .updateUserInList(
                                                              user[USER_ID],
                                                              user[Name],
                                                              user[Address],
                                                              user[Email],
                                                              user[Mobile],
                                                              user[City],
                                                              user[Gender],
                                                              user[DOB],
                                                              Map<String,
                                                                      bool>.from(
                                                                  user[
                                                                      Hobbies]),
                                                              user[Password],
                                                              !user[Favorite],
                                                            );
                                                            await loadUsers();

                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "${user[Name]} removed from favourites"),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                            );
                                                          } catch (e) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'Error updating favorite: ${e.toString()}'),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          }
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
                                                        onPressed: () async {
                                                          try {
                                                            await widget.users
                                                                .updateUserInList(
                                                              user[USER_ID],
                                                              user[Name],
                                                              user[Address],
                                                              user[Email],
                                                              user[Mobile],
                                                              user[City],
                                                              user[Gender],
                                                              user[DOB],
                                                              Map<String,
                                                                      bool>.from(
                                                                  user[
                                                                      Hobbies]),
                                                              user[Password],
                                                              !user[Favorite],
                                                            );
                                                            await loadUsers();
                                                          } catch (e) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'Error updating favorite: ${e.toString()}'),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                PopupMenuButton(
                                                  icon: const Icon(
                                                      Icons.more_vert,
                                                      color: Color(0xFF2D3142)),
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                      child: ListTile(
                                                        leading: const Icon(
                                                            Icons.edit,
                                                            color: Color(
                                                                0xFFFF778D)),
                                                        title:
                                                            const Text('Edit'),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                            builder: (context) {
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
                                                              loadUsers();
                                                            });
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      child: ListTile(
                                                        leading: const Icon(
                                                            Icons.delete,
                                                            color: Color(
                                                                0xFFFF778D)),
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
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {
                                                                      _isLoading =
                                                                          true;
                                                                    });
                                                                    try {
                                                                      await widget
                                                                          .users
                                                                          .deleteUser(
                                                                              user[USER_ID]);

                                                                      // Check if deleted user is the logged-in user
                                                                      if (user[
                                                                              USER_ID] ==
                                                                          loggedInUserId) {
                                                                        // Clear login state
                                                                        final prefs =
                                                                            await SharedPreferences.getInstance();
                                                                        await prefs
                                                                            .clear();

                                                                        // Navigate to login screen
                                                                        if (!mounted)
                                                                          return;
                                                                        Navigator.of(context)
                                                                            .pushAndRemoveUntil(
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                LoginScreen(users: widget.users),
                                                                          ),
                                                                          (route) =>
                                                                              false,
                                                                        );
                                                                        return;
                                                                      }

                                                                      await loadUsers();
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
                                                                    } catch (e) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              Text('Error deleting user: ${e.toString()}'),
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                        ),
                                                                      );
                                                                    } finally {
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            false;
                                                                      });
                                                                    }
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
                                                      color: Colors.orange[400],
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
    );
  }
}
