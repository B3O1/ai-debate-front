import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/evaluate_debate.dart';
import 'evaluation_event.dart';
import 'evaluation_state.dart';

class EvaluationBloc extends Bloc<EvaluationEvent, EvaluationState> {
  final EvaluateDebate evaluateDebate;

  EvaluationBloc({
    required this.evaluateDebate,
  }) : super(const EvaluationInitial()) {
    on<EvaluationStarted>(_onStarted);
    on<EvaluationRetried>(_onRetried);
  }

  Future<void> _onStarted(
    EvaluationStarted event,
    Emitter<EvaluationState> emit,
  ) async {
    emit(const EvaluationLoading());

    try {
      final result = await evaluateDebate(config: event.config);
      if (!result.hasRequiredPresentationData) {
        emit(
          const EvaluationError(
            '평가 화면에는 유효한 score, logic_score, persuasion_score, strengths, weaknesses, feedback, raw_chat 데이터가 모두 필요합니다.',
          ),
        );
        return;
      }
      emit(EvaluationLoaded(result));
    } on DioException catch (error) {
      if (error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.connectionTimeout) {
        emit(
          const EvaluationError(
            '평가 분석 시간이 길어지고 있습니다. 잠시 후 다시 시도해주세요.',
          ),
        );
        return;
      }

      emit(
        const EvaluationError(
          '평가 결과를 불러오지 못했습니다. 정확한 평가 데이터 응답 형식을 확인해주세요.',
        ),
      );
    } catch (_) {
      emit(
        const EvaluationError(
          '평가 결과를 불러오지 못했습니다. 정확한 평가 데이터 응답 형식을 확인해주세요.',
        ),
      );
    }
  }

  Future<void> _onRetried(
    EvaluationRetried event,
    Emitter<EvaluationState> emit,
  ) {
    return _onStarted(EvaluationStarted(event.config), emit);
  }
}
