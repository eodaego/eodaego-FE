import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_course.dart';

/// 지금 보는 코스 — 지도 마커·시트 헤더·홈 프리뷰가 공유한다.
/// 갱신은 코스 추천 페이지의 '이 코스로 갈래!' 1곳뿐. 인메모리 비영속(목 단계).
final selectedCourseProvider =
    StateProvider<MockCourse>((ref) => mockCourses.first);
