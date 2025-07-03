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

  // 아이템 1개 부여 (공격력 2배)
  int item = 1;

  // 게임 시작
  Future<void> startGame() async {
    //settings.dart에서 캐릭터, 몬스터 로드
    await loadCharacterStatsAsync();
    await loadMonsterStatsAsync();

    //캐릭터 체력 증가 기능, 30% 확률로 캐릭터에게 보너스 체력 10 제공
    if (random.nextInt(100) < 30) {
      gameCharacter!.hp += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${gameCharacter!.hp}\n');
    }

    // 게임 시작
    while (gameCharacter!.hp > 0 && gameMonsters.isNotEmpty) {
      Monster currentMonster = getRandomMonster();
      print('새로운 몬스터가 나타났습니다!');
      currentMonster.showStatus();
      print('');

      //전투 진행
      bool isVictory = battle(currentMonster);

      if (isVictory == true) {
        // 패배한 몬스터 제거 및 물리친 몬스터 개수 추가
        gameMonsters.remove(currentMonster);
        monsterNum++;

        // 모든 몬스터 제거 여부 확인
        try {
          if (gameMonsters.isEmpty) {
            print('축하합니다! 모든 몬스터를 물리쳤습니다!');
            saveResult(isVictory);
            return;
          }

          // 이어서 게임 진행 여부 확인, y 또는 n만 입력 가능하게
          while (true) {
            print('다음 몬스터와 싸우시겠습니까? (y/n)');
            String? input = stdin.readLineSync();

            if (input?.toLowerCase() == 'n') {
              print('게임을 종료합니다.');
              saveResult(isVictory);
              return;
            } else if (input?.toLowerCase() == 'y') {
              break;
            } else {
              print('y 또는 n을 입력해주세요.');
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        print('체력이 모두 떨어져 ${gameCharacter!.name}의 모험이 끝났습니다...');
        saveResult(isVictory);
        return;
      }
    }
  }

  // 배틀
  bool battle(Monster monster) {
    while (gameCharacter!.hp > 0 && monster.hp > 0) {
      // 유저(캐릭터) 턴
      print('${character!.name}님의 턴');
      print('행동을 선택하세요. (1 : 공격, 2 : 방어, 3 : 아이템 )');
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

        case '3':
          {
            if (item == 1) {
              gameCharacter!.useAttackItem(monster);
              item--; // 아이템 소멸
            } else {
              print('이미 아이템을 사용했습니다');
              continue;
            }
          }
          break;

        default:
          {
            print('숫자 1, 2, 3 중 하나를 입력해주세요');
            continue;
          }
      }

      print('');

      // 몬스터 체력 0 이하일 경우, 승리
      if (monster.hp <= 0) {
        print('${gameCharacter!.name}이(가) ${monster.name}을(를) 물리쳤습니다!');
        return true;
      }

      print('');
      // 몬스터의 턴
      print('${monster.name}님의 턴');
      monster.attackCharacter(gameCharacter!);

      // 현재 상태 확인
      print('');
      gameCharacter!.showStatus();
      monster.showStatus();
      print('');

      // 캐릭터 체력이 0 이하면 패배
      if (gameCharacter!.hp <= 0) {
        print('${gameCharacter!.name}이(가) ${monster.name}에게 졌습니다.');
        return false;
      }
    }
    throw Exception('전투 로직 오류');
  }

  // 몬스터 랜덤 뽑기
  Monster getRandomMonster() {
    if (gameMonsters.isEmpty) {
      throw Exception('더이상 대결할 몬스터가 없습니다');
    }

    int randomIndex = random.nextInt(gameMonsters.length);
    return gameMonsters[randomIndex];
  }

  // 결과 저장
  void saveResult(isVictory) {
    print('결과를 저장하시겠습니까?(y/n) ');
    String? input = stdin.readLineSync();
    try {
      if (input?.toLowerCase() == 'y') {
        String characterName = gameCharacter!.name;
        int remainhp = gameCharacter!.hp;
        String gameResult = isVictory ? '승리' : '패배';

        String resultContents =
            '이름 : $characterName / 남은체력 : $remainhp / 게임결과 : $gameResult';

        final file = File('assets/result.txt');
        file.writeAsStringSync(resultContents);

        print('게임 결과가 저장되었습니다');
      } else if (input?.toLowerCase() == 'n') {
        print('결과를 저장하지 않고 게임을 종료합니다');
        exit;
      } else {
        print('y 또는 n을 입력해주세요.');
        saveResult(isVictory);
      }
    } catch (e) {
      print('파일 저장 중 오류가 발생했습니다: $e');
    }
  }
}
