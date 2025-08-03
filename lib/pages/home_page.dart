import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:period_tracker_app/pages/chat_page.dart';

// import 'profile_page.dart';
import 'Calender_page.dart';
import 'History_page.dart';
import 'Setting_page.dart';
// import 'chat_page.dart';
import 'newCalendarPage.dart';
import 'profile_page.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  final String userId;
  final String email;

  HomePage({required this.userId, required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

List<FAQ> faqList = [
  FAQ(
    question: 'How long is the average period length?',
    answer:
        'The time from the first sign of blood to the last is usually in the 3-to-5-day range. It’s common for cycles to be a little irregular for a few years after your first period. This means your periods may not always come at the same time every cycle, and they may be a bit different from one month to the next. Don’t worry, as you progress through adolescence, your cycles will become more regular and start to reflect adult cycle ranges, but they may still be a bit variable.',
  ),
  FAQ(
    question: 'Is it normal to have a period twice in a month?',
    answer:
        'Yes, it’s possible. Why? Some months, your menstrual cycle may last for more or fewer days than the previous month.Or your cycle may start earlier or later than before.If you usually have a regular cycle, a change in your cycle could indicate a medical condition. In case of any concerns, please talk to your doctor to get individual medical advice..',
  ),
  FAQ(
      question: 'How to treat irregular periods?',
      answer:
          'For irregular periods there usually is no immediate reason to consult your doctor. But if you are concerned, please do so. If you need contraception your doctor can help you with that by prescribing you hormonal contraceptives which do not only reliably prevent unintended pregnancies but can also stabilize your menstrual cycle so that you can better plan for your periods.'),
  FAQ(
      question: 'What causes hormonal imbalance?',
      answer:
          'A hormonal imbalance means that women or girls have too much or too little of a certain hormone (like estrogen and progesterone).Estrogen, progesterone, testosterone, thyroxin, insulin and cortisol levels can be detected in the blood through blood tests. Please talk to your doctor for individual medical advice.'),
  FAQ(
      question: 'Why are my period cramps so painful?',
      answer:
          'Painful period cramps could be caused by heavy menstrual bleeding, which often affects you to take part in everyday life around your period. Or they could be caused by endometriosis. In this painful condition, the cells or tissue lining the uterus, grow outside the uterus. You should see your doctor who can do a blood test and get your history to help you get better. Some hormonal contraceptives are registered for women or girls with heavy menstrual bleeding who also need contraception.'),
  FAQ(
      question: 'Can sperm survive in period blood?',
      answer:
          'Yes, sperm can survive in your body for up to 5 days whether you are menstruating or not. And the period blood can not flush away sperm. Please always use a contraceptive method to avoid unplanned pregnancies.'),
  // Add more questions and answers as needed
];

class _HomePageState extends State<HomePage> {
  DateTime? selectedDate = DateTime.now();
  List<DateTime> markedDates = [];
  // DateTime? selectedDate = DateTime.now();
  // List<DateTime> markedDates = [];
  DateTime? predicatedDate;
  String predicatedDateString = 'No predicted date available';
  int daysUntilNextPeriod = 0;
  @override
  void initState() {
    super.initState();
    // _loadEvents();
    _fetchDataFromFirestore(widget.email);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _navigateToProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePage(
                userId: widget.userId,
                email: widget.email,
              )),
    );
  }

  void _navigateToCalendarPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CalendarPage(
                email: widget.email,
              )),
    );
  }

  void _fetchDataFromFirestore(String email) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;

        if (data.containsKey('markedDates')) {
          List<Timestamp> markedTimestamps = List.from(data['markedDates']);

          // Convert Firestore Timestamps to DateTime objects
          markedDates = markedTimestamps
              .map((ts) => DateTime(
                  ts.toDate().year, ts.toDate().month, ts.toDate().day))
              .toList();

          // Calculate predicted date after fetching marked dates
          predicatedDate = getPredicatedDate(markedDates);

          // Format the predicted date string
          predicatedDateString = predicatedDate != null
              ? DateFormat('yMMMd').format(predicatedDate!)
              : 'No predicted date available';

          // Calculate days until the next predicted period
          daysUntilNextPeriod = predicatedDate != null
              ? predicatedDate!.difference(DateTime.now()).inDays
              : 0;

          // Update the UI with setState
          setState(() {});
        }
      } else {
        print('No data found for the user.');
      }
    } catch (e) {
      print('Error fetching marked dates: $e');
    }
  }

  // Function to calculate the predicted period date
  DateTime? getPredicatedDate(List<DateTime> markedDates) {
    if (markedDates.isEmpty) return null;

    DateTime lastMarkedDate =
        markedDates.reduce((a, b) => a.isAfter(b) ? a : b);

    // Add 30 days to the last marked date (or change the logic for cycle length)
    return lastMarkedDate.add(Duration(days: 30));
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.pink.withOpacity(0.25),
        ),
        child: Icon(icon, color: Colors.white), // Set icon color to white
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = selectedDate != null
        ? DateFormat('EEE, dd MMM').format(selectedDate!)
        : 'Today';
    DateTime? predicatedDate = getPredicatedDate(markedDates);
    String predicatedDateString = predicatedDate != null
        ? DateFormat('yMMMd').format(predicatedDate) // Format the date
        : 'No predicted date available';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // title: Text('Welcome'),
              title: Text(
                'Hola!',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change color if needed
                ),
              ),
              background: Container(
                width: double.infinity,
                height: 100.0,
                child: Stack(
                  children: [
                    // Background Image
                    Image.asset(
                      'assets/pink_back.jpg', // Ensure this path is correct
                      fit: BoxFit.cover, // Cover the entire space
                      width: double
                          .infinity, // Make sure it stretches to fill the width
                      height:
                          400.0, // Set the height to match the FlexibleSpaceBar
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: const Color.fromARGB(255, 199, 56,
                              166), // Background color of the circle
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.person,
                            color: const Color.fromARGB(255, 252, 252,
                                252), // Adjust icon color if needed
                          ),
                          onPressed: () => _navigateToProfilePage(context),
                        ),
                      ),
                    ),

                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/Aura.jpg', // Replace with your photo asset path
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 50),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE91E63).withOpacity(0.5),
                    ),
                    padding: EdgeInsets.all(100.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Text(
                            'Today $formattedDate',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Predicted next Period Date: $predicatedDateString',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () => _navigateToCalendarPage(context),
                          child: Text('Select period Date'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20), // Adjust as needed
                // Q&A section
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Frequently Asked Questions',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 215, 97, 225),
                          ),
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: faqList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Color(0xFFE91E63).withOpacity(0.5),
                              child: ExpansionTile(
                                title: Text(
                                  faqList[index].question,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      faqList[index].answer,
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)
                                              .withOpacity(0.5)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor:
                const Color.fromARGB(255, 0, 0, 0), // White for selected items
            unselectedItemColor: const Color.fromARGB(
                255, 0, 0, 0), // Light pink for unselected items
            selectedLabelStyle:
                TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            unselectedLabelStyle: TextStyle(color: Colors.pink[100]),
          ),
        ),
        child: BottomNavigationBar(
          items: [
            _buildBottomNavigationBarItem(Icons.calendar_today, 'Calendar'),
            _buildBottomNavigationBarItem(Icons.history, 'History'),
            _buildBottomNavigationBarItem(Icons.chat, 'Chat'),
            _buildBottomNavigationBarItem(Icons.book, 'Blog'),
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          showSelectedLabels: true, // Ensure selected labels are shown
          showUnselectedLabels: true, // Ensure unselected labels are shown
          onTap: (index) {
            // Handle navigation based on the tapped index
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewCalendarPage(email: widget.email),
                  ),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(email: widget.email),
                  ),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}
