import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/config/env_config.dart';
import 'core/constants/app_colors.dart';
import 'core/services/fcm/firebase_messaging_service.dart';
import 'core/services/fcm/local_notifications_service.dart';
import 'core/storage/secure_token_storage.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 릴리스에서 debugPrint 비활성화 (토큰·위치 등 민감정보 로그 노출 방지)
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  // 재설치 시 이전 토큰 초기화 (iOS Keychain 잔존 대응)
  await SecureTokenStorage().clearTokensIfReinstalled();

  // 환경 변수 로드
  await EnvConfig.initialize();

  // 세로 방향 고정
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Firebase 초기화 (실패해도 앱 실행 계속)
  bool isFirebaseInitialized = false;
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 10));
    isFirebaseInitialized = true;
    debugPrint('✅ Firebase initialized');
  } catch (e, s) {
    debugPrint('❌ Firebase init failed: $e\n$s');
  }

  // Crashlytics (Firebase 성공 시에만)
  if (isFirebaseInitialized) {
    try {
      if (kDebugMode) {
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(false);
      }
      FlutterError.onError = (details) {
        if (kDebugMode) {
          debugPrint('🔥 Flutter Error: ${details.exception}');
        } else {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        }
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        if (kDebugMode) {
          debugPrint('🔥 Async Error: $error');
        } else {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        }
        return true;
      };
    } catch (e) {
      debugPrint('❌ Crashlytics setup failed: $e');
    }
  }

  // 로컬 알림 (Firebase 독립)
  try {
    await LocalNotificationsService.instance().init();
    debugPrint('✅ Local notifications initialized');
  } catch (e) {
    debugPrint('❌ Local notifications init failed: $e');
  }

  // FCM (Firebase 의존)
  if (isFirebaseInitialized) {
    try {
      await FirebaseMessagingService.instance().init();
      debugPrint('✅ FCM initialized');
    } catch (e) {
      debugPrint('❌ FCM init failed: $e');
    }
  }

  runApp(
    ProviderScope(child: MyApp(isFirebaseInitialized: isFirebaseInitialized)),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, this.isFirebaseInitialized = true});

  final bool isFirebaseInitialized;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: '어대GO',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.canvas,
            useMaterial3: true,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
