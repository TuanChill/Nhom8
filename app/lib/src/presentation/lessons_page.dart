import 'dart:async';
import 'package:daily_e/src/application/lesson_service.dart';
import 'package:daily_e/src/presentation/challenge_page.dart';
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
  ScrollController scrollController = ScrollController();
  Timer? _debounce;
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int currentPage = 1;
  final int pageSize = 25;

  @override
  void initState() {
    super.initState();
    fetchTopics();
    searchController.addListener(_onSearchChanged);
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchTopics({bool loadMore = false}) async {
    if (loadMore) {
      setState(() => _isFetchingMore = true);
    } else {
      setState(() => _isLoading = true);
    }

    try {
      List<Lesson> fetchedLessons = await LessonService()
          .getLessonsByTopic(widget.topicId, '', currentPage, pageSize);

      setState(() {
        if (loadMore) {
          lessons.addAll(fetchedLessons);
        } else {
          lessons.clear();
          lessons.addAll(fetchedLessons);
        }
        filteredLessons = lessons;
        if (loadMore) _isFetchingMore = false;
      });
    } catch (e) {
      debugPrint("Error fetching lessons: $e");
      setState(() {
        if (loadMore) _isFetchingMore = false;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !_isFetchingMore) {
      currentPage++;
      fetchTopics(loadMore: true);
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(() => _isLoading = true);
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
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
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredLessons.isEmpty
                    ? const Center(child: Text("No lessons found"))
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            if (!_isFetchingMore) {
                              currentPage++;
                              fetchTopics(loadMore: true);
                            }
                          }
                          return false;
                        },
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: filteredLessons.length +
                              (_isFetchingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == filteredLessons.length) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            final lesson = filteredLessons[index];
                            return ListTile(
                              title: Text(
                                '${index + 1}. ${lesson.name}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${lesson.name} challenges",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                print("Tapped on: ${lesson.documentId}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChallengePage(
                                      lessonId: lesson.documentId,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
