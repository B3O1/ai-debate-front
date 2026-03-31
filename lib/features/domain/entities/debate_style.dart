enum DebateStyle {
  aggressive,
  logical,
  kind,
}

extension DebateStyleX on DebateStyle {
  String get label {
    switch (this) {
      case DebateStyle.aggressive:
        return 'Aggressive';
      case DebateStyle.logical:
        return 'Logical';
      case DebateStyle.kind:
        return 'Kind';
    }
  }

  String get apiValue {
    switch (this) {
      case DebateStyle.aggressive:
        return 'aggressive';
      case DebateStyle.logical:
        return 'logical';
      case DebateStyle.kind:
        return 'kind';
    }
  }

  String get modeLabel {
    switch (this) {
      case DebateStyle.aggressive:
        return 'AGGRESSIVE MODE';
      case DebateStyle.logical:
        return 'LOGICAL MODE';
      case DebateStyle.kind:
        return 'KIND MODE';
    }
  }
}
