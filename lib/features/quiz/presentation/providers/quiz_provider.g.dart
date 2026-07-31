// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizQuestionsHash() => r'3464fd56832919cc7fa9c41daa88086fa1d14d83';

/// 퀴즈 문항 목록. 화면이 보고 있는 동안은 캐시되고, 아무도 보지 않는 순간
/// dispose됐다가 다음에 다시 읽는다(autoDispose) — 정적 에셋이라 다시 읽어도
/// 결과가 같으므로 무해하다.
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
String _$quizRoundHash() => r'6936c811d00e09ce74c976c5b328282fd1c2468f';

/// 현재 라운드 인덱스 — 셔터를 누를 때마다 하나씩 올라간다.
///
/// 무작위가 아니라 순차 순환이다(설계 문서 §7) — 시연 중 같은 문제가
/// 연달아 나오는 걸 막는다.
///
/// 앱 생애주기 동안 유지 (keepAlive) — scan_page가 `next()`를 부른 시점과
/// quiz_page가 처음 watch하는 시점 사이에는 이 provider를 보는 화면이 하나도
/// 없다. autoDispose였다면 그 틈에 상태가 사라지고 0으로 리셋될 수 있어
/// (Riverpod의 프레임 유예에 기대는 셈이라 위험하다), 촬영할 때마다 수달만
/// 나오는 시연 사고로 이어진다.
///
/// Copied from [QuizRound].
@ProviderFor(QuizRound)
final quizRoundProvider = NotifierProvider<QuizRound, int>.internal(
  QuizRound.new,
  name: r'quizRoundProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizRoundHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuizRound = Notifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
