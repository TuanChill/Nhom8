import 'package:flutter/material.dart';

class ActivityHistory extends StatefulWidget {
  const ActivityHistory({Key? key}) : super(key: key);

  @override
  _ActivityHistoryState createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  late Future<List<Map<String, String>>> _activityFuture;

  @override
  void initState() {
    super.initState();
    _activityFuture = fetchActivities();
  }

  // Hàm giả lập lấy dữ liệu từ backend
  Future<List<Map<String, String>>> fetchActivities() async {
    await Future.delayed(const Duration(seconds: 2)); // Giả lập thời gian chờ API
    return [
      {"title": "Logged in", "date": "26 Dec 2024, 10:00 AM"},
      {"title": "Updated profile", "date": "25 Dec 2024, 2:45 PM"},
      {"title": "Changed password", "date": "20 Dec 2024, 11:30 AM"},
      {"title": "Logged out", "date": "15 Dec 2024, 5:15 PM"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activity History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, String>>>(
          future: _activityFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No activities found.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            } else {
              final activities = snapshot.data!;
              return ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.event_note, color: Colors.teal),
                      title: Text(
                        activity["title"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(activity["date"]!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Details for ${activity["title"]}")),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
