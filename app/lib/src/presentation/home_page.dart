import 'package:daily_e/constant.dart';
import 'package:daily_e/src/application/topic_service.dart';
import 'package:daily_e/src/domain/topic_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Topic> topics = []; // State variable

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    List<Topic> fetchedTopics = await TopicService().getTopics();

    print(fetchedTopics);

    setState(() {
      topics.addAll(fetchedTopics);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Topics',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${API_URL.urlHost}/${topics[index].thumbnail.url}',
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
              ),
              title: Text(
                topics[index].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(topics[index].level),
              trailing: const Icon(Icons.arrow_forward_ios),
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
