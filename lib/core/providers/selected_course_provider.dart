import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/course/domain/entities/course_entity.dart';

/// 지금 보는 코스 — 지도 마커·시트 헤더·홈 프리뷰가 공유한다.
///
/// 갱신은 코스 추천 페이지의 '이 코스로 갈래!' 1곳뿐. 인메모리 비영속이라
/// 앱을 다시 켜면 null로 돌아간다. 소비처는 null일 때의 안내를 그린다.
final selectedCourseProvider = StateProvider<CourseEntity?>((ref) => null);
