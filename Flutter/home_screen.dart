import 'package:flutter/material.dart';
import 'package:matrimony_app/AboutUsScreen.dart';
import 'package:matrimony_app/AddUserScreen.dart';
import 'package:matrimony_app/FavouriteUserScreen.dart';
import 'package:matrimony_app/User.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_app/UserListScreen.dart';

class HomeScreen extends StatelessWidget {
  final User users;
  const HomeScreen({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF5F8F),
            Color(0xFFFF778D),
            Color(0xFFFF94A4),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Bar Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 35,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Forever',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      decoration: TextDecoration.none,
                      shadows: [
                        Shadow(
                          blurRadius: 12.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.fromLTRB(24, 36, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Welcome to \n Forever Matrimony',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                        height: 1.3,
                        decoration: TextDecoration.none,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black12,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Find your perfect match with us',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 45),

                    // Grid Items
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        children: [
                          // Add Profile Card
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddUserScreen(users: users),
                                  )),
                              splashColor: Color(0xFFFF778D).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color:
                                        Color(0xFFFF778D).withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF778D)
                                            .withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.person_add_rounded,
                                        size: 36,
                                        color: Color(0xFFFF5F8F),
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    Text(
                                      'Add Profile',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2D3142),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Browse Profiles Card
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                   return UserList(users: users);
                                }));
                              },
                              splashColor: Color(0xFFFF778D).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color:
                                        Color(0xFFFF778D).withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF778D)
                                            .withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.people_rounded,
                                        size: 36,
                                        color: Color(0xFFFF5F8F),
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    Text(
                                      'Browse Profiles',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2D3142),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Favorites Card
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                   return FavouriteUser(users: users);
                                }));
                              },
                              splashColor: Color(0xFFFF778D).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color:
                                        Color(0xFFFF778D).withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF778D)
                                            .withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.favorite_rounded,
                                        size: 36,
                                        color: Color(0xFFFF5F8F),
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    Text(
                                      'Favorites',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2D3142),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // About Us Card
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                   return AboutUsScreen();
                                }));
                              },
                              splashColor: Color(0xFFFF778D).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color:
                                        Color(0xFFFF778D).withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF778D)
                                            .withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.info_rounded,
                                        size: 36,
                                        color: Color(0xFFFF5F8F),
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    Text(
                                      'About Us',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2D3142),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
