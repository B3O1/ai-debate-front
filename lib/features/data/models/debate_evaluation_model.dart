import '../../domain/entities/debate_evaluation.dart';

class DebateEvaluationModel {
  final int? score;
  final int? logicScore;
  final int? persuasionScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final String feedback;
  final String rawChat;

  const DebateEvaluationModel({
    required this.score,
    required this.logicScore,
    required this.persuasionScore,
    required this.strengths,
    required this.weaknesses,
    required this.feedback,
    required this.rawChat,
  });

  factory DebateEvaluationModel.fromApi(Map<String, dynamic> data) {
    return DebateEvaluationModel(
      score: _asInt(data['score']),
      logicScore: _asInt(data['logic_score']),
      persuasionScore: _asInt(data['persuasion_score']),
      strengths: _asStringList(data['strengths']),
      weaknesses: _asStringList(data['weaknesses']),
      feedback: _asString(data['feedback']),
      rawChat: _asString(data['raw_chat']),
    );
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static String _asString(dynamic value) {
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return '';
      if (trimmed.toLowerCase() == 'string') return '';
      return trimmed;
    }
    return '';
  }

  static List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value
          .whereType<String>()
          .map((item) => item.trim())
          .where((item) => item.toLowerCase() != 'string')
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  DebateEvaluation toEntity() {
    return DebateEvaluation(
      score: score,
      logicScore: logicScore,
      persuasionScore: persuasionScore,
      strengths: strengths,
      weaknesses: weaknesses,
      summary: feedback,
      rawChat: rawChat,
    );
  }
}
