import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:daily_e/src/domain/lesson_model.dart';
import 'package:daily_e/src/application/lesson_service.dart';

void main() {
  group('LessonService', () {
    test('returns list of lessons by topic when API response is successful',
        () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({
            'data': [
              {
                'id': 1,
                'documentId': 'lesson_1',
                'name': 'Lesson 1',
              },
              {
                'id': 2,
                'documentId': 'lesson_2',
                'name': 'Lesson 2',
              },
            ]
          }),
          200,
        );
      });

      // Act
      final lessonService = LessonService();
      final lessons =
          await lessonService.getLessonsByTopic('topic_1', 'keyword', 1, 10);

      // Assert
      expect(lessons, isA<List<Lesson>>());
      expect(lessons.length, equals(2));
      expect(lessons[0].name, equals('Lesson 1'));
      expect(lessons[1].documentId, equals('lesson_2'));
    });

    test('throws exception when fetching lessons by topic fails', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response('Error', 500);
      });

      // Act
      final lessonService = LessonService();

      // Assert
      expect(() => lessonService.getLessonsByTopic('topic_1', 'keyword', 1, 10),
          throwsException);
    });

    test('returns a lesson by document ID when API response is successful',
        () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({
            'id': 1,
            'documentId': 'lesson_1',
            'name': 'Lesson 1',
          }),
          200,
        );
      });

      // Act
      final lessonService = LessonService();
      final lesson = await lessonService.getLessonById('lesson_1');

      // Assert
      expect(lesson, isA<Lesson>());
      expect(lesson.id, equals(1));
      expect(lesson.name, equals('Lesson 1'));
    });

    test('throws exception when fetching lesson by ID fails', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response('Error', 404);
      });

      // Act
      final lessonService = LessonService();

      // Assert
      expect(() => lessonService.getLessonById('lesson_1'), throwsException);
    });

    test('handles empty lesson list response gracefully', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({'data': []}),
          200,
        );
      });

      // Act
      final lessonService = LessonService();
      final lessons =
          await lessonService.getLessonsByTopic('topic_1', 'keyword', 1, 10);

      // Assert
      expect(lessons, isA<List<Lesson>>());
      expect(lessons.isEmpty, isTrue);
    });
  });
}
