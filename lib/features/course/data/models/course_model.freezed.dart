// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoursePlaceModel _$CoursePlaceModelFromJson(Map<String, dynamic> json) {
  return _CoursePlaceModel.fromJson(json);
}

/// @nodoc
mixin _$CoursePlaceModel {
  /// 방문 순서(1부터)
  int get visitOrder => throw _privateConstructorUsedError;

  /// 장소 이름 — 도감 미동기화 시설이면 AI가 준 이름이 들어온다
  String get name => throw _privateConstructorUsedError;

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  String? get category => throw _privateConstructorUsedError;

  /// Serializes this CoursePlaceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoursePlaceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoursePlaceModelCopyWith<CoursePlaceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoursePlaceModelCopyWith<$Res> {
  factory $CoursePlaceModelCopyWith(
    CoursePlaceModel value,
    $Res Function(CoursePlaceModel) then,
  ) = _$CoursePlaceModelCopyWithImpl<$Res, CoursePlaceModel>;
  @useResult
  $Res call({int visitOrder, String name, String? category});
}

/// @nodoc
class _$CoursePlaceModelCopyWithImpl<$Res, $Val extends CoursePlaceModel>
    implements $CoursePlaceModelCopyWith<$Res> {
  _$CoursePlaceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoursePlaceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? visitOrder = null,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(
      _value.copyWith(
            visitOrder: null == visitOrder
                ? _value.visitOrder
                : visitOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoursePlaceModelImplCopyWith<$Res>
    implements $CoursePlaceModelCopyWith<$Res> {
  factory _$$CoursePlaceModelImplCopyWith(
    _$CoursePlaceModelImpl value,
    $Res Function(_$CoursePlaceModelImpl) then,
  ) = __$$CoursePlaceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int visitOrder, String name, String? category});
}

/// @nodoc
class __$$CoursePlaceModelImplCopyWithImpl<$Res>
    extends _$CoursePlaceModelCopyWithImpl<$Res, _$CoursePlaceModelImpl>
    implements _$$CoursePlaceModelImplCopyWith<$Res> {
  __$$CoursePlaceModelImplCopyWithImpl(
    _$CoursePlaceModelImpl _value,
    $Res Function(_$CoursePlaceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoursePlaceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? visitOrder = null,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(
      _$CoursePlaceModelImpl(
        visitOrder: null == visitOrder
            ? _value.visitOrder
            : visitOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoursePlaceModelImpl implements _CoursePlaceModel {
  const _$CoursePlaceModelImpl({
    this.visitOrder = 0,
    this.name = '',
    this.category,
  });

  factory _$CoursePlaceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoursePlaceModelImplFromJson(json);

  /// 방문 순서(1부터)
  @override
  @JsonKey()
  final int visitOrder;

  /// 장소 이름 — 도감 미동기화 시설이면 AI가 준 이름이 들어온다
  @override
  @JsonKey()
  final String name;

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  @override
  final String? category;

  @override
  String toString() {
    return 'CoursePlaceModel(visitOrder: $visitOrder, name: $name, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoursePlaceModelImpl &&
            (identical(other.visitOrder, visitOrder) ||
                other.visitOrder == visitOrder) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, visitOrder, name, category);

  /// Create a copy of CoursePlaceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoursePlaceModelImplCopyWith<_$CoursePlaceModelImpl> get copyWith =>
      __$$CoursePlaceModelImplCopyWithImpl<_$CoursePlaceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoursePlaceModelImplToJson(this);
  }
}

abstract class _CoursePlaceModel implements CoursePlaceModel {
  const factory _CoursePlaceModel({
    final int visitOrder,
    final String name,
    final String? category,
  }) = _$CoursePlaceModelImpl;

  factory _CoursePlaceModel.fromJson(Map<String, dynamic> json) =
      _$CoursePlaceModelImpl.fromJson;

  /// 방문 순서(1부터)
  @override
  int get visitOrder;

  /// 장소 이름 — 도감 미동기화 시설이면 AI가 준 이름이 들어온다
  @override
  String get name;

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  @override
  String? get category;

  /// Create a copy of CoursePlaceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoursePlaceModelImplCopyWith<_$CoursePlaceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) {
  return _CourseModel.fromJson(json);
}

/// @nodoc
mixin _$CourseModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;

  /// AI가 만든 특징 태그 1~3개
  List<String> get tagLabels => throw _privateConstructorUsedError;

  /// AI가 계산한 완주 예상 소요시간(분)
  int get estimatedDurationMinutes => throw _privateConstructorUsedError;

  /// 입구 원문 (`MAIN_GATE` 등)
  String? get entrance => throw _privateConstructorUsedError;

  /// 출구 원문
  String? get exit => throw _privateConstructorUsedError;

  /// 즐겨찾기 여부 — 추천 직후에는 항상 false
  bool get favorite => throw _privateConstructorUsedError;

  /// 방문 순서대로 정렬된 장소. 입구·출구는 포함되지 않는다
  List<CoursePlaceModel> get places => throw _privateConstructorUsedError;

  /// Serializes this CourseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseModelCopyWith<CourseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseModelCopyWith<$Res> {
  factory $CourseModelCopyWith(
    CourseModel value,
    $Res Function(CourseModel) then,
  ) = _$CourseModelCopyWithImpl<$Res, CourseModel>;
  @useResult
  $Res call({
    String id,
    String title,
    List<String> tagLabels,
    int estimatedDurationMinutes,
    String? entrance,
    String? exit,
    bool favorite,
    List<CoursePlaceModel> places,
  });
}

/// @nodoc
class _$CourseModelCopyWithImpl<$Res, $Val extends CourseModel>
    implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? tagLabels = null,
    Object? estimatedDurationMinutes = null,
    Object? entrance = freezed,
    Object? exit = freezed,
    Object? favorite = null,
    Object? places = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            tagLabels: null == tagLabels
                ? _value.tagLabels
                : tagLabels // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            estimatedDurationMinutes: null == estimatedDurationMinutes
                ? _value.estimatedDurationMinutes
                : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            entrance: freezed == entrance
                ? _value.entrance
                : entrance // ignore: cast_nullable_to_non_nullable
                      as String?,
            exit: freezed == exit
                ? _value.exit
                : exit // ignore: cast_nullable_to_non_nullable
                      as String?,
            favorite: null == favorite
                ? _value.favorite
                : favorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            places: null == places
                ? _value.places
                : places // ignore: cast_nullable_to_non_nullable
                      as List<CoursePlaceModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseModelImplCopyWith<$Res>
    implements $CourseModelCopyWith<$Res> {
  factory _$$CourseModelImplCopyWith(
    _$CourseModelImpl value,
    $Res Function(_$CourseModelImpl) then,
  ) = __$$CourseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    List<String> tagLabels,
    int estimatedDurationMinutes,
    String? entrance,
    String? exit,
    bool favorite,
    List<CoursePlaceModel> places,
  });
}

/// @nodoc
class __$$CourseModelImplCopyWithImpl<$Res>
    extends _$CourseModelCopyWithImpl<$Res, _$CourseModelImpl>
    implements _$$CourseModelImplCopyWith<$Res> {
  __$$CourseModelImplCopyWithImpl(
    _$CourseModelImpl _value,
    $Res Function(_$CourseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? tagLabels = null,
    Object? estimatedDurationMinutes = null,
    Object? entrance = freezed,
    Object? exit = freezed,
    Object? favorite = null,
    Object? places = null,
  }) {
    return _then(
      _$CourseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        tagLabels: null == tagLabels
            ? _value._tagLabels
            : tagLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        estimatedDurationMinutes: null == estimatedDurationMinutes
            ? _value.estimatedDurationMinutes
            : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        entrance: freezed == entrance
            ? _value.entrance
            : entrance // ignore: cast_nullable_to_non_nullable
                  as String?,
        exit: freezed == exit
            ? _value.exit
            : exit // ignore: cast_nullable_to_non_nullable
                  as String?,
        favorite: null == favorite
            ? _value.favorite
            : favorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        places: null == places
            ? _value._places
            : places // ignore: cast_nullable_to_non_nullable
                  as List<CoursePlaceModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseModelImpl implements _CourseModel {
  const _$CourseModelImpl({
    this.id = '',
    this.title = '',
    final List<String> tagLabels = const <String>[],
    this.estimatedDurationMinutes = 0,
    this.entrance,
    this.exit,
    this.favorite = false,
    final List<CoursePlaceModel> places = const <CoursePlaceModel>[],
  }) : _tagLabels = tagLabels,
       _places = places;

  factory _$CourseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String title;

  /// AI가 만든 특징 태그 1~3개
  final List<String> _tagLabels;

  /// AI가 만든 특징 태그 1~3개
  @override
  @JsonKey()
  List<String> get tagLabels {
    if (_tagLabels is EqualUnmodifiableListView) return _tagLabels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagLabels);
  }

  /// AI가 계산한 완주 예상 소요시간(분)
  @override
  @JsonKey()
  final int estimatedDurationMinutes;

  /// 입구 원문 (`MAIN_GATE` 등)
  @override
  final String? entrance;

  /// 출구 원문
  @override
  final String? exit;

  /// 즐겨찾기 여부 — 추천 직후에는 항상 false
  @override
  @JsonKey()
  final bool favorite;

  /// 방문 순서대로 정렬된 장소. 입구·출구는 포함되지 않는다
  final List<CoursePlaceModel> _places;

  /// 방문 순서대로 정렬된 장소. 입구·출구는 포함되지 않는다
  @override
  @JsonKey()
  List<CoursePlaceModel> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  @override
  String toString() {
    return 'CourseModel(id: $id, title: $title, tagLabels: $tagLabels, estimatedDurationMinutes: $estimatedDurationMinutes, entrance: $entrance, exit: $exit, favorite: $favorite, places: $places)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(
              other._tagLabels,
              _tagLabels,
            ) &&
            (identical(
                  other.estimatedDurationMinutes,
                  estimatedDurationMinutes,
                ) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes) &&
            (identical(other.entrance, entrance) ||
                other.entrance == entrance) &&
            (identical(other.exit, exit) || other.exit == exit) &&
            (identical(other.favorite, favorite) ||
                other.favorite == favorite) &&
            const DeepCollectionEquality().equals(other._places, _places));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    const DeepCollectionEquality().hash(_tagLabels),
    estimatedDurationMinutes,
    entrance,
    exit,
    favorite,
    const DeepCollectionEquality().hash(_places),
  );

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseModelImplCopyWith<_$CourseModelImpl> get copyWith =>
      __$$CourseModelImplCopyWithImpl<_$CourseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseModelImplToJson(this);
  }
}

abstract class _CourseModel implements CourseModel {
  const factory _CourseModel({
    final String id,
    final String title,
    final List<String> tagLabels,
    final int estimatedDurationMinutes,
    final String? entrance,
    final String? exit,
    final bool favorite,
    final List<CoursePlaceModel> places,
  }) = _$CourseModelImpl;

  factory _CourseModel.fromJson(Map<String, dynamic> json) =
      _$CourseModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;

  /// AI가 만든 특징 태그 1~3개
  @override
  List<String> get tagLabels;

  /// AI가 계산한 완주 예상 소요시간(분)
  @override
  int get estimatedDurationMinutes;

  /// 입구 원문 (`MAIN_GATE` 등)
  @override
  String? get entrance;

  /// 출구 원문
  @override
  String? get exit;

  /// 즐겨찾기 여부 — 추천 직후에는 항상 false
  @override
  bool get favorite;

  /// 방문 순서대로 정렬된 장소. 입구·출구는 포함되지 않는다
  @override
  List<CoursePlaceModel> get places;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseModelImplCopyWith<_$CourseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
