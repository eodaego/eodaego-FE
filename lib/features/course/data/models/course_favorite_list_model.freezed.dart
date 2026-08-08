// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_favorite_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CourseFavoriteItemModel _$CourseFavoriteItemModelFromJson(
  Map<String, dynamic> json,
) {
  return _CourseFavoriteItemModel.fromJson(json);
}

/// @nodoc
mixin _$CourseFavoriteItemModel {
  CourseModel? get course => throw _privateConstructorUsedError;

  /// Serializes this CourseFavoriteItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseFavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseFavoriteItemModelCopyWith<CourseFavoriteItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseFavoriteItemModelCopyWith<$Res> {
  factory $CourseFavoriteItemModelCopyWith(
    CourseFavoriteItemModel value,
    $Res Function(CourseFavoriteItemModel) then,
  ) = _$CourseFavoriteItemModelCopyWithImpl<$Res, CourseFavoriteItemModel>;
  @useResult
  $Res call({CourseModel? course});

  $CourseModelCopyWith<$Res>? get course;
}

/// @nodoc
class _$CourseFavoriteItemModelCopyWithImpl<
  $Res,
  $Val extends CourseFavoriteItemModel
>
    implements $CourseFavoriteItemModelCopyWith<$Res> {
  _$CourseFavoriteItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseFavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? course = freezed}) {
    return _then(
      _value.copyWith(
            course: freezed == course
                ? _value.course
                : course // ignore: cast_nullable_to_non_nullable
                      as CourseModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of CourseFavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseModelCopyWith<$Res>? get course {
    if (_value.course == null) {
      return null;
    }

    return $CourseModelCopyWith<$Res>(_value.course!, (value) {
      return _then(_value.copyWith(course: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CourseFavoriteItemModelImplCopyWith<$Res>
    implements $CourseFavoriteItemModelCopyWith<$Res> {
  factory _$$CourseFavoriteItemModelImplCopyWith(
    _$CourseFavoriteItemModelImpl value,
    $Res Function(_$CourseFavoriteItemModelImpl) then,
  ) = __$$CourseFavoriteItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CourseModel? course});

  @override
  $CourseModelCopyWith<$Res>? get course;
}

/// @nodoc
class __$$CourseFavoriteItemModelImplCopyWithImpl<$Res>
    extends
        _$CourseFavoriteItemModelCopyWithImpl<
          $Res,
          _$CourseFavoriteItemModelImpl
        >
    implements _$$CourseFavoriteItemModelImplCopyWith<$Res> {
  __$$CourseFavoriteItemModelImplCopyWithImpl(
    _$CourseFavoriteItemModelImpl _value,
    $Res Function(_$CourseFavoriteItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseFavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? course = freezed}) {
    return _then(
      _$CourseFavoriteItemModelImpl(
        course: freezed == course
            ? _value.course
            : course // ignore: cast_nullable_to_non_nullable
                  as CourseModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseFavoriteItemModelImpl implements _CourseFavoriteItemModel {
  const _$CourseFavoriteItemModelImpl({this.course});

  factory _$CourseFavoriteItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseFavoriteItemModelImplFromJson(json);

  @override
  final CourseModel? course;

  @override
  String toString() {
    return 'CourseFavoriteItemModel(course: $course)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseFavoriteItemModelImpl &&
            (identical(other.course, course) || other.course == course));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, course);

  /// Create a copy of CourseFavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseFavoriteItemModelImplCopyWith<_$CourseFavoriteItemModelImpl>
  get copyWith =>
      __$$CourseFavoriteItemModelImplCopyWithImpl<
        _$CourseFavoriteItemModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseFavoriteItemModelImplToJson(this);
  }
}

abstract class _CourseFavoriteItemModel implements CourseFavoriteItemModel {
  const factory _CourseFavoriteItemModel({final CourseModel? course}) =
      _$CourseFavoriteItemModelImpl;

  factory _CourseFavoriteItemModel.fromJson(Map<String, dynamic> json) =
      _$CourseFavoriteItemModelImpl.fromJson;

  @override
  CourseModel? get course;

  /// Create a copy of CourseFavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseFavoriteItemModelImplCopyWith<_$CourseFavoriteItemModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CourseFavoriteListModel _$CourseFavoriteListModelFromJson(
  Map<String, dynamic> json,
) {
  return _CourseFavoriteListModel.fromJson(json);
}

/// @nodoc
mixin _$CourseFavoriteListModel {
  int get totalCount => throw _privateConstructorUsedError;
  List<CourseFavoriteItemModel> get items => throw _privateConstructorUsedError;

  /// Serializes this CourseFavoriteListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseFavoriteListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseFavoriteListModelCopyWith<CourseFavoriteListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseFavoriteListModelCopyWith<$Res> {
  factory $CourseFavoriteListModelCopyWith(
    CourseFavoriteListModel value,
    $Res Function(CourseFavoriteListModel) then,
  ) = _$CourseFavoriteListModelCopyWithImpl<$Res, CourseFavoriteListModel>;
  @useResult
  $Res call({int totalCount, List<CourseFavoriteItemModel> items});
}

/// @nodoc
class _$CourseFavoriteListModelCopyWithImpl<
  $Res,
  $Val extends CourseFavoriteListModel
>
    implements $CourseFavoriteListModelCopyWith<$Res> {
  _$CourseFavoriteListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseFavoriteListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalCount = null, Object? items = null}) {
    return _then(
      _value.copyWith(
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CourseFavoriteItemModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseFavoriteListModelImplCopyWith<$Res>
    implements $CourseFavoriteListModelCopyWith<$Res> {
  factory _$$CourseFavoriteListModelImplCopyWith(
    _$CourseFavoriteListModelImpl value,
    $Res Function(_$CourseFavoriteListModelImpl) then,
  ) = __$$CourseFavoriteListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalCount, List<CourseFavoriteItemModel> items});
}

/// @nodoc
class __$$CourseFavoriteListModelImplCopyWithImpl<$Res>
    extends
        _$CourseFavoriteListModelCopyWithImpl<
          $Res,
          _$CourseFavoriteListModelImpl
        >
    implements _$$CourseFavoriteListModelImplCopyWith<$Res> {
  __$$CourseFavoriteListModelImplCopyWithImpl(
    _$CourseFavoriteListModelImpl _value,
    $Res Function(_$CourseFavoriteListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseFavoriteListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalCount = null, Object? items = null}) {
    return _then(
      _$CourseFavoriteListModelImpl(
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CourseFavoriteItemModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseFavoriteListModelImpl implements _CourseFavoriteListModel {
  const _$CourseFavoriteListModelImpl({
    this.totalCount = 0,
    final List<CourseFavoriteItemModel> items =
        const <CourseFavoriteItemModel>[],
  }) : _items = items;

  factory _$CourseFavoriteListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseFavoriteListModelImplFromJson(json);

  @override
  @JsonKey()
  final int totalCount;
  final List<CourseFavoriteItemModel> _items;
  @override
  @JsonKey()
  List<CourseFavoriteItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CourseFavoriteListModel(totalCount: $totalCount, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseFavoriteListModelImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCount,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of CourseFavoriteListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseFavoriteListModelImplCopyWith<_$CourseFavoriteListModelImpl>
  get copyWith =>
      __$$CourseFavoriteListModelImplCopyWithImpl<
        _$CourseFavoriteListModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseFavoriteListModelImplToJson(this);
  }
}

abstract class _CourseFavoriteListModel implements CourseFavoriteListModel {
  const factory _CourseFavoriteListModel({
    final int totalCount,
    final List<CourseFavoriteItemModel> items,
  }) = _$CourseFavoriteListModelImpl;

  factory _CourseFavoriteListModel.fromJson(Map<String, dynamic> json) =
      _$CourseFavoriteListModelImpl.fromJson;

  @override
  int get totalCount;
  @override
  List<CourseFavoriteItemModel> get items;

  /// Create a copy of CourseFavoriteListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseFavoriteListModelImplCopyWith<_$CourseFavoriteListModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
