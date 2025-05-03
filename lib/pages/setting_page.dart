import 'package:flutter/material.dart';

import 'BlogDetailPage.dart';

void main() {
  runApp(SettingsPage());
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlogPage(),
    );
  }
}

class BlogPage extends StatelessWidget {
  final List<Map<String, String>> blogs = [
    {
      'title': 'Understanding Menstrual Cycle Phases',
      'image': 'assets/menstrual_cycle.jpg',
      'content': '''
        The menstrual cycle is a complex physiological process that occurs in women, primarily regulated by hormonal changes. 
        It typically lasts about 28 days, although the length can vary from person to person.
      ''',
    },
    {
      'title': 'Tips for Managing Period Cramps',
      'image': 'assets/cramps1.jpg',
      'content': '''
        Phases, each characterized by specific hormonal and physiological changes. 
        Here are the key phases of the menstrual cycle:
        Menstrual Phase (Days 1-5):
        Description: This phase marks the beginning of the menstrual cycle and starts on the first day of menstruation (bleeding).
        Hormonal Changes: Estrogen and progesterone levels are low during this phase.
      ''',
    },
    {
      'title': 'Healthy Diet During Menstruation',
      'image': 'assets/healthy1.jpg',
      'content': '''
        Description: This phase begins on the first day of menstruation and extends until ovulation.
        Hormonal Changes: Follicle-stimulating hormone (FSH) stimulates the development of ovarian follicles,
      ''',
    },
    {
      'title': 'Exercises for Menstrual Health',
      'image': 'assets/exercise1.jpg',
      'content': '''
        Description: Ovulation usually occurs around the middle of the menstrual cycle.
        Hormonal Changes: A surge in luteinizing hormone (LH) triggers the release of a mature egg from the dominant follicle.
      ''',
    },
    {
      'title': 'Self-Care Tips for Periods',
      'image': 'assets/selfcare1.jpg',
      'content': '''
        Description: This phase begins on the first day of menstruation and extends until ovulation.
        Hormonal Changes: Follicle-stimulating hormone (FSH) stimulates the development of ovarian follicles,
      ''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs'),
        backgroundColor: Colors.purple[200],
      ),
      body: ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetailPage(
                    title: blogs[index]['title'] ?? 'Default Title',
                    imagePath:
                        blogs[index]['image'] ?? 'assets/default_image.jpg',
                    content: blogs[index]['content'] ?? 'Default Content',
                  ),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blog Image
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      image: DecorationImage(
                        image: AssetImage(blogs[index]['image'] ??
                            'assets/default_image.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Blog Title
                          Text(
                            blogs[index]['title'] ?? 'Default Title',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          // Blog Content (Preview)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
