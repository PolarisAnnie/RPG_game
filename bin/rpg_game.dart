import 'dart:io';
import 'package:rpg_game/game.dart' as rpg_game;
import 'package:rpg_game/unit.dart' as rpg_game;

void main() {
  print('캐릭터의 이름을 입력하세요:');
  try {
    RegExp regExp = RegExp(r'^[a-zA-Z가-힣]+$');
    String? nameInput = stdin.readLineSync();

    bool result = regExp.hasMatch('$nameInput');

    if (result == true) {
      Character.name = nameInput;
      print('게임을 시작합니다!');
    } else {
      print('다시 입력하세요. 이름은 한글과 영문대소문자로만 구성되어야 합니다.');
    }
  } catch (e) {
    print('이름은 한글, 영문 대소문자만 입력 가능합니다.');
  }
}
