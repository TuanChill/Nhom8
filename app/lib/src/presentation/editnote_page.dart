import 'package:flutter/material.dart';

class EditNotePage extends StatefulWidget {
  final String? initialNote;

  EditNotePage({this.initialNote});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  String _note = '';

  @override
  void initState() {
    super.initState();
    _note = widget.initialNote ?? ''; // Không có nội dung mặc định
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
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
            Text(
              'Your Note:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                // Khi nhấn vào, mở trang để chỉnh sửa
                final editedNote = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TextEditPage(initialNote: _note),
                  ),
                );
                if (editedNote != null) {
                  setState(() {
                    _note = editedNote; // Cập nhật ghi chú
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  _note.isEmpty ? 'Tap to edit note' : _note, // Hiển thị thông báo nếu trống
                  style: TextStyle(fontSize: 16),
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
  final String? initialNote;

  TextEditPage({this.initialNote});

  @override
  _TextEditPageState createState() => _TextEditPageState();
}

class _TextEditPageState extends State<TextEditPage> {
  TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.initialNote ?? ''; // Không có nội dung mặc định
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
              decoration: InputDecoration(
                labelText: 'Edit your note',
                hintText: 'Enter your content here', // Gợi ý nhập nội dung
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _noteController.text); // Trả dữ liệu về
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditNotePage(),
  ));
}
