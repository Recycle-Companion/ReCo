enum DetectionClasses { cardboard, glas, metal, paper, plastic, other }

extension DetectionClassesExtension on DetectionClasses {
  String get label {
    switch (this) {
      case DetectionClasses.cardboard:
        return "Cardboard";
      case DetectionClasses.glas:
        return "glas";
      case DetectionClasses.metal:
        return "metal";
      case DetectionClasses.paper:
        return "paper";
      case DetectionClasses.plastic:
        return "plastic";
      case DetectionClasses.other:
        return "other";
    }
  }
}
