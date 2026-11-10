import 'package:eodaego/features/scan/presentation/widgets/scan_camera_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('camera_is_not_reopened_on_resume_right_after_permission_denied', () {
    expect(
      shouldReopenCameraOnResume(
        hasController: false,
        releasedByLifecycle: false,
        wentToBackground: false,
      ),
      isFalse,
    );
  });

  test('camera_is_reopened_on_resume_when_released_by_inactive', () {
    expect(
      shouldReopenCameraOnResume(
        hasController: false,
        releasedByLifecycle: true,
        wentToBackground: false,
      ),
      isTrue,
    );
  });

  test('camera_is_reopened_on_resume_after_denied_then_backgrounded', () {
    expect(
      shouldReopenCameraOnResume(
        hasController: false,
        releasedByLifecycle: false,
        wentToBackground: true,
      ),
      isTrue,
    );
  });

  test('camera_is_not_reopened_on_resume_while_still_opening', () {
    expect(
      shouldReopenCameraOnResume(
        hasController: true,
        releasedByLifecycle: false,
        wentToBackground: true,
      ),
      isFalse,
    );
  });
}
