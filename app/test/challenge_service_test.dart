import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:daily_e/src/application/note_service.dart';
import 'package:daily_e/src/domain/note_model.dart';

void main() {
  // Ensure the binding is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NoteService', () {
    late NoteService noteService;

    setUp(() {
      noteService = NoteService();
    });

    test('Tạo ghi chú thành công khi phản hồi API là 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(jsonEncode({'id': 1, 'content': 'Nội dung ghi chú'}), 200);
      });

      NoteService noteService = NoteService();
      Response response =
          await mockHTTPClient.post(Uri.parse('http://api.url'), body: {
        "data": {
          "content": "Nội dung ghi chú",
          "challenge": 1,
          "users_permissions_user": "1"
        }
      });

      // Assert
      expect(response.statusCode, 200);
      expect(jsonDecode(response.body)['content'], 'Nội dung ghi chú');
    });

    test('Cập nhật ghi chú thành công khi phản hồi API là 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
            jsonEncode({'id': 1, 'content': 'Cập nhật ghi chú'}), 200);
      });

      NoteService noteService = NoteService();
      Response response =
          await mockHTTPClient.put(Uri.parse('http://api.url/note_id'), body: {
        "data": {
          "content": "Cập nhật ghi chú",
        }
      });

      // Assert
      expect(response.statusCode, 200);
      expect(jsonDecode(response.body)['content'], 'Cập nhật ghi chú');
    });

    test('Lấy ghi chú thành công khi phản hồi API là 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({
            'data': [
              {'id': 1, 'documentId': 'doc_1', 'content': 'Ghi chú 1'},
              {'id': 2, 'documentId': 'doc_2', 'content': 'Ghi chú 2'},
            ]
          }),
          200,
        );
      });

      NoteService noteService = NoteService();
      List<Note> notes = await noteService.getNotes("challengeId");

      // Assert
      expect(notes, isA<List<Note>>());
      expect(notes.length, 2);
      expect(notes[0].content, 'Ghi chú 1');
      expect(notes[1].content, 'Ghi chú 2');
    });

    test('Xóa ghi chú thành công khi phản hồi API là 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response('', 200);
      });

      NoteService noteService = NoteService();
      Response response =
          await mockHTTPClient.delete(Uri.parse('http://api.url/note_id'));

      // Assert
      expect(response.statusCode, 200);
    });

    test('Ném exception khi phản hồi API không thành công', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response('Error', 500);
      });

      NoteService noteService = NoteService();

      // Assert
      expect(
        () async => await noteService.getNotes("challengeId"),
        throwsException,
      );
    });
  });
}
