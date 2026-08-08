import 'package:eodaego/features/course/presentation/pages/course_recommend_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('courseStepFooter', () {
    test('입구 스텝 미선택 → 다음 · 비활성', () {
      final f = courseStepFooter(0, selected: false);
      expect(f.label, '다음');
      expect(f.enabled, false);
    });

    test('입구 스텝 선택됨 → 다음 · 활성', () {
      final f = courseStepFooter(0, selected: true);
      expect(f.label, '다음');
      expect(f.enabled, true);
    });

    test('출구 스텝 미선택 → 다음 · 비활성', () {
      final f = courseStepFooter(1, selected: false);
      expect(f.label, '다음');
      expect(f.enabled, false);
    });

    test('출구 스텝 선택됨 → 다음 · 활성', () {
      final f = courseStepFooter(1, selected: true);
      expect(f.label, '다음');
      expect(f.enabled, true);
    });

    test('체류시간 스텝 미선택 → 건너뛰기 · 활성', () {
      final f = courseStepFooter(2, selected: false);
      expect(f.label, '건너뛰기');
      expect(f.enabled, true);
    });

    test('체류시간 스텝 선택됨 → 다음 · 활성', () {
      final f = courseStepFooter(2, selected: true);
      expect(f.label, '다음');
      expect(f.enabled, true);
    });

    test('관심분야 스텝 미선택 → 건너뛰기 · 활성', () {
      final f = courseStepFooter(3, selected: false);
      expect(f.label, '건너뛰기');
      expect(f.enabled, true);
    });

    test('관심분야 스텝 선택됨 → 다음 · 활성', () {
      final f = courseStepFooter(3, selected: true);
      expect(f.label, '다음');
      expect(f.enabled, true);
    });

    test('동행 스텝 미선택 → 건너뛰기 · 활성', () {
      final f = courseStepFooter(4, selected: false);
      expect(f.label, '건너뛰기');
      expect(f.enabled, true);
    });

    test('동행 스텝 선택됨 → 코스 추천받기 · 활성', () {
      final f = courseStepFooter(4, selected: true);
      expect(f.label, '코스 추천받기');
      expect(f.enabled, true);
    });
  });
}
