import 'dart:io';
import 'dart:math';
import 'unit.dart';
import 'settings.dart';

class Game {
  // settings.dart의 전역 변수들을 사용
  Character? get gameCharacter => character;
  List<Monster> get gameMonsters => monsters;
  int monsterNum = 0; // 물리친 몬스터 개수, 몬스터 리스트 개수보다 클 수 없음

  // 몬스터 랜덤 뽑기를 위한 전역 변수
  Random random = Random();

  Monster getRandomMonster() {
    if (gameMonsters.isEmpty) {
      throw Exception('더이상 대결할 몬스터가 없습니다');
    }

    int randomIndex = random.nextInt(gameMonsters.length);
    Monster selectedMosnter = gameMonsters[randomIndex];

    return Monster(
      selectedMosnter.name,
      selectedMosnter.hp,
      selectedMosnter.attackPower,
      selectedMosnter.defensePower,
    );
  }

  void saveResult() {
    print('결과를 저장하시겠습니까?(y/n) ');
    String? input = stdin.readLineSync();
    try {
      if (input?.toLowerCase() == 'y') {
        String characterName = gameCharacter!.name;
        int remainhp = gameCharacter!.hp;
        String gameResult = isVictory ? '승리' : '패배';

        String resultContents =
            '이름 : $characterName / 남은체력 : $remainhp / 게임결과 : $gameResult';

        final file = File('result.txt');
        file.writeAsStringSync(resultContents);

        print('게임 결과가 저장되었습니다');
      } else {
        print('결과를 저장하지 않고 게임을 종료합니다');
        exit;
      }
    } catch (e) {
      print('파일 저장 중 오류가 발생했습니다: $e');
    }
  }
}
