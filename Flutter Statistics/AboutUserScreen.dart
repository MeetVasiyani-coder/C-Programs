import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrimony_app/AddUserScreen.dart';
import 'package:matrimony_app/User.dart';
import 'package:matrimony_app/UserListScreen.dart';
import 'package:matrimony_app/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

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
          content: Text(_userData[Favorite]
              ? "${_userData[Name]} Added to favorites"
              : "${_userData[Name]} Removed from favorites"),
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

  Future<void> _generateAndDownloadPDF(List<Map<String, dynamic>> users) async {
    setState(() => _isLoading = true);
    try {
      final pdf = pw.Document();

      for (var userData in users) {
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
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  _buildPDFRow('Name', userData[Name]),
                  _buildPDFRow('Gender', userData[Gender]),
                  _buildPDFRow('Date of Birth',
                      DateFormat('dd/MM/yyyy').format(userData[DOB])),
                  pw.SizedBox(height: 15),

                  // Address Details
                  pw.Text('Address Details',
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  _buildPDFRow('Address', userData[Address]),
                  _buildPDFRow('City', userData[City]),
                  _buildPDFRow('State', 'Gujarat'),
                  _buildPDFRow('Country', 'India'),
                  pw.SizedBox(height: 15),

                  // Contact Details
                  pw.Text('Contact Details',
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  _buildPDFRow('Email', userData[Email]),
                  _buildPDFRow('Phone', userData[Mobile]),
                  pw.SizedBox(height: 15),

                  // Hobbies
                  pw.Text('Hobbies',
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
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
      }

      final dir = await getApplicationDocumentsDirectory();
      final String fileName = '${_userData[Name]}_details.pdf';
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
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
            actions: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                onPressed: _isLoading ? null : () => _generateAndDownloadPDF([_userData]),
                tooltip: 'Download PDF',
              ),
              const SizedBox(width: 8),
            ],
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
                                        backgroundImage: AssetImage(
                                            'assets/images/person.png'),
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                                builder: (context) =>
                                                    AddUserScreen(
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
                                          onPressed: _isLoading
                                              ? null
                                              : () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          "Delete User"),
                                                      content: Text(
                                                          "Are you sure you want to delete ${_userData[Name]}?"),
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
                                                              _deleteUser,
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
                                          onPressed: _isLoading
                                              ? null
                                              : _toggleFavorite,
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
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
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
                                              const Icon(
                                                Icons.person_outline,
                                                color: Color(0xFFFF778D),
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "About",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFFF778D),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          // Name
                                          _buildDetailRow(
                                            icon: Icons.badge_outlined,
                                            label: "Name",
                                            value: "${_userData[Name]}",
                                          ),
                                          // Gender
                                          _buildDetailRow(
                                            icon: Icons.wc_outlined,
                                            label: "Gender",
                                            value: "${_userData[Gender]}",
                                          ),
                                          // Date of Birth
                                          _buildDetailRow(
                                            icon: Icons.cake_outlined,
                                            label: "Date of Birth",
                                            value:
                                                "${DateFormat('dd/MM/yyyy').format(_userData[DOB])}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Address Details Section
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
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
                                              const Icon(
                                                Icons.location_on_outlined,
                                                color: Color(0xFFFF778D),
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "Address Details",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFFF778D),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          _buildDetailRow(
                                            icon: Icons.home_outlined,
                                            label: "Address",
                                            value: "${_userData[Address]}",
                                          ),
                                          _buildDetailRow(
                                            icon: Icons.location_city_outlined,
                                            label: "City",
                                            value: "${_userData[City]}",
                                          ),
                                          _buildDetailRow(
                                            icon: CupertinoIcons.map,
                                            label: "State",
                                            value: "Gujarat",
                                          ),
                                          _buildDetailRow(
                                            icon: Icons.public_outlined,
                                            label: "Country",
                                            value: "India",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Personal Details Section
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
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
                                              const Icon(
                                                Icons.interests_outlined,
                                                color: Color(0xFFFF778D),
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "Personal Details",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFFF778D),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          // Hobbies
                                          _buildDetailRow(
                                            icon: Icons.favorite_border,
                                            label: "Hobbies",
                                            value:
                                                "${_userData[Hobbies]?.entries.where((entry) => entry.value == true).map((entry) => entry.key).join(', ')}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Contact Details Section
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
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
                                              const Icon(
                                                Icons.contact_page_outlined,
                                                color: Color(0xFFFF778D),
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "Contact Details",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFFF778D),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          // Email
                                          _buildDetailRow(
                                            icon: Icons.email_outlined,
                                            label: "Email ID",
                                            value: "${_userData[Email]}",
                                          ),
                                          // Phone
                                          _buildDetailRow(
                                            icon: Icons.phone_outlined,
                                            label: "Phone Number",
                                            value: "${_userData[Mobile]}",
                                          ),
                                        ],
                                      ),
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
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
              value,
              style: const TextStyle(
                fontSize: 16,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
