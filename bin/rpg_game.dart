import 'dart:io';
import 'package:rpg_game/game.dart';
import 'package:rpg_game/unit.dart';
import 'package:rpg_game/settings.dart';

void main() {
  loadCharacterStatsAsync();
  loadMonsterStatsAsync(); // 파일 로드

  getCharacterName(); // 캐릭터 이름 입력 받기
  // getRandomMonster(); // 몬스터 랜덤 추출

  //battle();
  //startGame();
}
