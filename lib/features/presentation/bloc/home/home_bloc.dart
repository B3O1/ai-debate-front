import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_home_items.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeItems getHomeItems;

  HomeBloc(this.getHomeItems) : super(const HomeState.initial()) {
    on<HomeStarted>(_onHomeStarted);
    on<TopicSelected>(_onTopicSelected);
    on<TopicHovered>(_onTopicHovered);
    on<TopicHoverExited>(_onTopicHoverExited);
    on<DebateStyleToggled>(_onDebateStyleToggled);
    on<DebateStyleHovered>(_onDebateStyleHovered);
    on<DebateStyleHoverExited>(_onDebateStyleHoverExited);
    on<CustomTopicChanged>(_onCustomTopicChanged);
  }

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));

    try {
      final items = await getHomeItems();
      emit(state.copyWith(isLoading: false, topics: items));
    } catch (_) {
      emit(
        state.copyWith(isLoading: false, errorMessage: '주제 목록을 불러오지 못했습니다.'),
      );
    }
  }

  void _onTopicSelected(TopicSelected event, Emitter<HomeState> emit) {
    if (state.selectedTopicId == event.topicId) {
      emit(state.copyWith(clearSelectedTopic: true, customTopicText: ''));
      return;
    }

    if (event.topicId == 'custom') {
      emit(state.copyWith(selectedTopicId: 'custom'));
      return;
    }

    emit(state.copyWith(selectedTopicId: event.topicId, customTopicText: ''));
  }

  void _onTopicHovered(TopicHovered event, Emitter<HomeState> emit) {
    emit(state.copyWith(hoveredTopicId: event.topicId));
  }

  void _onTopicHoverExited(TopicHoverExited event, Emitter<HomeState> emit) {
    emit(state.copyWith(clearHoveredTopic: true));
  }

  void _onDebateStyleToggled(
    DebateStyleToggled event,
    Emitter<HomeState> emit,
  ) {
    if (state.selectedStyle == event.style) {
      emit(state.copyWith(clearSelectedStyle: true));
      return;
    }

    emit(state.copyWith(selectedStyle: event.style));
  }

  void _onDebateStyleHovered(
    DebateStyleHovered event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(hoveredStyle: event.style));
  }

  void _onDebateStyleHoverExited(
    DebateStyleHoverExited event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(clearHoveredStyle: true));
  }

  void _onCustomTopicChanged(
    CustomTopicChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(customTopicText: event.value));
  }
}
