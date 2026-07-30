// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizQuestionsHash() => r'3464fd56832919cc7fa9c41daa88086fa1d14d83';

/// 퀴즈 문항 목록. 촬영마다 새로 읽지 않고 앱 생애주기 동안 한 번만 읽는다.
///
/// Copied from [quizQuestions].
@ProviderFor(quizQuestions)
final quizQuestionsProvider =
    AutoDisposeFutureProvider<List<QuizQuestionEntity>>.internal(
      quizQuestions,
      name: r'quizQuestionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quizQuestionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuizQuestionsRef =
    AutoDisposeFutureProviderRef<List<QuizQuestionEntity>>;
String _$quizRoundHash() => r'cae903a1d316285cc72f6298713bcc0d703daa0d';

/// 현재 라운드 인덱스 — 셔터를 누를 때마다 하나씩 올라간다.
///
/// 무작위가 아니라 순차 순환이다(설계 문서 §7) — 시연 중 같은 문제가
/// 연달아 나오는 걸 막는다.
///
/// Copied from [QuizRound].
@ProviderFor(QuizRound)
final quizRoundProvider = AutoDisposeNotifierProvider<QuizRound, int>.internal(
  QuizRound.new,
  name: r'quizRoundProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizRoundHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuizRound = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
