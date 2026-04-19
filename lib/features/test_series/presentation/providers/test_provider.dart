import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/test_repository_impl.dart';
import '../../domain/entities/test_entity.dart';
import '../../domain/repositories/test_repository.dart';

// Repository
final testRepositoryProvider = Provider<TestRepository>(
        (_) => TestRepositoryImpl());

// Test list
final testListProvider = FutureProvider.family<List<TestEntity>, Map<String,String?>>(
      (ref, filters) async {
    final repo = ref.read(testRepositoryProvider);
    final result = await repo.getTests(
        exam: filters['exam'], subject: filters['subject']);
    return result.fold((f) => throw f.message, (data) => data);
  },
);

// ── Active test state ────────────────────────────────────────────────────────
sealed class TestActiveState {}
class TestIdle       extends TestActiveState {}
class TestLoading    extends TestActiveState {}
class TestActive     extends TestActiveState {
  final TestEntity     test;
  final int            currentIndex;
  final Map<int, int>  answers;      // questionIndex → selectedOption
  final int            remainingSecs;
  final bool           isSubmitting;
  TestActive({
    required this.test,
    required this.currentIndex,
    required this.answers,
    required this.remainingSecs,
    this.isSubmitting = false,
  });
}
class TestFinished extends TestActiveState {
  final TestResultEntity result;
  TestFinished(this.result);
}
class TestError extends TestActiveState {
  final String message;
  TestError(this.message);
}

class TestNotifier extends StateNotifier<TestActiveState> {
  final TestRepository _repo;
  Timer? _timer;

  TestNotifier(this._repo) : super(TestIdle());

  Future<void> loadTest(String id) async {
    state = TestLoading();
    final result = await _repo.getTestById(id);
    result.fold(
          (f) => state = TestError(f.message),
          (test) {
        state = TestActive(
          test:          test,
          currentIndex:  0,
          answers:       {},
          remainingSecs: test.durationMins * 60,
        );
        _startTimer();
      },
    );
  }

  void selectAnswer(int questionIndex, int optionIndex) {
    final s = state;
    if (s is! TestActive) return;
    state = TestActive(
      test:          s.test,
      currentIndex:  s.currentIndex,
      answers:       {...s.answers, questionIndex: optionIndex},
      remainingSecs: s.remainingSecs,
    );
  }

  void goToQuestion(int index) {
    final s = state;
    if (s is! TestActive) return;
    state = TestActive(
      test:          s.test,
      currentIndex:  index,
      answers:       s.answers,
      remainingSecs: s.remainingSecs,
    );
  }

  void nextQuestion() {
    final s = state;
    if (s is! TestActive) return;
    if (s.currentIndex < s.test.questions.length - 1) {
      goToQuestion(s.currentIndex + 1);
    }
  }

  void prevQuestion() {
    final s = state;
    if (s is! TestActive) return;
    if (s.currentIndex > 0) goToQuestion(s.currentIndex - 1);
  }

  Future<void> submitTest() async {
    final s = state;
    if (s is! TestActive) return;
    _timer?.cancel();

    final timeTaken = s.test.durationMins * 60 - s.remainingSecs;
    state = TestActive(
      test: s.test, currentIndex: s.currentIndex,
      answers: s.answers, remainingSecs: s.remainingSecs,
      isSubmitting: true,
    );

    final result = await _repo.submitTest(s.test.id, s.answers, timeTaken);
    result.fold(
          (f) => state = TestError(f.message),
          (r) => state = TestFinished(r),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final s = state;
      if (s is! TestActive) return;
      if (s.remainingSecs <= 1) {
        submitTest(); // Auto-submit when time runs out
      } else {
        state = TestActive(
          test:          s.test,
          currentIndex:  s.currentIndex,
          answers:       s.answers,
          remainingSecs: s.remainingSecs - 1,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final testNotifierProvider =
StateNotifierProvider.autoDispose<TestNotifier, TestActiveState>(
        (ref) => TestNotifier(ref.read(testRepositoryProvider)));