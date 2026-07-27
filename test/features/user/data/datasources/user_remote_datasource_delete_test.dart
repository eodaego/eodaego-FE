import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:eodaego/features/user/data/datasources/user_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계에서만 가짜를 쓴다. Retrofit 생성 코드는 실제로 실행된다.
class _StubHttpClientAdapter implements HttpClientAdapter {
  _StubHttpClientAdapter(this._fetch);

  final Future<ResponseBody> Function(RequestOptions options) _fetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => _fetch(options);

  @override
  void close({bool force = false}) {}
}

void main() {
  group('UserRemoteDataSource.deleteAccount', () {
    test('204 빈 본문 응답에서 예외 없이 완료된다', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      late String capturedPath;
      late String capturedMethod;

      dio.httpClientAdapter = _StubHttpClientAdapter((options) async {
        capturedPath = options.path;
        capturedMethod = options.method;
        return ResponseBody.fromString('', 204);
      });

      final dataSource = UserRemoteDataSource(dio);

      await dataSource.deleteAccount();

      expect(capturedMethod, 'DELETE');
      expect(capturedPath, contains('/members/me'));
    });
  });
}
