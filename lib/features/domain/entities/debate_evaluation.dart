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
    final hasScoreData =
        score != null && logicScore != null && persuasionScore != null;
    final hasCoachingData =
        summary.trim().isNotEmpty ||
        strengths.isNotEmpty ||
        weaknesses.isNotEmpty ||
        rawChat.trim().isNotEmpty;

    return hasScoreData && hasCoachingData;
  }
}
