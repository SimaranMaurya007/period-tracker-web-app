import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  final String email; // Email parameter

  HistoryPage({required this.email});
  static const Color lightPink = Color(0xFFFFDDE8);
  static const Color visualBoxBackground = Color(0xFFFF90B3);
  final List<DateTime> markedDates = [];
  // List<DateTime> cycleHistory = [
  //   DateTime(2023, 12, 1),
  //   DateTime(2023, 12, 29),
  //   DateTime(2024, 1, 26),
  // ];

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int cycleDuration = 28;
  int periodLength = 5;
  List<DateTime> startDates = [];
  List<DateTime> cycleHistory = [
    DateTime(2023, 12, 1),
    DateTime(2023, 12, 29),
    DateTime(2024, 1, 26),
  ];

  @override
  void initState() {
    super.initState();
    _loadCycleDuration();
  }

  Future<void> _loadCycleDuration() async {
    List<DateTime> markedDates = await _fetchDataFromFirestore();
    List<DateTime> startDates = _getPeriodStartDates(markedDates);
    int averageCycleLength = _calculateAverageCycleLength(startDates);
    int meanperiodLength = calculateMeanOfFrequentPeriodLength(markedDates);

    setState(() {
      cycleDuration = averageCycleLength;
      periodLength = meanperiodLength;
      cycleHistory = startDates;
    });
  }

  Future<List<DateTime>> _fetchDataFromFirestore() async {
    List<DateTime> markedDates = [];
    try {
      // Replace with your user's email
      String email = widget.email;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        List<Timestamp> markedTimestamps = List.from(data['markedDates']);
        markedDates = markedTimestamps.map((ts) => ts.toDate()).toList();
      }
    } catch (e) {
      print('Error fetching marked dates: $e');
    }
    return markedDates;
  }

  List<DateTime> _getPeriodStartDates(List<DateTime> markedDates) {
    markedDates.sort();
    if (markedDates.isEmpty) return [];

    List<DateTime> startDates = [markedDates.first];

    for (int i = 1; i < markedDates.length; i++) {
      if (markedDates[i].difference(markedDates[i - 1]).inDays > 1) {
        startDates.add(markedDates[i]);
      }
    }
    return startDates;
  }

  int _calculateAverageCycleLength(List<DateTime> startDates) {
    if (startDates.length < 2) return 30;

    List<int> cycleLengths = [];
    for (int i = 1; i < startDates.length; i++) {
      cycleLengths.add(startDates[i].difference(startDates[i - 1]).inDays);
    }
    int sum = cycleLengths.fold(0, (a, b) => a + b);
    return (sum / cycleLengths.length).round();
  }

  int calculateMeanOfFrequentPeriodLength(List<DateTime> markedDates) {
    if (markedDates.isEmpty) return 0;

    // Sort the markedDates to ensure they are in order
    markedDates.sort();

    Map<int, int> lengthFrequency = {};
    int currentLength = 1;

    // Traverse through the dates to find consecutive or close dates (within 1 or 2 days)
    for (int i = 1; i < markedDates.length; i++) {
      int difference = markedDates[i].difference(markedDates[i - 1]).inDays;
      if (difference <= 2) {
        currentLength++;
      } else {
        // Store the frequency of currentLength in the map
        lengthFrequency[currentLength] =
            (lengthFrequency[currentLength] ?? 0) + 1;
        currentLength = 1;
      }
    }

    // Add the last group
    lengthFrequency[currentLength] = (lengthFrequency[currentLength] ?? 0) + 1;

    // Find the highest frequency in the map
    int maxFrequency = lengthFrequency.values.reduce(max);

    // Collect all lengths with the highest frequency
    List<int> mostFrequentLengths = lengthFrequency.entries
        .where((entry) => entry.value == maxFrequency)
        .map((entry) => entry.key)
        .toList();

    // Calculate the mean (average) of the most frequent lengths
    double meanOfFrequentLengths = mostFrequentLengths.reduce((a, b) => a + b) /
        mostFrequentLengths.length;

    return meanOfFrequentLengths.ceil();
  }

  List<Map<String, DateTime>> groupCycleDates(List<DateTime> cycleHistory) {
    List<Map<String, DateTime>> groupedCycles = [];
    if (cycleHistory.isEmpty) return groupedCycles;

    // Sort the cycle history
    cycleHistory.sort();

    DateTime startDate = cycleHistory[0];
    DateTime lastDate = cycleHistory[0];

    for (int i = 1; i < cycleHistory.length; i++) {
      DateTime currentDate = cycleHistory[i];

      // Check if the current date is consecutive to the last date
      if (currentDate.difference(lastDate).inDays == 1) {
        // Extend the last date in the current cycle
        lastDate = currentDate;
      } else {
        // If there is a break, save the current cycle
        groupedCycles.add({
          'startDate': startDate,
          'endDate': lastDate,
        });

        // Reset the start date to the current date
        startDate = currentDate;
        lastDate = currentDate;
      }
    }

    // Add the final cycle
    groupedCycles.add({
      'startDate': startDate,
      'endDate': lastDate,
    });

    return groupedCycles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History Page')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailBox('Cycle Duration', '$cycleDuration days', true),
            SizedBox(height: 16),
            _buildDetailBox('Period Length', '$periodLength days', true),
            SizedBox(height: 16),
            _buildHistoryBox(),
            SizedBox(height: 16),
            _buildCycleHistoryVisual(),
          ],
        ),
      ),
      backgroundColor: HistoryPage.lightPink,
    );
  }

  Widget _buildDetailBox(String title, String value, bool isNormal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isNormal ? '✔' : '!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isNormal ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildHistoryBox() {
    // List<DateTime> sortedCycleHistory =
    //     List.from(cycleHistory); // Create a copy
    // sortedCycleHistory
    //     .sort((a, b) => b.compareTo(a)); // Sort in descending order
    // List<Map<String, DateTime>> groupedCycleHistory =
    //     groupCycleDates(cycleHistory);
    List<Map<String, DateTime>> groupedCycleHistory =
        groupCycleDates(cycleHistory);

    // Reverse the order of the groupedCycleHistory
    groupedCycleHistory = groupedCycleHistory.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cycle History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        // if (cycleHistory.isNotEmpty)
        //   Column(
        //       children: sortedCycleHistory.map(_buildCycleHistoryItem).toList())
        // widget.cycleHistory.map(_buildCycleHistoryItem).toList())
        if (groupedCycleHistory.isNotEmpty)
          Column(
            children: groupedCycleHistory.map((cycle) {
              return _buildCycleHistoryItem(
                  cycle['startDate']!, cycle['endDate']!);
            }).toList(),
          )
        else
          Text('No cycle history available'),
      ],
    );
  }

  // Widget _buildCycleHistoryItem(DateTime date) {
  //   return ListTile(
  //     title: Text('Cycle on ${DateFormat('MMMM dd, yyyy').format(date)}'),
  //   );
  // }

  Widget _buildCycleHistoryItem(DateTime startDate, DateTime endDate) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cycle on ${DateFormat('MMMM dd, yyyy').format(startDate)}',
          ),
          // SizedBox(height: 8),
          // Container(
          //   width: double.infinity, // Make the container take the full width
          //   height: 20, // Set a height for the box
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(20), // Rounded edges
          //     gradient: LinearGradient(
          //       colors: [
          //         const Color.fromARGB(
          //             255, 226, 46, 94), // Starting color (red)
          //         Colors.white, // Ending color (white)
          //       ],
          //       begin: Alignment.centerLeft, // Gradient starts from left
          //       end: Alignment.centerRight, // Gradient ends on the right
          //     ),
          //   ),
          // ),
          SizedBox(height: 8),
          Container(
            width: double.infinity, // Make the container take the full width
            height: 10, // Set a height for the container
            child: Stack(
              children: [
                // Base Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the base
                    borderRadius: BorderRadius.circular(20), // Rounded edges
                  ),
                ),
                // Circular Patches using a loop
                ...List.generate(50, (index) {
                  double opacity =
                      1.0 - (index / 50); // Gradually decrease opacity
                  Color color = Color.lerp(
                    const Color.fromARGB(255, 134, 3, 67), // Starting color
                    Colors.white, // Ending color (white)
                    index / 50, // Interpolation value
                  )!;

                  return Positioned(
                    top: 0,
                    left: index *
                        5.0, // Increment the left position for each patch
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(
                            opacity), // Apply dynamic color and opacity
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleHistoryVisual() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HistoryPage.visualBoxBackground,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cycle History Visual',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _buildDayVisual('Period Day', Colors.red),
          _buildDayVisual('Ovulation Day', Colors.blue),
          _buildDayVisual('Normal Day', Colors.green),
        ],
      ),
    );
  }

  Widget _buildDayVisual(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
