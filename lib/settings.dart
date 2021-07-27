import 'package:bbtraining/level.dart';

class Settings {
  bool useWeights = false;
  bool useBank = true;
  bool useBar = false;
  bool useFloor = true;
  bool withOutdoor = false;
  Level level = Level.Normal;

  @override
  bool operator ==(dynamic other) {
    if (this.useWeights != other.useWeights) return false;
    if (this.useBank != other.useBank) return false;
    if (this.useBar != other.useBar) return false;
    if (this.useFloor != other.useFloor) return false;
    if (this.withOutdoor != other.withOutdoor) return false;
    if (this.level != other.level) return false;
    return true;
  }

  @override
  int get hashCode =>
      useWeights.hashCode ^
      useBank.hashCode ^
      useBar.hashCode ^
      useFloor.hashCode ^
      withOutdoor.hashCode ^
      level.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'useWeights': useWeights,
      'useBank': useBank,
      'useBar': useBar,
      'useFloor': useFloor,
      'withOutdoor': withOutdoor,
      'level': level.index,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  static Settings fromMap(Map<String, dynamic> data) {
    Settings settings = Settings();
    settings.useWeights = (data['useWeights'] ?? false);
    settings.useBank = (data['useBank'] ?? true);
    settings.useBar = (data['useBar'] ?? false);
    settings.useFloor = (data['useFloor'] ?? false);
    settings.withOutdoor = (data['withOutdoor'] ?? false);
    settings.level = Level.values[(data['level'] ?? 1)];

    return settings;
  }
}
