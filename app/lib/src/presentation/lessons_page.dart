import 'dart:async';
import 'package:daily_e/src/presentation/listen_and_read.dart';
import 'package:flutter/material.dart';
import 'package:daily_e/src/application/lesson_service.dart';
import 'package:daily_e/src/domain/lesson_model.dart';
import 'package:daily_e/src/presentation/challenge_page.dart';

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
  bool _isListenAndReadMode = false; // Thêm chế độ Listen and Read
  int currentPage = 1;
  final int pageSize = 25;
  Set<String> selectedLessonIds = {}; // Track selected lessons

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

  Widget _buildLessonList() {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...filteredLessons.map((lesson) {
            final index = filteredLessons.indexOf(lesson);
            final isSelected = selectedLessonIds.contains(lesson.documentId);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black45
                        : Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
              child: ListTile(
                leading: _isListenAndReadMode
                    ? Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedLessonIds.add(lesson.documentId);
                            } else {
                              selectedLessonIds.remove(lesson.documentId);
                            }
                          });
                        },
                      )
                    : null,
                title: Text(
                  '${index + 1}. ${lesson.name}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                subtitle: Text(
                  "${lesson.name} challenges",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengePage(
                        lessonId: lesson.documentId,
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          if (_isFetchingMore)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Short Stories", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.teal[900]
            : Colors.teal[700],
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
              decoration: InputDecoration(
                hintText: "Search lessons...",
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black45,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredLessons.isEmpty
                    ? const Center(child: Text("No lessons found"))
                    : _buildLessonList(),
          ),
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.teal[50],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isListenAndReadMode
                          ? Colors.blueGrey
                          : Colors.grey[300],
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _isListenAndReadMode = true;
                      });
                    },
                    child: const Text("Listen and Read"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_isListenAndReadMode
                          ? Colors.blueGrey
                          : Colors.grey[300],
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _isListenAndReadMode = false;
                      });
                    },
                    child: const Text("Listen and Type"),
                  ),
                ],
              ),
            ),
          ),
          if (_isListenAndReadMode)
            Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[850]
                  : Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Selected ${selectedLessonIds.length} lessons",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListenAndRead(
                              lessonIds: selectedLessonIds.toList(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Start"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
