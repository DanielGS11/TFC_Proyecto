import 'Skill.dart';

class Monster {
  String name;
  String photo;
  int maxLife;
  int life;
  int attack;
  int defense;
  List<Skill> skills;
  int attackBoostTurns = 0;
  int defenseBoostTurns = 0;
  bool attackBoost = false;
  bool defenseBoost = false;

  Monster(this.name, this.photo, this.maxLife, this.life, this.attack, this.defense, this.skills);
}
