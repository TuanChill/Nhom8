import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:daily_e/src/domain/topic_model.dart';
import 'package:daily_e/src/application/topic_service.dart';

void main() {
  group('TopicService', () {
    test('trả về danh sách chủ đề khi phản hồi API thành công', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({
            'data': [
              {
                'id': 1,
                'documentId': 'doc_1',
                'name': 'Topic 1',
                'level': 'Beginner',
                'thumbnail': {
                  'id': 1,
                  'documentId': 'thumb_1',
                  'name': 'Thumbnail 1',
                  'url': 'https://example.com/thumb1.jpg',
                },
                'lessions': [
                  {
                    'id': 1,
                    'name': 'Lesson 1',
                    'content': 'Lesson Content 1',
                  }
                ]
              },
              {
                'id': 2,
                'documentId': 'doc_2',
                'name': 'Topic 2',
                'level': 'Intermediate',
                'thumbnail': null,
                'lessions': []
              }
            ]
          }),
          200,
        );
      });

      // Act
      final topicService = TopicService();
      final topics = await topicService.getTopics();

      // Assert
      expect(topics, isA<List<Topic>>());
      expect(topics.length, equals(2));
      expect(topics[0].name, equals('Topic 1'));
      expect(
          topics[1].thumbnail.name, equals('')); // Default value for thumbnail
    });

    test('ném Exception khi phản hồi API không thành công', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response('Error', 500);
      });

      // Act
      final topicService = TopicService();

      // Assert
      expect(() => topicService.getTopics(), throwsException);
    });

    test('xử lý các giá trị null trong phản hồi API một cách duyên dáng', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({
            'data': [
              {
                'id': null,
                'documentId': null,
                'name': null,
                'level': null,
                'thumbnail': null,
                'lessions': null
              }
            ]
          }),
          200,
        );
      });

      // Act
      final topicService = TopicService();
      final topics = await topicService.getTopics();

      // Assert
      expect(topics, isA<List<Topic>>());
      expect(topics.length, equals(1));
      expect(topics[0].id, equals(0)); // Default value for id
      expect(topics[0].name, equals('')); // Default value for name
      expect(topics[0].lessons, isEmpty); // Default value for lessons
    });
  });
}
