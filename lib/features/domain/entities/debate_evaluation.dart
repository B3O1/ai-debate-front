class DebateEvaluation {
  final int? score;
  final int? logicScore;
  final int? persuasionScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final String summary;
  final String rawChat;

  const DebateEvaluation({
    required this.score,
    required this.logicScore,
    required this.persuasionScore,
    required this.strengths,
    required this.weaknesses,
    required this.summary,
    required this.rawChat,
  });

  bool get hasRequiredPresentationData {
    return score != null &&
        score! > 0 &&
        logicScore != null &&
        logicScore! > 0 &&
        persuasionScore != null &&
        persuasionScore! > 0 &&
        strengths.isNotEmpty &&
        weaknesses.isNotEmpty &&
        summary.trim().isNotEmpty &&
        rawChat.trim().isNotEmpty;
  }
}
