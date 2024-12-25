import 'package:daily_e/src/application/challenge_service.dart';
import 'package:daily_e/src/domain/lesson_model.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:daily_e/src/domain/challenge_model.dart';
import 'dart:async';

class ListenAndRead extends StatefulWidget {
  final List<String> lessonIds;

  const ListenAndRead({super.key, required this.lessonIds});

  @override
  _ListenAndReadState createState() => _ListenAndReadState();
}

class _ListenAndReadState extends State<ListenAndRead> {
  int currentLessonIndex = 0;
  late Lesson currentLesson = Lesson(id: 0, name: 'Loading...', documentId: '');
  final List<Challenge> sentences = [];
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  int currentAudioIndex = 0;
  double playbackSpeed = 1.0; // Default playback speed
  Duration timerDuration = const Duration(minutes: 15);
  late Timer? timer;
  Duration totalListeningTime = Duration.zero; // Total listening time
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    try {
      setState(() {
        sentences.clear();
      });
      final challenges = await ChallengeService()
          .getChallenges(widget.lessonIds[currentLessonIndex]);
      setState(() {
        sentences.addAll(challenges);

        if (sentences.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No challenges available")),
          );
        }

        currentLesson = sentences[0].lesson;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading challenges: $e")),
      );
    }
  }

  Future<void> playAllAudio() async {
    if (sentences.isEmpty) return;

    setState(() {
      isPlaying = true;
      currentAudioIndex = 0;
    });

    for (int i = 0; i < sentences.length; i++) {
      setState(() {
        currentAudioIndex = i;
        _scrollToCurrentAudio();
      });
      await playAudio(sentences[i].source.url);
      if (!isPlaying) break;
    }

    setState(() {
      isPlaying = false;
      currentAudioIndex = -1; // Reset the index when done
    });
  }

  Future<void> playAudio(String url) async {
    await audioPlayer.setPlaybackRate(playbackSpeed); // Set speed
    await audioPlayer.play(UrlSource(url));
    await audioPlayer.onPlayerComplete.first; // Wait for audio to complete

    // Update total listening time
    final duration = await audioPlayer.getDuration();
    setState(() {
      totalListeningTime += duration ?? Duration.zero;
    });
  }

  void stopAudio() {
    audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void _goToNextLesson() {
    if (currentLessonIndex < widget.lessonIds.length - 1) {
      setState(() {
        currentLessonIndex++;
      });
      _loadChallenges();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This is the last lesson.")),
      );
    }
  }

  void _goToPreviousLesson() {
    if (currentLessonIndex > 0) {
      setState(() {
        currentLessonIndex--;
      });
      _loadChallenges();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This is the first lesson.")),
      );
    }
  }

  void _startTimer() {
    if (timer != null) timer?.cancel();
    setState(() {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (timerDuration.inSeconds <= 0) {
            timer.cancel();
            stopAudio();
          } else {
            timerDuration = timerDuration - const Duration(seconds: 1);
          }
        });
      });
    });
  }

  void _resetTimer() {
    if (timer != null) timer?.cancel();
    setState(() {
      timerDuration = const Duration(minutes: 15);
    });
  }

  void _scrollToCurrentAudio() {
    if (currentAudioIndex < sentences.length - 11) {
      _scrollController.animateTo(
        currentAudioIndex * 56.0, // Assuming each ListTile has a height of 56.0
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sentences.isNotEmpty
            ? "${currentLessonIndex + 1}. ${currentLesson.name}"
            : "Loading..."),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: sentences.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      playAudio(sentences[index].source.url);
                    },
                  ),
                  title: Text(
                    sentences[index].answer,
                    style: const TextStyle(fontSize: 16),
                  ),
                  tileColor: index == currentAudioIndex
                      ? Colors.lightBlueAccent
                      : Colors.transparent,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.fast_rewind),
                  onPressed: _goToPreviousLesson,
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (isPlaying) {
                      stopAudio();
                    } else {
                      playAllAudio();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.fast_forward),
                  onPressed: _goToNextLesson,
                ),
                IconButton(
                  icon: const Icon(Icons.speed),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Playback Speed"),
                          content: StatefulBuilder(
                            builder: (context, setStateDialog) {
                              return SizedBox(
                                height: 100, // Set a fixed height
                                child: Column(
                                  children: [
                                    Slider(
                                      value: playbackSpeed,
                                      min: 0.5,
                                      max: 2.0,
                                      divisions: 6,
                                      label:
                                          "${playbackSpeed.toStringAsFixed(1)}x",
                                      onChanged: (value) {
                                        setStateDialog(() {
                                          playbackSpeed = value;
                                        });
                                        audioPlayer
                                            .setPlaybackRate(playbackSpeed);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text(
                  "Total Listening Time: ${totalListeningTime.inMinutes.toString().padLeft(2, '0')}:${(totalListeningTime.inSeconds % 60).toString().padLeft(2, '0')}",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
