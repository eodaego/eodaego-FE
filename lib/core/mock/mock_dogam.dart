import '../constants/dogam_category.dart';

/// 목 도감 항목. API 연동 시 core/mock 폴더째 삭제 예정.
class MockDogamItem {
  const MockDogamItem({
    required this.id,
    required this.name,
    required this.category,
    required this.collected,
    this.collectedAt,
    this.oneLiner = '',
    this.kidsDescription = '',
  });

  final String id;
  final String name;
  final DogamCategory category;
  final bool collected;
  final String? collectedAt;
  final String oneLiner;
  final String kidsDescription;
}

/// 퀴즈·축하 화면 고정 항목 — 스캔 인식 API가 없어 목업으로 남긴다.
/// 인식 기능이 붙으면 이 파일째 삭제한다.
const MockDogamItem mockQuizItem = MockDogamItem(
  id: 'a1',
  name: '수달',
  category: DogamCategory.animal,
  collected: true,
  collectedAt: '2026.07.05',
  oneLiner: '물가에서 헤엄치는 재주꾼',
  kidsDescription:
      '수달은 물속에서 눈을 뜨고 헤엄칠 수 있어요. '
      '미끄러운 물고기도 앞발로 꽉 잡아서 냠냠 먹는답니다.',
);
