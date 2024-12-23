import 'package:flutter/material.dart';
import 'package:daily_e/src/presentation/editnote_page.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String? _note = 'Here are your notes'; // Ghi chú mặc định

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your note'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // Mở trang chỉnh sửa và chờ dữ liệu trả về
              final editedNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNotePage(initialNote: _note),
                ),
              );

              // Cập nhật ghi chú nếu có thay đổi
              if (editedNote != null) {
                setState(() {
                  _note = editedNote;
                });
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          _note ?? 'No notes yet.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
