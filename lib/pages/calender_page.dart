import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String name;

  Event(this.name);

  @override
  String toString() => name;
}

class CalendarPage extends StatefulWidget {
  final String email; // Email parameter

  CalendarPage({required this.email});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  // RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  // Set<dynamic> _kEvents = {};
  List<DateTime> markedDates = [];
  Map<DateTime, List<Event>> _kEvents = {};

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier<List<Event>>([]);
    _fetchDataFromFirestore(widget.email);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _fetchDataFromFirestore(String email) async {
    try {
      // Get reference to the user's document
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      // Check if the document exists and data is not null
      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>; // Cast data to Map

        // Check if the 'markedDates' field exists
        if (data.containsKey('markedDates')) {
          List<Timestamp> markedTimestamps = List.from(data['markedDates']);

          // Convert Timestamps to DateTime objects
          markedDates = markedTimestamps
              .map((ts) => DateTime(ts.toDate().year, ts.toDate().month,
                  ts.toDate().day)) // Set time to 00:00:00
              .toList();
          // setState(() {});
          // Do something with the markedDates list
          print(markedDates);
        }
      } else {
        print('No data found for the user.');
      }
    } catch (e) {
      print('Error fetching marked dates: $e');
    }
  }

  void _savePeriod(String email) async {
    if (_selectedDay != null) {
      DateTime selectedDate = _selectedDay!;

      try {
        // Reference to the user's document
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(email);

        // Check if the document exists
        DocumentSnapshot docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          // If the document exists, update it by adding the new marked date
          await userDoc.update({
            'markedDates':
                FieldValue.arrayUnion([Timestamp.fromDate(selectedDate)])
          });
          print('Marked date updated successfully.');
        } else {
          // If the document does not exist, create a new one with the marked date
          await userDoc.set({
            'email': email,
            'markedDates': [
              Timestamp.fromDate(selectedDate)
            ], // Add initial marked date
          });
          print('Document created and marked date added successfully.');
        }

        // Successfully saved, navigate to home page
        Navigator.of(context).pop(); // Go back to the previous screen
      } catch (e) {
        print('Error saving period: $e');
      }
    } else {
      print('No date selected.');
    }
  }

  String selectedBlock = '';
  Widget _buildSelectableBlock(String blockName, String imagePath) {
    bool isSelected = selectedBlock == blockName;

    return GestureDetector(
      onTap: () {
        // Handle the selection of the block here
        setState(() {
          selectedBlock = blockName;
        });
        print('Selected Block: $blockName');
      },
      child: Container(
        width: 100.0, // Adjust the width as needed
        height: 100.0, // Adjust the height as needed
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 233, 102, 102) : null,
          border: Border.all(
            color: isSelected ? Color.fromARGB(255, 81, 7, 7) : Colors.black,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 60.0, // Adjust the image width as needed
              height: 60.0, // Adjust the image height as needed
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8.0),
            Text(
              blockName,
              style: TextStyle(
                fontSize: 16.0, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Adjust the font weight as needed
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkers(BuildContext context, DateTime day, List<Event> events) {
    final markers = <Widget>[];

    // Check if events exist for the current day
    if (events.isNotEmpty) {
      // Iterate through each event for the day
      for (final event in events) {
        // Check if the event is a period type (e.g., 'Light', 'Medium', 'Heavy')
        if (event.name == 'Light' ||
            event.name == 'Medium' ||
            event.name == 'Heavy') {
          // Add a marker widget (circle) for each period type
          markers.add(
            Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getColorForPeriodType(event
                      .name), // Customize the color based on the period type
                ),
                width: 8,
                height: 8,
              ),
            ),
          );
        }
      }
    }

    // Return the list of markers
    return Row(children: markers);
  }

// Method to return color based on period type
  Color _getColorForPeriodType(String periodType) {
    switch (periodType) {
      case 'Light':
        return Colors.blue; // Customize color for Light period type
      case 'Medium':
        return Colors.green; // Customize color for Medium period type
      case 'Heavy':
        return Colors.red; // Customize color for Heavy period type
      default:
        return Colors.black; // Default color
    }
  }

  static final kFirstDay = DateTime(2000, 1, 1);
  static final kLastDay = DateTime(2101, 12, 31);

  Widget _buildMoodSelectable(String moodName, String imagePath) {
    bool isSelected = selectedMood == moodName;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = moodName;
        });
        print('Selected Mood: $moodName');
      },
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 233, 102, 102) : null,
          border: Border.all(
            color: isSelected ? Color.fromARGB(255, 81, 7, 7) : Colors.black,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 60.0,
              height: 60.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8.0),
            Text(
              moodName,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String selectedMood = '';
  Color _getMonthCellBackgroundColor(DateTime date) {
    if (_kEvents.containsKey(date)) {
      final event = _kEvents[date]!.first;
      switch (event.name) {
        case 'Light':
          return Colors.lightBlueAccent;
        case 'Medium':
          return Colors.orangeAccent;
        case 'Heavy':
          return Colors.redAccent;
        default:
          return Colors.transparent;
      }
    }
    return Colors.transparent;
  }

  Color _getCellTextColor(Color backgroundColor) {
    return backgroundColor == Colors.transparent ? Colors.black : Colors.white;
  }

  DateTime? getPredicatedDate(List<DateTime> markedDates) {
    if (markedDates.isEmpty) return null; // Return null if the list is empty

    // Find the last (greatest) marked date
    DateTime lastMarkedDate =
        markedDates.reduce((a, b) => a.isAfter(b) ? a : b);

    // Add 35 days to the last marked date
    DateTime predicatedDate = lastMarkedDate.add(Duration(days: 30));

    return predicatedDate;
  }

  @override
  Widget build(BuildContext context) {
    DateTime? predicatedDate = getPredicatedDate(markedDates);
    String predicatedDateString = predicatedDate != null
        ? DateFormat('yMMMd').format(predicatedDate)
        : 'No predicted date available';
    
    return Scaffold(
             appBar: AppBar(
         leading: IconButton(
           icon: Icon(Icons.arrow_back),
           onPressed: () => Navigator.of(context).pop(),
         ),
         title: Text('Select Period Date'),
         backgroundColor: Colors.pink[100],
         elevation: 0,
         actions: [
           IconButton(
             icon: Icon(Icons.chevron_left),
             onPressed: () {
               setState(() {
                 _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
               });
             },
           ),
           IconButton(
             icon: Icon(Icons.chevron_right),
             onPressed: () {
               setState(() {
                 _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
               });
             },
           ),
         ],
       ),
      body: SingleChildScrollView(
        child: Column(
          children: [
                         // Calendar Section
             Container(
               margin: EdgeInsets.all(16.0),
               child: TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerVisible: false,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(color: Colors.red),
                  holidayTextStyle: TextStyle(color: Colors.red),
                  defaultTextStyle: TextStyle(color: Colors.black87),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayTextStyle: TextStyle(color: Colors.white),
                  selectedDecoration: BoxDecoration(
                    color: Colors.pink[300],
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.pink[200],
                    shape: BoxShape.circle,
                  ),
                ),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) {
                  return _kEvents[day] ?? [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedEvents.value = _kEvents[selectedDay] ?? [];
                  });
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, _) {
                    bool isMarked = markedDates
                        .any((markedDate) => isSameDay(markedDate, date));
                    return Container(
                      decoration: BoxDecoration(
                        color: isMarked
                            ? const Color.fromARGB(255, 243, 37, 51)
                                .withOpacity(0.5)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 0.5),
                      ),
                      alignment: Alignment.center,
                      width: 40.0,
                      height: 40.0,
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: isMarked ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  },
                  markerBuilder: (context, date, events) {
                    return SizedBox();
                  },
                ),
              ),
            ),
            
                         // Periods Section
             Container(
               margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
               padding: EdgeInsets.all(16.0),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Period Type',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.pink[700],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSelectableBlock('Light', 'assets/light1.png'),
                      _buildSelectableBlock('Medium', 'assets/medium1.png'),
                      _buildSelectableBlock('Heavy', 'assets/heavy1.png'),
                    ],
                  ),
                ],
              ),
            ),
            
                         // Mood Section
             Container(
               margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
               padding: EdgeInsets.all(16.0),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mood',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.pink[700],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildMoodSelectable('Happy', 'assets/happy.png'),
                        SizedBox(width: 12.0),
                        _buildMoodSelectable('Sad', 'assets/sad.png'),
                        SizedBox(width: 12.0),
                        _buildMoodSelectable('Excited', 'assets/excited.png'),
                        SizedBox(width: 12.0),
                        _buildMoodSelectable('Angry', 'assets/angry.png'),
                        SizedBox(width: 12.0),
                        _buildMoodSelectable('Calm', 'assets/calm.png'),
                        SizedBox(width: 12.0),
                        _buildMoodSelectable('Confused', 'assets/confused.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
                         // Predicted Date Section
             Container(
               margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
               padding: EdgeInsets.all(16.0),
               child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.pink[700]),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      'Predicted Period Date: $predicatedDateString',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.pink[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            _savePeriod(widget.email);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[400],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            'Save Period',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
