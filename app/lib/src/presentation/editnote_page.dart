import 'package:daily_e/src/application/note_service.dart';
import 'package:daily_e/src/domain/note_model.dart';
import 'package:flutter/material.dart';

class EditNotePage extends StatefulWidget {
  final Note? note;

  const EditNotePage({this.note});

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
                    builder: (context) => TextEditPage(note: widget.note),
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
                  color: Colors.grey[200],
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

  TextEditPage({this.note});

  @override
  _TextEditPageState createState() => _TextEditPageState();
}

class _TextEditPageState extends State<TextEditPage> {
  TextEditingController _noteController = TextEditingController();

  Future<void> updateNote(String text) async {
    // Gọi hàm updateNote từ NoteService
    await NoteService().updateNote(
      text,
      widget.note!.documentId,
    );
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
              onPressed: () {
                Navigator.pop(context, _noteController.text);
                updateNote(_noteController.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
