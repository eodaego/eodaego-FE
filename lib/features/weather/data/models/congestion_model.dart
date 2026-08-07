import 'package:freezed_annotation/freezed_annotation.dart';

part 'congestion_model.freezed.dart';
part 'congestion_model.g.dart';

/// 현재 혼잡도 DTO
///
/// `GET /api/1/congestion/current` 응답.
///
/// **주의**: `level`은 서울시가 새 등급을 추가하면 null로 내려온다.
/// 이때도 `label`에는 원본 문자열이 담기므로 라벨만 표시하면 된다.
@freezed
class CongestionModel with _$CongestionModel {
  const factory CongestionModel({
    /// 혼잡도 등급 원문 (`RELAXED`/`NORMAL`/`SLIGHTLY_CROWDED`/`CROWDED`)
    String? level,

    /// 등급의 한글 표기 — 원본 문자열이라 항상 값이 있다
    @Default('') String label,

    /// 수집 시각 (KST, 오프셋 없는 ISO)
    String? collectedAt,
  }) = _CongestionModel;

  factory CongestionModel.fromJson(Map<String, dynamic> json) =>
      _$CongestionModelFromJson(json);
}
