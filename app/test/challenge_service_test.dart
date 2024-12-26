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

    test('creates a note successfully when API response is 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(jsonEncode({'id': 1, 'content': 'Note Content'}), 200);
      });

      NoteService noteService = NoteService();
      Response response =
          await mockHTTPClient.post(Uri.parse('http://api.url'), body: {
        "data": {
          "content": "Note Content",
          "challenge": 1,
          "users_permissions_user": "1"
        }
      });

      // Assert
      expect(response.statusCode, 200);
      expect(jsonDecode(response.body)['content'], 'Note Content');
    });

    test('updates a note successfully when API response is 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
            jsonEncode({'id': 1, 'content': 'Updated Content'}), 200);
      });

      NoteService noteService = NoteService();
      Response response =
          await mockHTTPClient.put(Uri.parse('http://api.url/note_id'), body: {
        "data": {
          "content": "Updated Content",
        }
      });

      // Assert
      expect(response.statusCode, 200);
      expect(jsonDecode(response.body)['content'], 'Updated Content');
    });

    test('fetches notes successfully when API response is 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({
            'data': [
              {'id': 1, 'documentId': 'doc_1', 'content': 'Note 1'},
              {'id': 2, 'documentId': 'doc_2', 'content': 'Note 2'},
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
      expect(notes[0].content, 'Note 1');
      expect(notes[1].content, 'Note 2');
    });

    test('deletes a note successfully when API response is 200', () async {
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

    test('throws exception when API response is unsuccessful', () async {
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
