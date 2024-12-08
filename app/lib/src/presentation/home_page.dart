import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> topics = [
    {
      'title': 'Stories for Kids',
      'lessons': '12 lessons - Level: Medium',
      'imageUrl':
          'https://img.hoidap247.com/picture/answer/20210224/large_1614170446098.jpg'
    },
    {
      'title': 'TOEIC Listening',
      'lessons': '640 lessons - Level: Hard',
      'imageUrl':
          'https://img.hoidap247.com/picture/answer/20210224/large_1614170446098.jpg'
    },
    {
      'title': 'IELTS Listening',
      'lessons': '328 lessons - Level: Hard',
      'imageUrl':
          'https://img.hoidap247.com/picture/answer/20210224/large_1614170446098.jpg'
    },
    {
      'title': 'YouTube',
      'lessons': '103 lessons - Level: Hard',
      'imageUrl':
          'https://img.hoidap247.com/picture/answer/20210224/large_1614170446098.jpg'
    },
    {
      'title': 'TED & TED-Ed',
      'lessons': '41 lessons - Level: Hard',
      'imageUrl':
          'https://img.hoidap247.com/picture/answer/20210224/large_1614170446098.jpg'
    },
    {
      'title': 'News',
      'lessons': '14 lessons - Level: Hard',
      'imageUrl':
          'https://img.hoidap247.com/picture/answer/20210224/large_1614170446098.jpg'
    },
    {
      'title': 'TOEFL Listening',
      'lessons': '54 lessons - Level: Hard',
      'imageUrl': 'https://example.com/image7.jpg'
    },
    {
      'title': 'IPA',
      'lessons': '54 lessons - Level: Hard',
      'imageUrl': 'https://example.com/image8.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          String imageUrl = topics[index]['imageUrl'] ?? '';

          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Image.network(
                imageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
              title: Text(
                topics[index]['title']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(topics[index]['lessons']!),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle onTap if needed
              },
            ),
          );
        },
      ),
    );
  }
}
