// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizModelImpl _$$QuizModelImplFromJson(Map<String, dynamic> json) =>
    _$QuizModelImpl(
      quizId: json['quizId'] as String,
      choices:
          (json['choices'] as List<dynamic>?)
              ?.map((e) => QuizChoiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <QuizChoiceModel>[],
    );

Map<String, dynamic> _$$QuizModelImplToJson(_$QuizModelImpl instance) =>
    <String, dynamic>{'quizId': instance.quizId, 'choices': instance.choices};

_$QuizChoiceModelImpl _$$QuizChoiceModelImplFromJson(
  Map<String, dynamic> json,
) => _$QuizChoiceModelImpl(
  catalogItemId: json['catalogItemId'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$$QuizChoiceModelImplToJson(
  _$QuizChoiceModelImpl instance,
) => <String, dynamic>{
  'catalogItemId': instance.catalogItemId,
  'name': instance.name,
};

_$QuizAnswerRequestModelImpl _$$QuizAnswerRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$QuizAnswerRequestModelImpl(
  selectedCatalogItemId: json['selectedCatalogItemId'] as String,
);

Map<String, dynamic> _$$QuizAnswerRequestModelImplToJson(
  _$QuizAnswerRequestModelImpl instance,
) => <String, dynamic>{'selectedCatalogItemId': instance.selectedCatalogItemId};

_$QuizAnswerModelImpl _$$QuizAnswerModelImplFromJson(
  Map<String, dynamic> json,
) => _$QuizAnswerModelImpl(
  correct: json['correct'] as bool,
  collectedCatalogItemId: json['collectedCatalogItemId'] as String?,
);

Map<String, dynamic> _$$QuizAnswerModelImplToJson(
  _$QuizAnswerModelImpl instance,
) => <String, dynamic>{
  'correct': instance.correct,
  'collectedCatalogItemId': instance.collectedCatalogItemId,
};
