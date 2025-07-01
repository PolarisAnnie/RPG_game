import 'dart:io';
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
      print('게임을 시작합니다!');
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
Monster? monster;

Future<void> loadCharacterStatsAsync() async {
  try {
    final file = File('characters.txt');
    final contents = await file.readAsString();
    final stats = contents.split(',');
    if (stats.length != 3) throw FormatException('Invalid character data');

    int hp = int.parse(stats[0]);
    int attackPower = int.parse(stats[1]);
    int defensePower = int.parse(stats[2]);

    String name = getCharacterName();
    character = Character(name, hp, attackPower, defensePower);
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}

Future<void> loadMonsterStatsAsync() async {
  try {
    final file = File('monsters.txt');
    final contents = await file.readAsString();
    final stats = contents.split(',');
    if (stats.length != 4) throw FormatException('Invalid monster data');

    String name = stats[0];
    int hp = int.parse(stats[1]);
    int attackPower = int.parse(stats[2]);
    int defensePower = int.parse(stats[3]);

    monster = Monster(name, hp, attackPower, defensePower);
  } catch (e) {
    print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}
