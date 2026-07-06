import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../providers/auth_provider.dart';

/// TODO: 어대GO 닉네임 설정 디자인 + 중복확인(checkNickname) 연동.
class NicknameSetupPage extends ConsumerStatefulWidget {
  const NicknameSetupPage({super.key, this.initialNickname});
  final String? initialNickname;

  @override
  ConsumerState<NicknameSetupPage> createState() => _NicknameSetupPageState();
}

class _NicknameSetupPageState extends ConsumerState<NicknameSetupPage> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialNickname ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('닉네임을 정해 주세요', style: AppTextStyles.display24),
              const SizedBox(height: 24),
              TextField(controller: _controller),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final nick = _controller.text.trim();
                  if (nick.isEmpty) return;
                  ref
                      .read(authNotifierProvider.notifier)
                      .updateNicknameCompleted(nick);
                },
                child: Text('완료', style: AppTextStyles.label16Semibold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
