import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// 도감 카테고리 — 카테고리 컬러 페어링 규칙(UI_Design_System.md)의 단일 소스.
enum DogamCategory {
  animal('동물', AppColors.animal, AppColors.animalTint, AppColors.animalDark,
      Icons.pets),
  plant('식물', AppColors.plant, AppColors.plantTint, AppColors.plantDark,
      Icons.local_florist),
  place('장소', AppColors.place, AppColors.placeTint, AppColors.placeDark,
      Icons.place);

  const DogamCategory(this.label, this.color, this.tint, this.dark, this.icon);

  final String label;
  final Color color;
  final Color tint;
  final Color dark;
  final IconData icon;
}

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

/// 수기 샘플 12종 (수집 5 + 미수집 7)
const List<MockDogamItem> _curated = [
  MockDogamItem(
    id: 'a1',
    name: '수달',
    category: DogamCategory.animal,
    collected: true,
    collectedAt: '2026.07.05',
    oneLiner: '물가에서 헤엄치는 재주꾼',
    kidsDescription: '수달은 물속에서 눈을 뜨고 헤엄칠 수 있어요. '
        '미끄러운 물고기도 앞발로 꽉 잡아서 냠냠 먹는답니다.',
  ),
  MockDogamItem(
    id: 'a2',
    name: '두루미',
    category: DogamCategory.animal,
    collected: false,
    oneLiner: '한 다리로 서서 쉬는 새',
    kidsDescription: '두루미는 다리가 아주 길어요. 한쪽 다리로만 서서 잠을 자기도 한답니다.',
  ),
  MockDogamItem(
    id: 'a3',
    name: '사막여우',
    category: DogamCategory.animal,
    collected: true,
    collectedAt: '2026.07.03',
    oneLiner: '큰 귀로 더위를 식히는 여우',
    kidsDescription: '사막여우의 커다란 귀는 몸의 열을 밖으로 내보내는 부채 역할을 해요.',
  ),
  MockDogamItem(
    id: 'a4',
    name: '반달가슴곰',
    category: DogamCategory.animal,
    collected: false,
    oneLiner: '가슴에 반달 무늬가 있는 곰',
    kidsDescription: '가슴에 하얀 반달 모양 무늬가 있어서 반달가슴곰이라고 불러요.',
  ),
  MockDogamItem(
    id: 'p1',
    name: '단풍나무',
    category: DogamCategory.plant,
    collected: true,
    collectedAt: '2026.07.02',
    oneLiner: '가을에 빨갛게 물드는 나무',
    kidsDescription: '가을이 되면 잎이 빨갛게 물들어요. 잎 모양이 아기 손바닥을 닮았답니다.',
  ),
  MockDogamItem(
    id: 'p2',
    name: '소나무',
    category: DogamCategory.plant,
    collected: false,
    oneLiner: '사계절 내내 초록인 나무',
    kidsDescription: '소나무는 겨울에도 잎이 지지 않아요. 뾰족한 잎이 바늘처럼 생겼어요.',
  ),
  MockDogamItem(
    id: 'p3',
    name: '은행나무',
    category: DogamCategory.plant,
    collected: false,
    oneLiner: '부채꼴 잎을 가진 나무',
    kidsDescription: '은행나무 잎은 작은 부채처럼 생겼어요. 가을엔 노랗게 물든답니다.',
  ),
  MockDogamItem(
    id: 'p4',
    name: '무궁화',
    category: DogamCategory.plant,
    collected: false,
    oneLiner: '우리나라를 대표하는 꽃',
    kidsDescription: '무궁화는 여름 내내 새 꽃을 피워요. 100일 넘게 꽃을 볼 수 있어요.',
  ),
  MockDogamItem(
    id: 'l1',
    name: '음악분수',
    category: DogamCategory.place,
    collected: true,
    collectedAt: '2026.07.05',
    oneLiner: '음악에 맞춰 춤추는 분수',
    kidsDescription: '음악이 나오면 물줄기가 춤을 추듯 움직여요. 여름엔 시원한 물놀이 명소예요.',
  ),
  MockDogamItem(
    id: 'l2',
    name: '정문광장',
    category: DogamCategory.place,
    collected: true,
    collectedAt: '2026.07.01',
    oneLiner: '공원 탐험이 시작되는 곳',
    kidsDescription: '어린이대공원의 가장 큰 문이에요. 여기서 지도를 보고 탐험을 시작해요.',
  ),
  MockDogamItem(
    id: 'l3',
    name: '동물마을',
    category: DogamCategory.place,
    collected: false,
    oneLiner: '동물 친구들이 모여 사는 곳',
    kidsDescription: '여러 동물 친구들을 한 번에 만날 수 있는 곳이에요.',
  ),
  MockDogamItem(
    id: 'l4',
    name: '식물원',
    category: DogamCategory.place,
    collected: false,
    oneLiner: '신기한 식물이 가득한 유리 온실',
    kidsDescription: '커다란 유리 온실 안에 사막과 열대의 식물이 살고 있어요.',
  ),
];

/// 전체 80종(수집 24)이 되도록 나머지를 자동 생성.
/// 수기 12종(수집 5) + 생성 68종(수집 19) = 80종(수집 24).
final List<MockDogamItem> mockDogamItems = List.unmodifiable([
  ..._curated,
  ...List.generate(68, (i) {
    final category = DogamCategory.values[i % 3];
    final collected = i < 19;
    return MockDogamItem(
      id: 'g$i',
      name: '${category.label} 친구 ${i + 1}',
      category: category,
      collected: collected,
      collectedAt: collected ? '2026.07.0${(i % 9) + 1}' : null,
      oneLiner: '공원 어딘가에서 만날 수 있어요',
      kidsDescription: '공원을 탐험하다 보면 만날 수 있는 친구예요. '
          '카메라로 찍으면 도감에 등록된답니다.',
    );
  }),
]);

int get mockDogamTotal => mockDogamItems.length;

int get mockDogamCollected => mockDogamItems.where((e) => e.collected).length;

/// 퀴즈·축하 화면 고정 항목 (수달) — 화면 간 상태 전달 없음(스펙 §10).
final MockDogamItem mockQuizItem = mockDogamItems.first;
