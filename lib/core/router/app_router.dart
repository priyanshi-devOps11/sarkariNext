import 'package:flutter/material.dart';
import '../../features/test_series/presentation/screens/test_list_screen.dart';
import '../../features/test_series/presentation/screens/test_active_screen.dart';
import '../../features/test_series/presentation/screens/test_result_screen.dart';
import '../../features/test_series/domain/entities/test_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/ai_chat/presentation/screens/ai_chat_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/blog/presentation/screens/blog_screen.dart';
import '../../features/courses/presentation/screens/courses_screen.dart';
import '../../features/cutoff_analyzer/presentation/screens/cutoff_analyzer_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/exam_path/presentation/screens/exam_path_builder_screen.dart';
import '../../features/exam_roadmap/presentation/screens/exam_roadmap_screen.dart';
import '../../features/exams/presentation/screens/eligibility_finder_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/study_hub/presentation/screens/study_hub_screen.dart';
import '../widgets/main_layout.dart';

// Important: router must be inside ProviderScope, use ref
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn   = authState is AuthAuthenticated;
      final isLoading    = authState is AuthLoading || authState is AuthInitial;
      final isSplash     = state.matchedLocation == '/';
      final isLoginPage  = state.matchedLocation == '/login';

      if (isLoading) return isSplash ? null : '/';
      if (!isLoggedIn && !isLoginPage && !isSplash) return '/login';
      if (isLoggedIn && isLoginPage) return '/app';
      return null;
    },
    routes: [
      GoRoute(path: '/',      builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(path: '/app',                  builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/app/exams',            builder: (_, __) => const EligibilityFinderScreen()),
          GoRoute(path: '/app/tools',            builder: (_, __) => const ExamPathBuilderScreen()),
          GoRoute(path: '/app/test-series',      builder: (_, __) => const TestListScreen(),),
          GoRoute(path: '/app/test/:id/result',  builder: (_, state) => TestResultsScreen(result: state.extra as TestResultEntity,),),
          GoRoute(path: '/app/test/:id',         builder: (_, state) => TestActiveScreen(testId: state.pathParameters['id']!,),),
          GoRoute(path: '/app/blog',             builder: (_, __) => const BlogScreen()),
          GoRoute(path: '/app/profile',          builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/app/study-hub',        builder: (_, __) => const StudyHubScreen()),
          GoRoute(path: '/app/ai-chat',          builder: (_, __) => const AiChatScreen()),
          GoRoute(path: '/app/courses',          builder: (_, __) => const CoursesScreen()),
          GoRoute(path: '/app/cutoff-analyzer',  builder: (_, __) => const CutoffAnalyzerScreen()),
          GoRoute(
            path: '/app/roadmap/:exam',
            builder: (_, state) => ExamRoadmapScreen(
                exam: state.pathParameters['exam'] ?? ''),
          ),
        ],
      ),
    ],
  );
});