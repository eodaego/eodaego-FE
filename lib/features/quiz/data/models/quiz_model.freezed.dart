// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizModel _$QuizModelFromJson(Map<String, dynamic> json) {
  return _QuizModel.fromJson(json);
}

/// @nodoc
mixin _$QuizModel {
  String get quizId => throw _privateConstructorUsedError;
  List<QuizChoiceModel> get choices => throw _privateConstructorUsedError;

  /// Serializes this QuizModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizModelCopyWith<QuizModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizModelCopyWith<$Res> {
  factory $QuizModelCopyWith(QuizModel value, $Res Function(QuizModel) then) =
      _$QuizModelCopyWithImpl<$Res, QuizModel>;
  @useResult
  $Res call({String quizId, List<QuizChoiceModel> choices});
}

/// @nodoc
class _$QuizModelCopyWithImpl<$Res, $Val extends QuizModel>
    implements $QuizModelCopyWith<$Res> {
  _$QuizModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? quizId = null, Object? choices = null}) {
    return _then(
      _value.copyWith(
            quizId: null == quizId
                ? _value.quizId
                : quizId // ignore: cast_nullable_to_non_nullable
                      as String,
            choices: null == choices
                ? _value.choices
                : choices // ignore: cast_nullable_to_non_nullable
                      as List<QuizChoiceModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizModelImplCopyWith<$Res>
    implements $QuizModelCopyWith<$Res> {
  factory _$$QuizModelImplCopyWith(
    _$QuizModelImpl value,
    $Res Function(_$QuizModelImpl) then,
  ) = __$$QuizModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String quizId, List<QuizChoiceModel> choices});
}

/// @nodoc
class __$$QuizModelImplCopyWithImpl<$Res>
    extends _$QuizModelCopyWithImpl<$Res, _$QuizModelImpl>
    implements _$$QuizModelImplCopyWith<$Res> {
  __$$QuizModelImplCopyWithImpl(
    _$QuizModelImpl _value,
    $Res Function(_$QuizModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? quizId = null, Object? choices = null}) {
    return _then(
      _$QuizModelImpl(
        quizId: null == quizId
            ? _value.quizId
            : quizId // ignore: cast_nullable_to_non_nullable
                  as String,
        choices: null == choices
            ? _value._choices
            : choices // ignore: cast_nullable_to_non_nullable
                  as List<QuizChoiceModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizModelImpl implements _QuizModel {
  const _$QuizModelImpl({
    required this.quizId,
    final List<QuizChoiceModel> choices = const <QuizChoiceModel>[],
  }) : _choices = choices;

  factory _$QuizModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizModelImplFromJson(json);

  @override
  final String quizId;
  final List<QuizChoiceModel> _choices;
  @override
  @JsonKey()
  List<QuizChoiceModel> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  String toString() {
    return 'QuizModel(quizId: $quizId, choices: $choices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizModelImpl &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            const DeepCollectionEquality().equals(other._choices, _choices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    quizId,
    const DeepCollectionEquality().hash(_choices),
  );

  /// Create a copy of QuizModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizModelImplCopyWith<_$QuizModelImpl> get copyWith =>
      __$$QuizModelImplCopyWithImpl<_$QuizModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizModelImplToJson(this);
  }
}

abstract class _QuizModel implements QuizModel {
  const factory _QuizModel({
    required final String quizId,
    final List<QuizChoiceModel> choices,
  }) = _$QuizModelImpl;

  factory _QuizModel.fromJson(Map<String, dynamic> json) =
      _$QuizModelImpl.fromJson;

  @override
  String get quizId;
  @override
  List<QuizChoiceModel> get choices;

  /// Create a copy of QuizModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizModelImplCopyWith<_$QuizModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizChoiceModel _$QuizChoiceModelFromJson(Map<String, dynamic> json) {
  return _QuizChoiceModel.fromJson(json);
}

/// @nodoc
mixin _$QuizChoiceModel {
  String get catalogItemId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this QuizChoiceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizChoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizChoiceModelCopyWith<QuizChoiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizChoiceModelCopyWith<$Res> {
  factory $QuizChoiceModelCopyWith(
    QuizChoiceModel value,
    $Res Function(QuizChoiceModel) then,
  ) = _$QuizChoiceModelCopyWithImpl<$Res, QuizChoiceModel>;
  @useResult
  $Res call({String catalogItemId, String name});
}

/// @nodoc
class _$QuizChoiceModelCopyWithImpl<$Res, $Val extends QuizChoiceModel>
    implements $QuizChoiceModelCopyWith<$Res> {
  _$QuizChoiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizChoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? catalogItemId = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            catalogItemId: null == catalogItemId
                ? _value.catalogItemId
                : catalogItemId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizChoiceModelImplCopyWith<$Res>
    implements $QuizChoiceModelCopyWith<$Res> {
  factory _$$QuizChoiceModelImplCopyWith(
    _$QuizChoiceModelImpl value,
    $Res Function(_$QuizChoiceModelImpl) then,
  ) = __$$QuizChoiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String catalogItemId, String name});
}

/// @nodoc
class __$$QuizChoiceModelImplCopyWithImpl<$Res>
    extends _$QuizChoiceModelCopyWithImpl<$Res, _$QuizChoiceModelImpl>
    implements _$$QuizChoiceModelImplCopyWith<$Res> {
  __$$QuizChoiceModelImplCopyWithImpl(
    _$QuizChoiceModelImpl _value,
    $Res Function(_$QuizChoiceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizChoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? catalogItemId = null, Object? name = null}) {
    return _then(
      _$QuizChoiceModelImpl(
        catalogItemId: null == catalogItemId
            ? _value.catalogItemId
            : catalogItemId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizChoiceModelImpl implements _QuizChoiceModel {
  const _$QuizChoiceModelImpl({
    required this.catalogItemId,
    required this.name,
  });

  factory _$QuizChoiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizChoiceModelImplFromJson(json);

  @override
  final String catalogItemId;
  @override
  final String name;

  @override
  String toString() {
    return 'QuizChoiceModel(catalogItemId: $catalogItemId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizChoiceModelImpl &&
            (identical(other.catalogItemId, catalogItemId) ||
                other.catalogItemId == catalogItemId) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, catalogItemId, name);

  /// Create a copy of QuizChoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizChoiceModelImplCopyWith<_$QuizChoiceModelImpl> get copyWith =>
      __$$QuizChoiceModelImplCopyWithImpl<_$QuizChoiceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizChoiceModelImplToJson(this);
  }
}

abstract class _QuizChoiceModel implements QuizChoiceModel {
  const factory _QuizChoiceModel({
    required final String catalogItemId,
    required final String name,
  }) = _$QuizChoiceModelImpl;

  factory _QuizChoiceModel.fromJson(Map<String, dynamic> json) =
      _$QuizChoiceModelImpl.fromJson;

  @override
  String get catalogItemId;
  @override
  String get name;

  /// Create a copy of QuizChoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizChoiceModelImplCopyWith<_$QuizChoiceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizAnswerRequestModel _$QuizAnswerRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _QuizAnswerRequestModel.fromJson(json);
}

/// @nodoc
mixin _$QuizAnswerRequestModel {
  String get selectedCatalogItemId => throw _privateConstructorUsedError;

  /// Serializes this QuizAnswerRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizAnswerRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAnswerRequestModelCopyWith<QuizAnswerRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAnswerRequestModelCopyWith<$Res> {
  factory $QuizAnswerRequestModelCopyWith(
    QuizAnswerRequestModel value,
    $Res Function(QuizAnswerRequestModel) then,
  ) = _$QuizAnswerRequestModelCopyWithImpl<$Res, QuizAnswerRequestModel>;
  @useResult
  $Res call({String selectedCatalogItemId});
}

/// @nodoc
class _$QuizAnswerRequestModelCopyWithImpl<
  $Res,
  $Val extends QuizAnswerRequestModel
>
    implements $QuizAnswerRequestModelCopyWith<$Res> {
  _$QuizAnswerRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAnswerRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? selectedCatalogItemId = null}) {
    return _then(
      _value.copyWith(
            selectedCatalogItemId: null == selectedCatalogItemId
                ? _value.selectedCatalogItemId
                : selectedCatalogItemId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizAnswerRequestModelImplCopyWith<$Res>
    implements $QuizAnswerRequestModelCopyWith<$Res> {
  factory _$$QuizAnswerRequestModelImplCopyWith(
    _$QuizAnswerRequestModelImpl value,
    $Res Function(_$QuizAnswerRequestModelImpl) then,
  ) = __$$QuizAnswerRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String selectedCatalogItemId});
}

/// @nodoc
class __$$QuizAnswerRequestModelImplCopyWithImpl<$Res>
    extends
        _$QuizAnswerRequestModelCopyWithImpl<$Res, _$QuizAnswerRequestModelImpl>
    implements _$$QuizAnswerRequestModelImplCopyWith<$Res> {
  __$$QuizAnswerRequestModelImplCopyWithImpl(
    _$QuizAnswerRequestModelImpl _value,
    $Res Function(_$QuizAnswerRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizAnswerRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? selectedCatalogItemId = null}) {
    return _then(
      _$QuizAnswerRequestModelImpl(
        selectedCatalogItemId: null == selectedCatalogItemId
            ? _value.selectedCatalogItemId
            : selectedCatalogItemId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizAnswerRequestModelImpl implements _QuizAnswerRequestModel {
  const _$QuizAnswerRequestModelImpl({required this.selectedCatalogItemId});

  factory _$QuizAnswerRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizAnswerRequestModelImplFromJson(json);

  @override
  final String selectedCatalogItemId;

  @override
  String toString() {
    return 'QuizAnswerRequestModel(selectedCatalogItemId: $selectedCatalogItemId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAnswerRequestModelImpl &&
            (identical(other.selectedCatalogItemId, selectedCatalogItemId) ||
                other.selectedCatalogItemId == selectedCatalogItemId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, selectedCatalogItemId);

  /// Create a copy of QuizAnswerRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAnswerRequestModelImplCopyWith<_$QuizAnswerRequestModelImpl>
  get copyWith =>
      __$$QuizAnswerRequestModelImplCopyWithImpl<_$QuizAnswerRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizAnswerRequestModelImplToJson(this);
  }
}

abstract class _QuizAnswerRequestModel implements QuizAnswerRequestModel {
  const factory _QuizAnswerRequestModel({
    required final String selectedCatalogItemId,
  }) = _$QuizAnswerRequestModelImpl;

  factory _QuizAnswerRequestModel.fromJson(Map<String, dynamic> json) =
      _$QuizAnswerRequestModelImpl.fromJson;

  @override
  String get selectedCatalogItemId;

  /// Create a copy of QuizAnswerRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAnswerRequestModelImplCopyWith<_$QuizAnswerRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

QuizAnswerModel _$QuizAnswerModelFromJson(Map<String, dynamic> json) {
  return _QuizAnswerModel.fromJson(json);
}

/// @nodoc
mixin _$QuizAnswerModel {
  bool get correct => throw _privateConstructorUsedError;
  String? get collectedCatalogItemId => throw _privateConstructorUsedError;

  /// Serializes this QuizAnswerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAnswerModelCopyWith<QuizAnswerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAnswerModelCopyWith<$Res> {
  factory $QuizAnswerModelCopyWith(
    QuizAnswerModel value,
    $Res Function(QuizAnswerModel) then,
  ) = _$QuizAnswerModelCopyWithImpl<$Res, QuizAnswerModel>;
  @useResult
  $Res call({bool correct, String? collectedCatalogItemId});
}

/// @nodoc
class _$QuizAnswerModelCopyWithImpl<$Res, $Val extends QuizAnswerModel>
    implements $QuizAnswerModelCopyWith<$Res> {
  _$QuizAnswerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? correct = null,
    Object? collectedCatalogItemId = freezed,
  }) {
    return _then(
      _value.copyWith(
            correct: null == correct
                ? _value.correct
                : correct // ignore: cast_nullable_to_non_nullable
                      as bool,
            collectedCatalogItemId: freezed == collectedCatalogItemId
                ? _value.collectedCatalogItemId
                : collectedCatalogItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizAnswerModelImplCopyWith<$Res>
    implements $QuizAnswerModelCopyWith<$Res> {
  factory _$$QuizAnswerModelImplCopyWith(
    _$QuizAnswerModelImpl value,
    $Res Function(_$QuizAnswerModelImpl) then,
  ) = __$$QuizAnswerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool correct, String? collectedCatalogItemId});
}

/// @nodoc
class __$$QuizAnswerModelImplCopyWithImpl<$Res>
    extends _$QuizAnswerModelCopyWithImpl<$Res, _$QuizAnswerModelImpl>
    implements _$$QuizAnswerModelImplCopyWith<$Res> {
  __$$QuizAnswerModelImplCopyWithImpl(
    _$QuizAnswerModelImpl _value,
    $Res Function(_$QuizAnswerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? correct = null,
    Object? collectedCatalogItemId = freezed,
  }) {
    return _then(
      _$QuizAnswerModelImpl(
        correct: null == correct
            ? _value.correct
            : correct // ignore: cast_nullable_to_non_nullable
                  as bool,
        collectedCatalogItemId: freezed == collectedCatalogItemId
            ? _value.collectedCatalogItemId
            : collectedCatalogItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizAnswerModelImpl implements _QuizAnswerModel {
  const _$QuizAnswerModelImpl({
    required this.correct,
    this.collectedCatalogItemId,
  });

  factory _$QuizAnswerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizAnswerModelImplFromJson(json);

  @override
  final bool correct;
  @override
  final String? collectedCatalogItemId;

  @override
  String toString() {
    return 'QuizAnswerModel(correct: $correct, collectedCatalogItemId: $collectedCatalogItemId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAnswerModelImpl &&
            (identical(other.correct, correct) || other.correct == correct) &&
            (identical(other.collectedCatalogItemId, collectedCatalogItemId) ||
                other.collectedCatalogItemId == collectedCatalogItemId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, correct, collectedCatalogItemId);

  /// Create a copy of QuizAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAnswerModelImplCopyWith<_$QuizAnswerModelImpl> get copyWith =>
      __$$QuizAnswerModelImplCopyWithImpl<_$QuizAnswerModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizAnswerModelImplToJson(this);
  }
}

abstract class _QuizAnswerModel implements QuizAnswerModel {
  const factory _QuizAnswerModel({
    required final bool correct,
    final String? collectedCatalogItemId,
  }) = _$QuizAnswerModelImpl;

  factory _QuizAnswerModel.fromJson(Map<String, dynamic> json) =
      _$QuizAnswerModelImpl.fromJson;

  @override
  bool get correct;
  @override
  String? get collectedCatalogItemId;

  /// Create a copy of QuizAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAnswerModelImplCopyWith<_$QuizAnswerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
