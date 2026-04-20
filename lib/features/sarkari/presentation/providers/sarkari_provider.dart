import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/sarkari_repository_impl.dart';
import '../../domain/entities/sarkari_entity.dart';
import '../../domain/repositories/sarkari_repository.dart';

final sarkariRepositoryProvider = Provider<SarkariRepository>(
      (_) => SarkariRepositoryImpl(),
);

// State
class SarkariState {
  final List<SarkariEntity> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const SarkariState({
    this.items        = const [],
    this.isLoading    = false,
    this.isLoadingMore= false,
    this.error,
    this.currentPage  = 1,
    this.hasMore      = true,
  });

  SarkariState copyWith({
    List<SarkariEntity>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) => SarkariState(
    items:          items         ?? this.items,
    isLoading:      isLoading     ?? this.isLoading,
    isLoadingMore:  isLoadingMore ?? this.isLoadingMore,
    error:          error,
    currentPage:    currentPage   ?? this.currentPage,
    hasMore:        hasMore       ?? this.hasMore,
  );
}

class SarkariNotifier extends StateNotifier<SarkariState> {
  final SarkariRepository _repo;
  SarkariType _currentType = SarkariType.job;
  String? _currentExam;

  SarkariNotifier(this._repo) : super(const SarkariState());

  Future<void> load(SarkariType type, {String? exam, bool refresh = false}) async {
    _currentType = type;
    _currentExam = exam;

    state = state.copyWith(
      isLoading: true,
      currentPage: 1,
      hasMore: true,
    );

    final result = await _repo.getItems(type: type, exam: exam, page: 1);
    result.fold(
          (f) => state = state.copyWith(
          isLoading: false, error: f.message),
          (items) => state = state.copyWith(
          isLoading: false,
          items: items,
          currentPage: 1,
          hasMore: items.length >= 10),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.currentPage + 1;
    final result = await _repo.getItems(
        type: _currentType, exam: _currentExam, page: nextPage);

    result.fold(
          (f) => state = state.copyWith(isLoadingMore: false),
          (newItems) => state = state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...newItems],
        currentPage: nextPage,
        hasMore: newItems.length >= 10,
      ),
    );
  }

  Future<void> refresh() => load(_currentType, exam: _currentExam, refresh: true);
}

final sarkariProvider =
StateNotifierProvider.autoDispose<SarkariNotifier, SarkariState>(
      (ref) => SarkariNotifier(ref.read(sarkariRepositoryProvider)),
);