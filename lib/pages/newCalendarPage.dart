import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String name;

  Event(this.name);

  @override
  String toString() => name;
}

class NewCalendarPage extends StatefulWidget {
  final String email; // Email parameter

  NewCalendarPage({required this.email});

  @override
  _NewCalendarPageState createState() => _NewCalendarPageState();
}

class _NewCalendarPageState extends State<NewCalendarPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Calendar Page'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime(2000, 1, 1),
            lastDay: DateTime(2101, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
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
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              // Customize the appearance of each date cell
              defaultBuilder: (context, date, _) {
                bool isMarked = markedDates
                    .any((markedDate) => isSameDay(markedDate, date));
                return Container(
                  decoration: BoxDecoration(
                    color: isMarked
                        ? const Color.fromARGB(255, 243, 37, 51)
                            .withOpacity(0.5)
                        : Colors
                            .transparent, // Change background color for marked dates
                    shape: BoxShape.circle, // Set shape to circle
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  alignment: Alignment.center,
                  width: 40.0, // Set width to make it more circular
                  height: 40.0, // Set height to make it more circular
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isMarked
                          ? Colors.white
                          : Colors.black, // Change text color for marked dates
                    ),
                  ),
                );
              },

              markerBuilder: (context, date, events) {
                // You can still use marker builder for additional markers if needed
                return SizedBox(); // Return an empty SizedBox for now
              },
            ),
          ),
          const SizedBox(height: 8.0),
          ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return Expanded(
                child: ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(value[index].toString()),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
