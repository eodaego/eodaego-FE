import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../router/route_paths.dart';
import '../../providers/guest_mode_provider.dart';
import 'app_dialog.dart';

/// 게스트가 로그인 필요 기능에 접근할 때 띄우는 유도 다이얼로그.
/// 확인 시 게스트 해제 + 로그인 화면 이동, 취소 시 아무 동작 없음.
Future<void> showLoginGateDialog(
  BuildContext context,
  WidgetRef ref, {
  required String message,
}) async {
  final ok = await AppDialog.confirm(
    context: context,
    title: '로그인이 필요해요',
    message: message,
    confirmText: '로그인하러 가기',
    cancelText: '나중에',
  );
  if (ok == true && context.mounted) {
    ref.read(guestModeProvider.notifier).state = false;
    context.go(RoutePaths.login);
  }
}
