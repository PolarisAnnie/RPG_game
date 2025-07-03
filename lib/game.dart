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

  // 승리 여부를 파악하는 전역 변수
  bool isVictory = false;

  bool battle(Monster monster) {
    while (gameCharacter!.hp > 0 && monster.hp > 0) {
      // 유저(캐릭터) 턴
      print('${character!.name}님의 턴');
      print('행동을 선택하세요. (1 : 공격, 2 : 방어)');
      String? input = stdin.readLineSync();
      switch (input) {
        case '1':
          {
            //공격하기
            gameCharacter!.attackMonster(monster);
          }
          break;

        case '2':
          {
            //방어하기(랜덤으로 체력 회복)
            int beforeHp = gameCharacter!.hp;
            gameCharacter!.defend();
            int recoverAmount = gameCharacter!.hp - beforeHp;
            print(
              '${gameCharacter!.name}이(가) 방어 태세를 취하여 $recoverAmount만큼 체력을 얻었습니다!',
            );
          }
          break;

        default:
          {
            print('숫자 1, 2 중 하나를 입력해주세요');
            continue;
          }
      }

      print('');

      if (monster.hp <= 0) {
        isVictory = true;
        print('${gameCharacter!.name}이(가) ${monster.name}을(를) 물리쳤습니다!');
        return isVictory; // 몬스터 체력 0 이하일 경우, 승리
      }

      print('');
      // 몬스터의 턴
      print('${monster.name}님의 턴');
      monster.attackCharacter(gameCharacter!);

      // 현재 상태 확인
      gameCharacter!.showStatus();
      monster.showStatus();
      print('');

      if (gameCharacter!.hp <= 0) {
        isVictory = false;
        print('${gameCharacter!.name}이(가) ${monster.name}에게 졌습니다.');
        return isVictory; // 캐릭터 체력이 0 이하면 패배
      }
    }
    return isVictory;
  }

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
