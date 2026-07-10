import 'mock_dogam.dart';

/// 코스에 포함된 장소. API 연동 시 core/mock 폴더째 삭제 예정.
class MockPlace {
  const MockPlace(this.name, this.category);

  final String name;
  final DogamCategory category;
}

/// 목 추천 코스 — 코스 결과·즐겨찾기·지도가 공유.
class MockCourse {
  const MockCourse({
    required this.id,
    required this.title,
    required this.category,
    required this.tagLabel,
    required this.durationLabel,
    required this.entranceLabel,
    required this.places,
  });

  final String id;
  final String title;
  final DogamCategory category;
  final String tagLabel;
  final String durationLabel;
  final String entranceLabel;
  final List<MockPlace> places;
}

const List<MockCourse> mockCourses = [
  MockCourse(
    id: 'c1',
    title: '동물 만나러 가는 길',
    category: DogamCategory.animal,
    tagLabel: '동물 듬뿍',
    durationLabel: '약 2시간',
    entranceLabel: '정문',
    places: [
      MockPlace('맹수마을', DogamCategory.animal),
      MockPlace('바다동물관', DogamCategory.animal),
      MockPlace('음악분수', DogamCategory.place),
      MockPlace('꼬마동물마을', DogamCategory.animal),
    ],
  ),
  MockCourse(
    id: 'c2',
    title: '초록초록 자연 산책',
    category: DogamCategory.plant,
    tagLabel: '자연 산책',
    durationLabel: '약 1시간 30분',
    entranceLabel: '후문',
    places: [
      MockPlace('식물원', DogamCategory.plant),
      MockPlace('장미원', DogamCategory.plant),
      MockPlace('숲속의무대', DogamCategory.place),
    ],
  ),
  MockCourse(
    id: 'c3',
    title: '구석구석 명소 탐험',
    category: DogamCategory.place,
    tagLabel: '명소 탐험',
    durationLabel: '약 1시간',
    entranceLabel: '구의문',
    places: [
      MockPlace('전래동화마을', DogamCategory.place),
      MockPlace('음악분수', DogamCategory.place),
      MockPlace('팔각당', DogamCategory.place),
    ],
  ),
];
