import 'package:eodaego/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.validateNickname', () {
    test('accepts_korean_english_digits', () {
      expect(Validators.validateNickname('어대탐험가'), isNull);
      expect(Validators.validateNickname('eodaego'), isNull);
      expect(Validators.validateNickname('회원a1b2c3d4'), isNull);
      expect(Validators.validateNickname('12'), isNull);
    });

    test('rejects_empty_or_whitespace_only', () {
      expect(Validators.validateNickname(null), '닉네임을 입력해 주세요');
      expect(Validators.validateNickname(''), '닉네임을 입력해 주세요');
      expect(Validators.validateNickname('   '), '닉네임을 입력해 주세요');
    });

    test('rejects_lengths_outside_2_to_10', () {
      expect(Validators.validateNickname('가'), '2자에서 10자 사이로 입력해 주세요');
      expect(Validators.validateNickname('a' * 11), '2자에서 10자 사이로 입력해 주세요');
    });

    test('accepts_boundary_lengths_2_and_10', () {
      expect(Validators.validateNickname('가나'), isNull);
      expect(Validators.validateNickname('a' * 10), isNull);
    });

    test('rejects_special_characters_and_inner_whitespace', () {
      expect(Validators.validateNickname('어대!'), '한글, 영문, 숫자만 쓸 수 있어요');
      expect(Validators.validateNickname('어대 탐험'), '한글, 영문, 숫자만 쓸 수 있어요');
      expect(Validators.validateNickname('어대_탐험'), '한글, 영문, 숫자만 쓸 수 있어요');
    });

    test('trims_surrounding_whitespace_before_validating', () {
      expect(Validators.validateNickname('  어대탐험가  '), isNull);
    });
  });
}
