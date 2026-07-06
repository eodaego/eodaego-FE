import 'package:flutter/widgets.dart';

/// 위치 권한 다이얼로그 사용 컨텍스트
///
/// 상황별로 다이얼로그 본문이 다르게 매핑된다.
enum LocationPermissionContext { home, game, waitingRoom }

/// 위치 권한 다이얼로그 메시지 (title + message)
class LocationPermissionDialogText {
  const LocationPermissionDialogText({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;
}

/// 위치 권한 다이얼로그 메시지 서비스
///
/// 어대GO는 이번 포팅 범위에서 다국어 지원을 도입하지 않으므로,
/// 원본(cops_and_robbers)의 ARB 기반 문구를 한국어 하드코딩 문자열로 대체했다.
///
/// ponytail: `game`/`waitingRoom` 컨텍스트는 원본(경찰과 도둑 게임)의 화면 구성을
/// 그대로 이어받은 값으로, 어대GO에는 아직 대응 화면이 없어 `home`과 동일한
/// 일반 안내 문구를 사용한다. 지도/카메라 등 위치 기반 기능이 확정되면
/// 컨텍스트별 문구를 다시 다듬을 것.
class LocationPermissionMessages {
  LocationPermissionMessages._();

  /// 위치 서비스 꺼짐 / 권한 미허용에 따른 다이얼로그 텍스트 반환
  ///
  /// [isServiceDisabled] true → 위치 서비스 자체가 꺼진 경우 문구
  /// false → 앱 권한 거부 상태 문구
  static LocationPermissionDialogText getText({
    required BuildContext context,
    required bool isServiceDisabled,
    required LocationPermissionContext locationContext,
  }) {
    if (isServiceDisabled) {
      return const LocationPermissionDialogText(
        title: '위치 서비스가 꺼져 있어요',
        message:
            '내 주변 동물·식물·장소를 찾고 코스를 추천받으려면 위치 정보가 필요해요\n'
            '기기 설정에서 위치 서비스를 켜주세요',
      );
    }

    return const LocationPermissionDialogText(
      title: '위치 권한이 필요해요',
      message:
          '내 주변 동물·식물·장소를 찾고 코스를 추천받으려면 위치 정보가 필요해요\n'
          '설정에서 위치 권한을 허용해 주세요',
    );
  }
}
