//추상 클래스 생성 (동일한 부분 묶어서 구성)
import 'dart:math';

abstract class GameUnit {
  String name = '';
  int hp = 0;
  int attackPower = 0;
  int defensePower = 0;

  GameUnit(this.name, this.hp, this.attackPower, this.defensePower);

  void showStatus();
}

class Character extends GameUnit {
  Character(super.name, super.hp, super.attackPower, super.defensePower);
  // 부모 속성 그대로 사용(초기화)

  void attackMonster(Monster monster) {
    // 몬스터 공격
    monster.hp -= attackPower;
    print('$name이(가) ${monster.name}에게 $attackPower의 데미지를 입혔습니다.');
  }

  void useAttackItem(Monster monster) {
    // 아이템 사용(공격력 2배)
    monster.hp -= attackPower * 2;
    print(
      '$name이(가) ${monster.name}에게 공격력 2배 아이템을 사용하여 ${attackPower * 2}의 데미지를 입혔습니다.',
    );
  }

  void defend() {
    // 방어 시 특정 행동 수행
    Random random = Random();
    int recovery = random.nextInt(6); // 0~5까지 랜덤으로 체력 회복
    hp += recovery;
  }

  @override
  void showStatus() {
    // 남은 체력, 공격력, 방어력 매턴 출력
    print('$name - 체력 : $hp, 공격력 : $attackPower, 방어력 : $defensePower');
  }
}

class Monster extends GameUnit {
  Monster(super.name, super.hp, super.attackPower, super.defensePower);
  // 부모 속성 그대로 사용

  void attackCharacter(Character character) {
    // 캐릭터 공격
    //  몬스터의 공격력 > 캐릭터의 방어력
    //  캐릭터 방어력 or 랜덤값 중 최대값으로 설정
    //  데미지 = 몬스터의 공격력 - 캐릭터의 방어력, 최소 데미지는 0 이상
    Random random = Random();
    int randomAttack = random.nextInt(attackPower) + 1;
    int damage = max(0, randomAttack - character.defensePower);

    character.hp -= damage;
    print('$name이(가) ${character.name}에게 $damage의 데미지를 입혔습니다.');
  }

  @override
  void showStatus() {
    // 남은 체력, 공격력, 방어력 매턴 출력
    print('$name - 체력 : $hp, 공격력 : $attackPower');
  }
}
