import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DogamCategory.fromServer', () {
    test('maps_server_strings_to_matching_category', () {
      expect(DogamCategory.fromServer('ANIMAL'), DogamCategory.animal);
      expect(DogamCategory.fromServer('PLANT'), DogamCategory.plant);
      expect(DogamCategory.fromServer('PLACE'), DogamCategory.place);
    });

    test('returns_null_when_category_is_unknown', () {
      // 서버에 카테고리가 추가되면 구버전 앱은 모르는 값을 받는다.
      // 죽지 않고 null을 돌려줘야 호출부가 항목을 건너뛸 수 있다.
      expect(DogamCategory.fromServer('INSECT'), isNull);
      expect(DogamCategory.fromServer(''), isNull);
      expect(DogamCategory.fromServer(null), isNull);
    });
  });
}
