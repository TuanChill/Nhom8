import 'dart:async';

import 'package:daily_e/src/application/challenge_service.dart';
import 'package:daily_e/src/application/note_service.dart';
import 'package:daily_e/src/domain/challenge_model.dart';
import 'package:daily_e/src/presentation/setting_page.dart';
import 'package:daily_e/src/presentation/note_page.dart';
import 'package:daily_e/src/presentation/editnote_page.dart';
import 'package:daily_e/src/utils/snackBarUtils.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengePage extends StatefulWidget {
  final String lessonId;

  const ChallengePage({super.key, required this.lessonId});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage>
    with WidgetsBindingObserver {
  int activeTimeInSeconds = 0; // Thời gian hoạt động tính bằng giây
  Timer? _timer;

  final TextEditingController _inputController = TextEditingController();
  String hintMessage = "";
  String hintAnswer = "";

  final TextEditingController _inputNoteController = TextEditingController();

  int currentPage = 1;
  int totalPages = 21;
  Challenge? currentChallenge;

  AudioPlayer? _audioPlayer;
  bool isPlaying = false;
  bool isLoading = false;
  double selectedSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _loadChallenge();
    WidgetsBinding.instance.addObserver(this);
    _loadActiveTime();
    _startTimer();
  }

  Future<void> _setupAudioPlayer() async {
    // Dispose existing audio player if it exists
    await _audioPlayer?.dispose();

    // Create new audio player for current challenge
    _audioPlayer = AudioPlayer();
    _audioPlayer?.onPlayerComplete.listen((event) async {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> _loadChallenge() async {
    setState(() {
      isLoading = true;
    });
    try {
      ChallengeResponse response = await ChallengeService().getChallenge(
        widget.lessonId,
        currentPage,
      );
      setState(() {
        currentChallenge = response.challenges.first;
        isLoading = false;
      });
      // Set up new audio player after challenge is loaded
      await _setupAudioPlayer();
    } catch (e) {
      debugPrint("Error loading challenge: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _checkAnswer() {
    if (currentChallenge != null) {
      String userInput = _inputController.text.trim().toLowerCase();
      String correctAnswer = currentChallenge!.answer.trim().toLowerCase();

      if (hintAnswer.isNotEmpty) {
        hintMessage = "";
        hintAnswer = "";
        // Clear input field
        _inputController.text = "";

        // Load next challenge
        _goToNextPage();
        return;
      }

      if (userInput == correctAnswer) {
        SnackBarUtils.showTopSnackBar(
          context: context,
          message: 'Correct answer! 🎉',
          backgroundColor: Colors.green,
        );

        setState(() {
          hintMessage = ""; // Xóa gợi ý nếu đúng
          hintAnswer = currentChallenge?.answer ?? ""; // Hiển thị đáp án đúng
          _inputController.text = currentChallenge?.answer ?? "";
        });
      } else {
        String hint = _generateHint(userInput, correctAnswer);
        SnackBarUtils.showTopSnackBar(
          context: context,
          message: 'Incorrect answer. Try again! ❌',
          backgroundColor: Colors.teal,
        );
        setState(() {
          hintMessage = "Hint: $hint";
        });
      }
    }
  }

  String _generateHint(String userInput, String correctAnswer) {
    List<String> userWords = userInput.split(' ');
    List<String> correctWords = correctAnswer.split(' ');
    List<String> hintWords = [];

    bool revealNextWord = false;

    for (int i = 0; i < correctWords.length; i++) {
      if (i < userWords.length && userWords[i] == correctWords[i]) {
        hintWords.add(correctWords[i]);
        revealNextWord = true;
      } else if (revealNextWord) {
        hintWords.add(correctWords[i]);
        revealNextWord = false;
      } else {
        hintWords.add('*' * correctWords[i].length);
      }
    }

    return hintWords.join(' ');
  }

  void _revealAnswer() {
    if (currentChallenge != null) {
      setState(() {
        if (hintAnswer.isNotEmpty) {
          hintAnswer = "";
        } else {
          hintAnswer = currentChallenge!.answer;
        }
      });
      SnackBarUtils.showTopSnackBar(
        context: context,
        message: 'Answer revealed! ✔️',
        backgroundColor: Colors.orange,
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _saveActiveTime();
    _timer?.cancel();
  }

  Future<void> _togglePlayPause() async {
    if (_audioPlayer == null) return;

    if (isPlaying) {
      debugPrint("Pausing");
      await _audioPlayer?.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      debugPrint("Playing: ${currentChallenge!.source.url}");
      await _audioPlayer?.play(UrlSource(currentChallenge!.source.url));
      await _audioPlayer?.setPlaybackRate(selectedSpeed);
      setState(() {
        isPlaying = true;
      });
    }
  }

  void _changePlaybackSpeed(double speed) async {
    setState(() {
      selectedSpeed = speed;
    });
    if (isPlaying) {
      await _audioPlayer?.setPlaybackRate(selectedSpeed);
    }
  }

  void _goToNextPage() {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
        isPlaying = false;
      });
      _loadChallenge();
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        isPlaying = false;
      });
      _loadChallenge();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _saveActiveTime(); // Lưu thời gian khi ứng dụng bị tạm dừng hoặc đóng
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        activeTimeInSeconds++;
      });
    });
  }

  void _loadActiveTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      activeTimeInSeconds = prefs.getInt('activeTime') ?? 0;
    });
  }

  void _saveActiveTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('activeTime', activeTimeInSeconds);
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    return "$minutes minutes";
  }

  void saveNote() async {
    final text = _inputNoteController.text;
    Response res = await NoteService().createNote(text, currentChallenge!.id);
    if (!mounted) return; // Check if the widget is still mounted
    if (res.statusCode == 201) {
      SnackBarUtils.showTopSnackBar(
        context: context,
        message: 'Note saved successfully! 📝',
        backgroundColor: Colors.green,
      );
      Navigator.pop(context); // Đóng drawer
    } else if (res.statusCode == 401) {
      SnackBarUtils.showTopSnackBar(
        context: context,
        message: 'Please login! 🔒',
        backgroundColor: Colors.red,
      );
    }
  }

  void showNotesDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Quan trọng để tránh bị che
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Leave a note",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please let us know what is going on below.",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _inputNoteController,
                  decoration: InputDecoration(
                    hintText: "Leave note here...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        saveNote();
                        // Navigator.pop(context); // Đóng drawer
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text("Leave Note",
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Đóng drawer
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[200],
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Active time today: ${_formatTime(activeTimeInSeconds)}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              currentChallenge != null && currentChallenge!.lesson.name != null
                  ? "${currentChallenge!.lesson.id}. ${currentChallenge!.lesson.name}"
                  : "",
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz, color: Colors.grey[700]),
            offset: const Offset(0, 40), // Đẩy menu xuống dưới icon
            onSelected: (value) {
              // note, setting, reset
              if (value == 'View notes') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotePage(
                            challengeId: currentChallenge?.documentId ?? '',
                          )), // Navigate to NotePage
                );
              } else if (value == 'Settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsScreen()), // Navigate to SettingsScreen
                );
              } else if (value == 'Reset lesson') {
                // Reset lesson to the first page
                setState(() {
                  currentPage = 1; // Set currentPage to 1 (first page)
                  isPlaying = false; // Optional: Reset play status
                });
                _loadChallenge(); // Reload the challenge for the first page
                // _showTopSnackBar('Lesson reset to the first page! 🔄', Colors.blue);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'View notes',
                child: Text('View notes'),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'Reset lesson',
                child: Text('Reset lesson'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[700]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.teal,
                          size: 40,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<double>(
                          value: selectedSpeed,
                          items: [0.5, 1.0, 1.5, 2.0]
                              .map((speed) => DropdownMenuItem(
                                    value: speed,
                                    child: Text('${speed}x'),
                                  ))
                              .toList(),
                          onChanged: (speed) {
                            if (speed != null) {
                              _changePlaybackSpeed(speed);
                            }
                          },
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _goToPreviousPage,
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                          ),
                          Text(
                            "$currentPage / $totalPages",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          IconButton(
                            onPressed: _goToNextPage,
                            icon: const Icon(Icons.arrow_forward_ios, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _inputController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Type what you hear...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      if (hintMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            hintMessage,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      if (hintAnswer.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Answer:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 8,
                                children: hintAnswer.split(' ').map((word) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      word,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (hintAnswer.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () => showNotesDrawer(context),
                          icon: const Icon(
                            Icons.edit,
                            size: 24.0,
                            color: Colors.black, // Màu biểu tượng
                          ),
                          label: const Text(
                            'Add Notes',
                            style: TextStyle(
                              color: Colors.white, // Màu chữ
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF4D6A73), // Màu nền của nút
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Bo góc nút
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _revealAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                        ),
                        child: Text(hintAnswer.isEmpty ? 'Skip' : 'Redo',
                            style: const TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: _togglePlayPause,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                        ),
                        child: Text(isPlaying ? 'Pause' : 'Play Again',
                            style: const TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: _checkAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                        ),
                        child: Text(hintAnswer.isNotEmpty ? 'Next' : 'Check',
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
