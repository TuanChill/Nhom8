import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:daily_e/src/application/note_service.dart';
import 'package:daily_e/src/domain/note_model.dart';

void main() {
  group('NoteService', () {
    test('creates a note successfully when API response is 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
            jsonEncode({
              "data": {"id": 1}
            }),
            200);
      });

      final noteService = NoteService();
      final String text = "This is a test note.";
      final int challengeId = 1;

      // Act
      final response = await noteService.createNote(text, challengeId);

      // Assert
      expect(response.statusCode, equals(200));
    });

    test('updates a note successfully when API response is 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
            jsonEncode({
              "data": {"id": 1}
            }),
            200);
      });

      final noteService = NoteService();
      final String text = "Updated note content.";
      final String documentId = "note_1";

      // Act
      final response = await noteService.updateNote(text, documentId);

      // Assert
      expect(response.statusCode, equals(200));
    });

    test('fetches notes successfully when API response is 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({
            "data": [
              {
                "id": 1,
                "documentId": "note_1",
                "content": "This is a test note."
              },
              {"id": 2, "documentId": "note_2", "content": "Another test note."}
            ]
          }),
          200,
        );
      });

      final noteService = NoteService();

      // Act
      final notes = await noteService.getNotes("challenge_1");

      // Assert
      expect(notes, isA<List<Note>>());
      expect(notes.length, equals(2));
      expect(notes[0].documentId, equals("note_1"));
      expect(notes[1].content, equals("Another test note."));
    });

    test('throws exception when fetching notes fails', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response('Error', 500);
      });

      final noteService = NoteService();

      // Act & Assert
      expect(() => noteService.getNotes("challenge_1"), throwsException);
    });

    test('deletes a note successfully when API response is 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
            jsonEncode({"message": "Note deleted successfully"}), 200);
      });

      final noteService = NoteService();
      final String noteId = "note_1";

      // Act
      final response = await noteService.deleteNotes(noteId);

      // Assert
      expect(response.statusCode, equals(200));
    });

    test('throws exception when deleting a note fails', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response('Error', 500);
      });

      final noteService = NoteService();
      final String noteId = "note_1";

      // Act & Assert
      expect(() => noteService.deleteNotes(noteId), throwsException);
    });
  });
}
