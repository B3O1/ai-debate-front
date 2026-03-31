import '../../domain/entities/debate_evaluation.dart';

class DebateEvaluationModel {
  final String summary;

  const DebateEvaluationModel({
    required this.summary,
  });

  factory DebateEvaluationModel.fromApi(dynamic data) {
    return DebateEvaluationModel(
      summary: _extractSummary(data),
    );
  }

  static String _extractSummary(dynamic data) {
    if (data is String) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      final evaluation = data['evaluation'];
      if (evaluation is Map<String, dynamic>) {
        final logicScore = evaluation['logic_score'];
        final persuasionScore = evaluation['persuasion_score'];
        final feedback = evaluation['feedback'];
        final isEmotional = evaluation['is_emotional'];

        final buffer = StringBuffer();

        if (logicScore != null) {
          buffer.writeln('논리 점수: $logicScore');
        }
        if (persuasionScore != null) {
          buffer.writeln('설득 점수: $persuasionScore');
        }
        if (isEmotional != null) {
          buffer.writeln('감정적 표현 여부: ${isEmotional == true ? '예' : '아니오'}');
        }
        if (feedback is String && feedback.trim().isNotEmpty) {
          if (buffer.isNotEmpty) {
            buffer.writeln();
          }
          buffer.write('피드백: $feedback');
        }

        final summary = buffer.toString().trim();
        if (summary.isNotEmpty) {
          return summary;
        }
      }

      const candidateKeys = [
        'summary',
        'evaluation',
        'analysis',
        'message',
        'result',
        'content',
        'text',
      ];

      for (final key in candidateKeys) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }

      final nested = data['data'];
      if (nested != null) {
        return _extractSummary(nested);
      }
    }

    return '평가 결과를 해석하지 못했습니다. API 응답 필드를 확인해주세요.';
  }

  DebateEvaluation toEntity() {
    return DebateEvaluation(summary: summary);
  }
}
