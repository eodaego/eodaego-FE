import 'package:freezed_annotation/freezed_annotation.dart';

import 'course_model.dart';

part 'course_favorite_list_model.freezed.dart';
part 'course_favorite_list_model.g.dart';

/// 즐겨찾기 항목 DTO
///
/// **주의**: 응답의 `favoritedAt`은 정렬을 서버가 하므로 앱이 쓰지 않는다. 선언하지 않는다.
@freezed
class CourseFavoriteItemModel with _$CourseFavoriteItemModel {
  const factory CourseFavoriteItemModel({CourseModel? course}) =
      _CourseFavoriteItemModel;

  factory CourseFavoriteItemModel.fromJson(Map<String, dynamic> json) =>
      _$CourseFavoriteItemModelFromJson(json);
}

/// 즐겨찾기 목록 DTO
///
/// `GET /api/1/favorites` 응답. 페이지네이션이 없어 `totalCount`는 항상 `items` 길이와 같다.
@freezed
class CourseFavoriteListModel with _$CourseFavoriteListModel {
  const factory CourseFavoriteListModel({
    @Default(0) int totalCount,
    @Default(<CourseFavoriteItemModel>[]) List<CourseFavoriteItemModel> items,
  }) = _CourseFavoriteListModel;

  factory CourseFavoriteListModel.fromJson(Map<String, dynamic> json) =>
      _$CourseFavoriteListModelFromJson(json);
}
