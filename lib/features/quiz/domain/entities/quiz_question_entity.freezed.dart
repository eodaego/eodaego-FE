// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_question_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuizQuestionEntity {
  String get name => throw _privateConstructorUsedError;
  DogamCategory get category => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  List<String> get choices => throw _privateConstructorUsedError;
  int get answerIndex => throw _privateConstructorUsedError;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
  String? get code => throw _privateConstructorUsedError;

  /// Create a copy of QuizQuestionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizQuestionEntityCopyWith<QuizQuestionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizQuestionEntityCopyWith<$Res> {
  factory $QuizQuestionEntityCopyWith(
    QuizQuestionEntity value,
    $Res Function(QuizQuestionEntity) then,
  ) = _$QuizQuestionEntityCopyWithImpl<$Res, QuizQuestionEntity>;
  @useResult
  $Res call({
    String name,
    DogamCategory category,
    String question,
    List<String> choices,
    int answerIndex,
    String? code,
  });
}

/// @nodoc
class _$QuizQuestionEntityCopyWithImpl<$Res, $Val extends QuizQuestionEntity>
    implements $QuizQuestionEntityCopyWith<$Res> {
  _$QuizQuestionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizQuestionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? category = null,
    Object? question = null,
    Object? choices = null,
    Object? answerIndex = null,
    Object? code = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as DogamCategory,
            question: null == question
                ? _value.question
                : question // ignore: cast_nullable_to_non_nullable
                      as String,
            choices: null == choices
                ? _value.choices
                : choices // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            answerIndex: null == answerIndex
                ? _value.answerIndex
                : answerIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizQuestionEntityImplCopyWith<$Res>
    implements $QuizQuestionEntityCopyWith<$Res> {
  factory _$$QuizQuestionEntityImplCopyWith(
    _$QuizQuestionEntityImpl value,
    $Res Function(_$QuizQuestionEntityImpl) then,
  ) = __$$QuizQuestionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    DogamCategory category,
    String question,
    List<String> choices,
    int answerIndex,
    String? code,
  });
}

/// @nodoc
class __$$QuizQuestionEntityImplCopyWithImpl<$Res>
    extends _$QuizQuestionEntityCopyWithImpl<$Res, _$QuizQuestionEntityImpl>
    implements _$$QuizQuestionEntityImplCopyWith<$Res> {
  __$$QuizQuestionEntityImplCopyWithImpl(
    _$QuizQuestionEntityImpl _value,
    $Res Function(_$QuizQuestionEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizQuestionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? category = null,
    Object? question = null,
    Object? choices = null,
    Object? answerIndex = null,
    Object? code = freezed,
  }) {
    return _then(
      _$QuizQuestionEntityImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as DogamCategory,
        question: null == question
            ? _value.question
            : question // ignore: cast_nullable_to_non_nullable
                  as String,
        choices: null == choices
            ? _value._choices
            : choices // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        answerIndex: null == answerIndex
            ? _value.answerIndex
            : answerIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$QuizQuestionEntityImpl implements _QuizQuestionEntity {
  const _$QuizQuestionEntityImpl({
    required this.name,
    required this.category,
    required this.question,
    required final List<String> choices,
    required this.answerIndex,
    this.code,
  }) : _choices = choices;

  @override
  final String name;
  @override
  final DogamCategory category;
  @override
  final String question;
  final List<String> _choices;
  @override
  List<String> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  final int answerIndex;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
  @override
  final String? code;

  @override
  String toString() {
    return 'QuizQuestionEntity(name: $name, category: $category, question: $question, choices: $choices, answerIndex: $answerIndex, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizQuestionEntityImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.answerIndex, answerIndex) ||
                other.answerIndex == answerIndex) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    category,
    question,
    const DeepCollectionEquality().hash(_choices),
    answerIndex,
    code,
  );

  /// Create a copy of QuizQuestionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizQuestionEntityImplCopyWith<_$QuizQuestionEntityImpl> get copyWith =>
      __$$QuizQuestionEntityImplCopyWithImpl<_$QuizQuestionEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _QuizQuestionEntity implements QuizQuestionEntity {
  const factory _QuizQuestionEntity({
    required final String name,
    required final DogamCategory category,
    required final String question,
    required final List<String> choices,
    required final int answerIndex,
    final String? code,
  }) = _$QuizQuestionEntityImpl;

  @override
  String get name;
  @override
  DogamCategory get category;
  @override
  String get question;
  @override
  List<String> get choices;
  @override
  int get answerIndex;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
  @override
  String? get code;

  /// Create a copy of QuizQuestionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizQuestionEntityImplCopyWith<_$QuizQuestionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
