import 'dart:io';
import 'dart:core';
import 'unit.dart';

String getCharacterName() {
  print('캐릭터의 이름을 입력하세요:');
  try {
    RegExp regExp = RegExp(r'^[a-zA-Z가-힣]+$'); // 정규표현식 => 영문대소문자+한글 허용
    String? nameInput = stdin.readLineSync();

    if (nameInput == null || nameInput.isEmpty) {
      print('입력 값이 없습니다. 다시 입력하세요.');
      return getCharacterName();
    }

    String name = nameInput.toString();
    bool result = regExp.hasMatch(name); // 정규표현식과 같은지 확인

    if (result == true) {
      return name;
    } else {
      print('다시 입력하세요. 이름은 한글과 영문 대소문자로만 구성되어야 합니다.');
      return getCharacterName();
    }
  } catch (e) {
    print('오류가 발생했습니다');
    return getCharacterName();
  }
}

Character? character; // 전역 변수로 활용해야 함
List<Monster> monsters = [];

Future<void> loadCharacterStatsAsync() async {
  try {
    final file = File('assets/characters.txt');
    final contents = await file.readAsString();
    final stats = contents.split(',');
    if (stats.length != 3) throw FormatException('Invalid character data');

    int hp = int.parse(stats[0]);
    int attackPower = int.parse(stats[1]);
    int defensePower = int.parse(stats[2]);

    //입력한 캐릭터 이름 추가
    String name = getCharacterName();
    character = Character(name, hp, attackPower, defensePower);
    print('\n게임을 시작합니다!');
    character!.showStatus();
    print('');
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}

Future<void> loadMonsterStatsAsync() async {
  try {
    final file = File('assets/monsters.txt');
    final contents = await file.readAsString();
    final lines = contents.split('\n');

    for (String line in lines) {
      if (line.trim().isEmpty) continue;

      final stats = line.split(',');
      if (stats.length != 3) continue;

      String name = stats[0].trim();
      int hp = int.parse(stats[1]);
      int attackPower = int.parse(stats[2]);
      int defensePower = 0;
      monsters.add(Monster(name, hp, attackPower, defensePower));
    }
  } catch (e) {
    print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}
