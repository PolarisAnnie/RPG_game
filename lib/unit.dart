/* 추상 클래스 생성 (동일한 부분 묶어서 구성)
abstract class GameUnit {
  String name = '';
  int hp = 0;
  int attackPower = 0;
  int defensePower = 0;

  GameUnit(this.name, this.hp, this.attackPower, this.defensePower);

  void attack();
  void showStatus();
}
*/

class Character {
  //Character(String name, int hp, int attackPower, int defensePower)
  //: super(name, hp, attackPower, defensePower);
  // 부모 생성자 호출해서 Character 초기화

  String nickname = '';
  int hp = 0;
  int attackPower = 0;
  int defensePower = 0;

  //@override
  void attack() {
    // 몬스터 공격
  }

  void defend() {
    // 방어 시 특정 행동 수행
  }

  //@override
  void showStatus() {
    // 몬스터 남은 체력, 공격력, 방어력 매턴 출력
    print('$name - 체력: ${Monster.hp}, 공격력: ${Monster.attackPower}');
  }
}

class Monster {
  //Monster(String name, int hp, int attackPower, int defensePower)
  //: super(name, hp, attackPower, defensePower);
  // 부모 생성자 호출해서 Monster 초기화

  //@override
  void attack() {}

  //@override
  void showStatus() {}
}
