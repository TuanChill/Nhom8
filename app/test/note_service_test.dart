import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:daily_e/src/application/note_service.dart';
import 'package:daily_e/src/domain/note_model.dart';

void main() {
  group('NoteService', () {
    test('Tạo ghi chú thành công khi phản hồi API là 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
            jsonEncode({
              "data": {"id": 1}
            }),
            200);
      });

      final noteService = NoteService();
      final String text = "Đây là một ghi chú thử nghiệm.";
      final int challengeId = 1;

      // Act
      final response = await noteService.createNote(text, challengeId);

      // Assert
      expect(response.statusCode, equals(200));
    });

    test('Cập nhật ghi chú thành công khi API phản hồi là 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
            jsonEncode({
              "data": {"id": 1}
            }),
            200);
      });

      final noteService = NoteService();
      final String text = "Cập nhật nội dung ghi chú.";
      final String documentId = "note_1";

      // Act
      final response = await noteService.updateNote(text, documentId);

      // Assert
      expect(response.statusCode, equals(200));
    });

    test('Lấy ghi chú thành công khi phản hồi API là 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({
            "data": [
              {
                "id": 1,
                "documentId": "note_1",
                "content": "Đây là một ghi chú thử nghiệm."
              },
              {"id": 2, "documentId": "note_2", "content": "Ghi chú thử nghiệm khác."}
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
      expect(notes[1].content, equals("Ghi chú thử nghiệm khác."));
    });

    test('Ném exception khi việc lấy ghi chú không thành công', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response('Error', 500);
      });

      final noteService = NoteService();

      // Act & Assert
      expect(() => noteService.getNotes("challenge_1"), throwsException);
    });

    test('Xóa ghi chú thành công khi API phản hồi là 200', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
            jsonEncode({"message": "Xóa ghi chú thành công"}), 200);
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
