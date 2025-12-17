import 'dart:math';

enum CharacterClass { Mage, Tank, Warrior, Cleric }

class Character {
  final String name;
  final CharacterClass characterClass;
  int level = 1;
  String avatar = "";
  Map<String, int> stats = {
    "maxLife": 0,
    "life": 0,
    "attack": 0,
    "magicAttack": 0,
    "defense": 0,
  };
  Map<String, int> magic = {};

  Character(this.name, this.characterClass) {
    avatar = "assets/characters/${characterClass.name.toLowerCase()}.png";

    switch (characterClass) {
      case CharacterClass.Mage:

        stats["maxLife"] = 100;
        stats["life"] = 100;
        stats["attack"] = 2;
        stats["magicAttack"] = 7;
        stats["defense"] = 5;
        magic = {
          "Fuego": 10,
          "Agua": 10,
          "Viento": 10,
          "Tierra": 10,
          "Meditar": 0,
        };
        break;

      case CharacterClass.Tank:
        stats["maxLife"] = 140;
        stats["life"] = 140;
        stats["attack"] = 4;
        stats["magicAttack"] = 1;
        stats["defense"] = 10;
        magic = {"Aumentar Defensa": 0, "Meditar": 0};
        break;

      case CharacterClass.Warrior:
        stats["maxLife"] = 100;
        stats["life"] = 100;
        stats["attack"] = 8;
        stats["magicAttack"] = 2;
        stats["defense"] = 7;
        magic = {"Aumentar Ataque": 0, "Meditar": 0};
        break;
      case CharacterClass.Cleric:
        stats["maxLife"] = 140;
        stats["life"] = 140;
        stats["attack"] = 1;
        stats["magicAttack"] = 7;
        stats["defense"] = 7;
        magic = {"Luz Sagrada": 10, "Meditar": 0};
        break;
    }
  }

  set levelUp(int grow) {
    level = level + grow;

    stats.forEach((stat, value) {
      stats[stat] = value + Random().nextInt(3);
    });
  }

  void get characterStats {
    "Name: $name";
    "Class: $characterClass";
    "Level: $level";
    stats.forEach((stat, value) {
      "$stat: $value";
    });
  }
}
