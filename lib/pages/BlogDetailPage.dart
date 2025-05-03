// blog_detail_page.dart

import 'package:flutter/material.dart';

class BlogDetailPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String content;

  BlogDetailPage(
      {required this.title, required this.imagePath, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Details'),
      ),
      body: Stack(
        children: [
          // Background with Mild and Transparent Pink Color
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.pink.withOpacity(0.1),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Centered Blog Image with Pink Background
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.pink.withOpacity(
                        0.2), // Mild and transparent pink background
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        imagePath,
                        width: 120.0,
                        height: 120.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // White Box with Rounded Corners
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12, // Mild shadow color
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Blog Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Blog Content
                      Text(
                        content,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
