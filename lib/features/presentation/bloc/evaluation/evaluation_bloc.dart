import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/network_error_mapper.dart';
import '../../../domain/usecases/evaluate_debate.dart';
import 'evaluation_event.dart';
import 'evaluation_state.dart';

class EvaluationBloc extends Bloc<EvaluationEvent, EvaluationState> {
  final EvaluateDebate evaluateDebate;

  EvaluationBloc({required this.evaluateDebate})
    : super(const EvaluationInitial()) {
    on<EvaluationStarted>(_onStarted);
    on<EvaluationRetried>(_onRetried);
  }

  Future<void> _onStarted(
    EvaluationStarted event,
    Emitter<EvaluationState> emit,
  ) async {
    emit(const EvaluationLoading());

    try {
      final result = await evaluateDebate();
      if (!result.hasRequiredPresentationData) {
        emit(
          const EvaluationError(
            '평가 응답은 도착했지만 화면에 표시할 핵심 데이터가 부족합니다. score 계열 값과 요약/강약점 필드를 함께 확인해주세요.',
          ),
        );
        return;
      }
      emit(EvaluationLoaded(result));
    } on DioException catch (error) {
      emit(
        EvaluationError(
          NetworkErrorMapper.toUserMessage(error, requestLabel: '평가 요청'),
        ),
      );
    } catch (_) {
      emit(
        const EvaluationError('평가 결과를 불러오지 못했습니다. 정확한 평가 데이터 응답 형식을 확인해주세요.'),
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
