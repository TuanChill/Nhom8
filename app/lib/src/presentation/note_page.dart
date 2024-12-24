import 'package:daily_e/src/application/note_service.dart';
import 'package:daily_e/src/domain/note_model.dart';
import 'package:daily_e/src/utils/snackBarUtils.dart';
import 'package:flutter/material.dart';
import 'package:daily_e/src/presentation/editnote_page.dart';

class NotePage extends StatefulWidget {
  final String challengeId;
  const NotePage({super.key, required this.challengeId});
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final List<Note> _notes = [];
  bool _isLoading = true; // Biến trạng thái loading

  Future<void> fetchNotes() async {
    setState(() {
      _isLoading = true; // Bắt đầu trạng thái loading
    });

    List<Note> fetchedNotes = await NoteService().getNotes(widget.challengeId);

    setState(() {
      _notes.clear();
      _notes.addAll(fetchedNotes);
      _isLoading = false; // Kết thúc trạng thái loading
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNotes(); // Fetch data lần đầu khi page được khởi tạo
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data lại mỗi khi phụ thuộc của widget thay đổi
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Hiển thị loading indicator
            )
          : _notes.isEmpty
              ? const Center(
                  child: Text(
                    'No notes yet.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: ListTile(
                        title: Text(
                          _notes[index].content,
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editNote(_notes[index]);
                            } else if (value == 'delete') {
                              _deleteNote(_notes[index], context);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(),
      ),
    ).then((value) {
      // Fetch data lại sau khi trở về từ trang thêm ghi chú
      fetchNotes();
    });
  }

  void _editNote(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(
          note: note,
        ),
      ),
    ).then((value) {
      // Fetch data lại sau khi trở về từ trang chỉnh sửa
      fetchNotes();
    });
  }

  Future<void> _deleteNote(Note note, context) async {
    await NoteService().deleteNotes(note.documentId);
    SnackBarUtils.showTopSnackBar(
      context: context,
      message: 'Note deleted',
      backgroundColor: Colors.red,
    );
    fetchNotes();
  }
}
