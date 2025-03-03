import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:matrimony_app/User.dart';
import 'dart:convert';
import 'dart:ui';
import 'dart:math';

import 'package:matrimony_app/utils.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> _userList = [];
  bool _isLoading = true;
  Map<String, int> _hobbiesDistribution = {};
  int _maleCount = 0;
  int _femaleCount = 0;
  int _favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);

    try {
      final users = User();
      _userList = await users.getUserList();
      print('Loaded ${_userList.length} users');
      if (_userList.isNotEmpty) {
        print('Sample user data: ${_userList.first}');
      }

      // Calculate statistics
      _calculateHobbiesDistribution();
      _calculateGenderRatio();
      _calculateFavorites();

      setState(() => _isLoading = false);
    } catch (e, stackTrace) {
      print('Error loading statistics: $e');
      print('Stack trace: $stackTrace');
      setState(() => _isLoading = false);
    }
  }

  void _calculateHobbiesDistribution() {
    _hobbiesDistribution.clear();
    print('Processing hobbies for ${_userList.length} users');

    for (var user in _userList) {
      try {
        print('Processing hobbies for user: ${user[Name]}');
        final hobbies = user[Hobbies] as Map<String, bool>;
        print('User hobbies: $hobbies');

        hobbies.forEach((hobby, selected) {
          if (selected) {
            _hobbiesDistribution[hobby] =
                (_hobbiesDistribution[hobby] ?? 0) + 1;
          }
        });
      } catch (e, stackTrace) {
        print('Error processing hobbies for user: $e');
        print('User data: $user');
        print('Stack trace: $stackTrace');
      }
    }
    print('Final hobbies distribution: $_hobbiesDistribution');
  }

  void _calculateGenderRatio() {
    try {
      print('Calculating gender ratio from ${_userList.length} users');
      _maleCount = _userList.where((user) => user[Gender] == 'Male').length;
      _femaleCount = _userList.where((user) => user[Gender] == 'Female').length;
      print('Gender ratio - Male: $_maleCount, Female: $_femaleCount');
      print(
          'Sample gender values: ${_userList.map((u) => u[Gender]).take(5).toList()}');
    } catch (e, stackTrace) {
      print('Error calculating gender ratio: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _calculateFavorites() {
    try {
      print('Calculating favorites from ${_userList.length} users');
      _favoriteCount = _userList.where((user) => user[Favorite] == true).length;
      print('Favorites count: $_favoriteCount');
      print(
          'Sample favorite values: ${_userList.map((u) => u[Favorite]).take(5).toList()}');
    } catch (e, stackTrace) {
      print('Error calculating favorites: $e');
      print('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Bar Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Row(
            children: [
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.bar_chart,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                'Statistics',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  decoration: TextDecoration.none,
                  shadows: const [
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
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF778D),
                    ),
                  )
                : Column(
                    children: [
                      // Total Users Card
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFF5F8F),
                              Color(0xFFFF778D),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF778D).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Users',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${_userList.length}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.people,
                              size: 48,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Charts Section
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          children: [
                            // Hobbies Distribution
                            _buildHobbiesChart(),

                            // Gender Ratio
                            _buildGenderChart(),

                            // Favorites Count
                            _buildFavoritesChart(),
                          ],
                        ),
                      ),

                      // Page Indicator
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Color(0xFFFF778D)
                                  : Color(0xFFFF778D).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildHobbiesChart() {
    if (_hobbiesDistribution.isEmpty) {
      return Center(child: Text('No hobbies data available'));
    }

    return Column(
      children: [
        Text(
          'Hobbies Distribution',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: max(_hobbiesDistribution.length * 60.0,
                  MediaQuery.of(context).size.width - 48),
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 24, left: 8),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _hobbiesDistribution.values
                            .reduce((a, b) => a > b ? a : b)
                            .toDouble() +
                        1,
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        axisNameWidget: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'Hobbies',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            if (value.toInt() >= _hobbiesDistribution.length) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Transform.rotate(
                                angle: -0.5,
                                child: Text(
                                  _hobbiesDistribution.keys
                                      .elementAt(value.toInt()),
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2D3142),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                          reservedSize: 44,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: Container(),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          interval: 1,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            if (value == value.roundToDouble()) {
                              return Container(
                                padding: const EdgeInsets.only(right: 8),
                                width: 32,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  value.toInt().toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF7589A2),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFECECEC), width: 1),
                        left: BorderSide(color: Color(0xFFECECEC), width: 1),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Color(0xFFECECEC),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    barGroups: List.generate(
                      _hobbiesDistribution.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: _hobbiesDistribution.values
                                .elementAt(index)
                                .toDouble(),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFF5F8F),
                                Color(0xFFFF778D),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 14,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderChart() {
    if (_maleCount == 0 && _femaleCount == 0) {
      return Center(child: Text('No gender data available'));
    }

    return Column(
      children: [
        Text(
          'Gender Distribution',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        SizedBox(height: 24),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              final chartSize =
                  min(constraints.maxWidth * 0.6, availableHeight * 0.8);

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: chartSize,
                    height: chartSize,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: chartSize * 0.2,
                        sections: [
                          PieChartSectionData(
                            color: Color(0xFFFF5F8F),
                            value: _maleCount.toDouble(),
                            title:
                                '${((_maleCount / (_maleCount + _femaleCount)) * 100).round()}%',
                            radius: chartSize * 0.35,
                            titleStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Color(0xFFFF94A4),
                            value: _femaleCount.toDouble(),
                            title:
                                '${((_femaleCount / (_maleCount + _femaleCount)) * 100).round()}%',
                            radius: chartSize * 0.35,
                            titleStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGenderLegendItem(
                          color: Color(0xFFFF5F8F),
                          label: 'Male',
                          value: _maleCount,
                        ),
                        SizedBox(height: 16),
                        _buildGenderLegendItem(
                          color: Color(0xFFFF94A4),
                          label: 'Female',
                          value: _femaleCount,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenderLegendItem({
    required Color color,
    required String label,
    required int value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3142),
              ),
            ),
            Text(
              '$value users',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Color(0xFF7589A2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoritesChart() {
    return Column(
      children: [
        Text(
          'Favorites Overview',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        SizedBox(height: 24),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 100,
                  sections: [
                    PieChartSectionData(
                      color: Color(0xFFFF5F8F),
                      value: _favoriteCount.toDouble(),
                      title: '',
                      radius: 40,
                    ),
                    PieChartSectionData(
                      color: Color(0xFFFF94A4).withOpacity(0.3),
                      value: (_userList.length - _favoriteCount).toDouble(),
                      title: '',
                      radius: 35,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_favoriteCount',
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  Text(
                    'Favorites',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'out of ${_userList.length} users',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
