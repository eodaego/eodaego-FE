import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/quiz_mock_datasource.dart';
import '../../data/datasources/quiz_remote_datasource.dart';
import '../../data/repositories/quiz_repository_impl.dart';
import '../../domain/repositories/quiz_repository.dart';

part 'quiz_provider.g.dart';

/// QuizRemoteDataSource Provider (Retrofit)
///
/// `EnvConfig.useMockData`가 켜지면 [QuizMockDataSource]로 바뀐다.
/// **주의**: 목이 정답 id를 인메모리로 들고 있어 keepAlive여야 한다.
@Riverpod(keepAlive: true)
QuizRemoteDataSource quizRemoteDataSource(Ref ref) {
  if (EnvConfig.useMockData) return QuizMockDataSource();
  return QuizRemoteDataSource(ref.watch(dioProvider));
}

/// QuizRepository Provider
@Riverpod(keepAlive: true)
QuizRepository quizRepository(Ref ref) =>
    QuizRepositoryImpl(ref.watch(quizRemoteDataSourceProvider));
