import 'level.dart';

class Settings {
  bool useWeights = false;
  bool useBank = true;
  bool useBar = false;
  bool withOutdoor = false;
  Level level = Level.Normal;

  bool hard() => level == Level.Hard;
  bool easy() => level == Level.Easy;

  Map<String, dynamic> toMap() {
    return {
      'useWeights': useWeights,
      'useBank': useBank,
      'useBar': useBar,
      'withOutdoor': withOutdoor,
      'level': level,
    };
  }
}
