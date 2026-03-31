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

  String get personalityValue {
    switch (this) {
      case DebateStyle.aggressive:
        return 'cynical';
      case DebateStyle.logical:
        return 'analytical';
      case DebateStyle.kind:
        return 'empathetic';
    }
  }

  String get attitudeValue {
    switch (this) {
      case DebateStyle.aggressive:
        return 'egoist';
      case DebateStyle.logical:
        return 'calm';
      case DebateStyle.kind:
        return 'respectful';
    }
  }

  String get atmosphereValue {
    switch (this) {
      case DebateStyle.aggressive:
        return 'adversarial';
      case DebateStyle.logical:
        return 'structured';
      case DebateStyle.kind:
        return 'supportive';
    }
  }
}
