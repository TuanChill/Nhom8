import 'package:daily_e/src/application/note_service.dart';
import 'package:daily_e/src/domain/note_model.dart';
import 'package:daily_e/src/utils/snackBarUtils.dart';
import 'package:flutter/material.dart';

class EditNotePage extends StatefulWidget {
  final Note? note;
  final int challengeId;

  const EditNotePage({this.note, required this.challengeId});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context); // Đóng trang
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Note:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                // Khi nhấn vào, mở trang để chỉnh sửa
                final editedNote = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TextEditPage(
                        note: widget.note, challengeId: widget.challengeId),
                  ),
                );
                if (editedNote != null) {
                  setState(() {
                    widget.note?.content = editedNote;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  (widget.note?.content ?? '').isEmpty
                      ? 'Tap to edit note'
                      : widget.note?.content ??
                          "", // Hiển thị thông báo nếu trống
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextEditPage extends StatefulWidget {
  final Note? note;
  final int challengeId;

  TextEditPage({this.note, required this.challengeId});

  @override
  _TextEditPageState createState() => _TextEditPageState();
}

class _TextEditPageState extends State<TextEditPage> {
  TextEditingController _noteController = TextEditingController();

  Future<void> updateNote(String text) async {
    if (widget.note == null) {
      await NoteService().createNote(text, widget.challengeId);
    } else {
      await NoteService().updateNote(
        text,
        widget.note!.documentId,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _noteController.text =
        widget.note?.content ?? ''; // Không có nội dung mặc định
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Edit your note',
                hintText: 'Enter your content here', // Gợi ý nhập nội dung
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await updateNote(_noteController.text);
                SnackBarUtils.showTopSnackBar(
                    context: context,
                    message: "Your note is changed",
                    backgroundColor: Colors.green);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
