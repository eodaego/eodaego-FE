import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_haptics.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';

/// 코스 생성 대기 화면.
///
/// AI 응답까지 기다리는 시간이 길어 고양이를 눌러볼 수 있게 뒀다.
/// 풍선처럼 동작한다 — 누르고 있으면 부풀고, 한계에 가까워지면
/// 떨림이 빨라지며, 놓으면 통통 튀면서 제자리로 돌아온다.
class CourseLoadingCat extends StatefulWidget {
  const CourseLoadingCat({super.key});

  @override
  State<CourseLoadingCat> createState() => _CourseLoadingCatState();
}

/// 누르고 있을 때 도달하는 최대 배율 — 화면을 넘길 만큼 크다.
const double _maxScale = 4.0;

/// 최대 배율까지 부푸는 데 걸리는 시간.
const Duration _growDuration = Duration(seconds: 3);

/// 놓았을 때 통통 튀며 제자리로 돌아오는 시간 (최대로 부풀었을 때 기준).
const Duration _bounceDuration = Duration(milliseconds: 650);

/// 놓은 뒤 흔들림 여운이 잦아드는 시간 — 크기 복귀보다 오래 남는다.
const Duration _flapDuration = Duration(milliseconds: 1100);

/// 흔들림 빠르기 (초당 왕복 수) — 느슨할 때와 한계일 때.
const double _trembleSlowHz = 1.2;
const double _trembleFastHz = 6.0;

/// 최대 기울기 (라디안, 약 5도).
const double _maxWobbleAngle = 0.09;

/// 한계 직전 크기가 파르르 떨리는 폭 (±3%).
const double _strainPulse = 0.03;

/// 놓았을 때 찌그러졌다 펴지는 폭 (±7%) — 고무 같은 변형.
const double _squashAmount = 0.07;

const double _twoPi = 2 * math.pi;

class _CourseLoadingCatState extends State<CourseLoadingCat>
    with TickerProviderStateMixin {
  /// 0이면 원래 크기, 1이면 [_maxScale].
  late final AnimationController _inflate =
      AnimationController(vsync: this, duration: _growDuration)
        ..addStatusListener((status) {
          // Heavy thud once when fully inflated
          // 한계까지 다 부풀면 묵직한 진동을 한 번 준다
          if (status == AnimationStatus.completed) AppHaptics.thud();
        });

  /// 손을 뗀 순간의 부푼 정도에서 시작해 0으로 잦아드는 여운.
  late final AnimationController _flap = AnimationController(
    vsync: this,
    duration: _flapDuration,
  );

  /// 흔들림 위상 (라디안) — 긴장할수록 빨리 돈다.
  final ValueNotifier<double> _phase = ValueNotifier(0.0);

  // ponytail: 항상 도는 ticker — 가만히 있을 땐 흔들림 세기가 0이라 화면은
  // 안 변한다. 전력이 문제 되면 누르는 동안만 돌리는 것으로 바꾼다.
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  /// 한계에 가까울수록 커지는 긴장도 (0~1) — 중반까지는 거의 0이다.
  double get _strain => Curves.easeInQuint.transform(_inflate.value);

  /// 지금 얼마나 흔들릴지 — 부푸는 중엔 긴장도, 놓은 뒤엔 잦아드는 여운.
  double get _wobbleAmount => math.max(_strain, _flap.value);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _inflate.dispose();
    _flap.dispose();
    _phase.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final dt =
        (elapsed - _lastTick).inMicroseconds / Duration.microsecondsPerSecond;
    _lastTick = elapsed;

    // Tremble speeds up as it nears the limit
    // 한계에 가까워질수록 떨림이 빨라진다
    final hz =
        _trembleSlowHz + (_trembleFastHz - _trembleSlowHz) * _wobbleAmount;
    var next = _phase.value + dt * _twoPi * hz;
    if (next >= _twoPi) {
      next %= _twoPi;
      // Fingertip tremble once per cycle near the limit
      // 터지기 직전 구간에서는 한 바퀴마다 손끝에도 잔진동을 준다
      if (_strain > 0.55) AppHaptics.tick();
    }
    _phase.value = next;
  }

  void _press() {
    AppHaptics.tap();
    // 남은 거리만큼만 시간을 줘서, 다시 눌러도 같은 속도로 이어 부푼다
    _inflate.animateTo(
      1.0,
      duration: _growDuration * (1.0 - _inflate.value),
      curve: Curves.linear,
    );
  }

  void _release() {
    // 늘어난 만큼 여운도 크다 — 조금 불었으면 조금만 흔들린다
    _flap
      ..value = math.max(_flap.value, _inflate.value)
      ..animateBack(0.0, duration: _flapDuration, curve: Curves.linear);
    _inflate.animateBack(
      0.0,
      duration: _bounceDuration * _inflate.value,
      curve: Curves.bounceOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTapDown: (_) => _press(),
          onTapUp: (_) => _release(),
          onTapCancel: _release,
          child: AnimatedBuilder(
            animation: Listenable.merge([_inflate, _flap, _phase]),
            // 화면 밖으로 넘쳐도 두는데, Transform은 레이아웃을 건드리지
            // 않아 아래 문구는 제자리에 있는다.
            builder: (context, child) {
              final wobble = math.sin(_phase.value);
              // 한계 직전에는 크기도 파르르 떨린다
              final scale =
                  (1.0 + (_maxScale - 1.0) * _inflate.value) *
                  (1.0 + _strainPulse * math.sin(2 * _phase.value) * _strain);
              // 놓은 뒤에는 찌그러졌다 펴지며 젤리처럼 돌아온다
              final squash = _squashAmount * wobble * _flap.value;
              return Transform.rotate(
                angle: wobble * _maxWobbleAngle * _wobbleAmount,
                child: Transform.scale(
                  scaleX: scale * (1 + squash),
                  scaleY: scale * (1 - squash),
                  child: child,
                ),
              );
            },
            // AI 생성이라 대기가 길다. 스피너 대신 계속 볼 만한 그림을 둔다.
            child: Lottie.asset(
              'assets/animations/Loader_Cat.json',
              width: 360.w,
              repeat: true,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.base.h),
        Text(
          '코스를 만들고 있어요',
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          '조금만 기다리면 돼요',
          style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
