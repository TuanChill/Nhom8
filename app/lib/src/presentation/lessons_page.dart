import 'dart:async';
import 'package:daily_e/src/application/lesson_service.dart';
import 'package:flutter/material.dart';
import 'package:daily_e/src/domain/lesson_model.dart';

class LessonListPage extends StatefulWidget {
  final String topicId;

  const LessonListPage({super.key, required this.topicId});

  @override
  State<LessonListPage> createState() => _LessonListPage();
}

class _LessonListPage extends State<LessonListPage> {
  final List<Lesson> lessons = [];
  List<Lesson> filteredLessons = [];
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTopics();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchTopics() async {
    try {
      List<Lesson> fetchedLessons =
          await LessonService().getLessonsByTopic(widget.topicId, '');
      setState(() {
        lessons.clear();
        lessons.addAll(fetchedLessons);
        filteredLessons = lessons;
      });
    } catch (e) {
      debugPrint("Error fetching lessons: $e");
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(() {
      _isLoading = true;
    });
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filteredLessons = lessons
            .where((lesson) => lesson.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Short Stories", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search lessons...",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Lessons List
          Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredLessons.isEmpty
                      ? const Center(child: Text("No lessons found"))
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              itemCount: filteredLessons.length,
                              itemBuilder: (context, index) {
                                final lesson = filteredLessons[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        '${index + 1}. ${lesson.name}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "${lesson.name} challenges",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16),
                                      onTap: () {
                                        debugPrint(
                                            "Tapped on: ${lesson.documentId}");
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        )),
        ],
      ),
    );
  }
}
