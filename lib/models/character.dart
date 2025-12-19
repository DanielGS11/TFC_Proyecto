import 'dart:math';

import 'package:prueba_1/data/skills_data.dart';

import 'Skill.dart';

enum CharacterClass { Mage, Tank, Warrior, Cleric }

class Character {
  final String name;
  final CharacterClass characterClass;
  int level = 1;
  String avatar = "";
  Map<String, int> stats = {
    "Vida Maxima": 0,
    "Vida": 0,
    "Ataque": 0,
    "Ataque Magico": 0,
    "Defensa": 0,
  };
  List<Skill> skills = [];
  int attackBoostTurns = 0;
  int defenseBoostTurns = 0;
  bool attackBoost = false;
  bool defenseBoost = false;

  Character(this.name, this.characterClass) {
    avatar = "assets/characters/${characterClass.name.toLowerCase()}.png";

    switch (characterClass) {
      case CharacterClass.Mage:
        stats["Vida Maxima"] = 100;
        stats["Vida"] = 100;
        stats["Ataque"] = 1;
        stats["Ataque Magico"] = 6;
        stats["Defensa"] = 5;
        skills = [
          skillList.firstWhere((skill) => skill.name == "Fuego"),
          skillList.firstWhere((skill) => skill.name == "Agua"),
          skillList.firstWhere((skill) => skill.name == "Viento"),
          skillList.firstWhere((skill) => skill.name == "Tierra"),
          skillList.firstWhere((skill) => skill.name == "Meditar"),
        ];
        break;

      case CharacterClass.Tank:
        stats["Vida Maxima"] = 140;
        stats["Vida"] = 140;
        stats["Ataque"] = 4;
        stats["Ataque Magico"] = 1;
        stats["Defensa"] = 10;
        skills = [
          skillList.firstWhere((skill) => skill.name == "Aumentar Defensa"),
          skillList.firstWhere((skill) => skill.name == "Aumentar Ataque"),
          skillList.firstWhere((skill) => skill.name == "Meditar"),
        ];
        break;

      case CharacterClass.Warrior:
        stats["Vida Maxima"] = 100;
        stats["Vida"] = 100;
        stats["Ataque"] = 6;
        stats["Ataque Magico"] = 2;
        stats["Defensa"] = 7;
        skills = [
          skillList.firstWhere((skill) => skill.name == "Aumentar Ataque"),
          skillList.firstWhere((skill) => skill.name == "Meditar"),
        ];
        break;
      case CharacterClass.Cleric:
        stats["Vida Maxima"] = 140;
        stats["Vida"] = 140;
        stats["Ataque"] = 1;
        stats["Ataque Magico"] = 3;
        stats["Defensa"] = 3;
        skills = [
          skillList.firstWhere((skill) => skill.name == "Luz Sagrada"),
          skillList.firstWhere((skill) => skill.name == "Meditar"),
        ];
        break;
    }
  }

  void levelUp() {
    level++;

    stats.forEach((stat, value) {
      if (stat == "Vida Maxima") {
        stats[stat] = value + 10;
        stats["Vida"] = stats[stat]!;
      } else if (stat != "Vida") {
        stats[stat] = value + Random().nextInt(3);
      }
    });
  }

  List<String> get characterStats {
    String clase = "";

    switch (characterClass.name) {
      case "Mage":
        clase = "Mago";
        break;

      case "Warrior":
        clase = "Guerrero";
        break;

      case "Cleric":
        clase = "Clerigo";
        break;

      case "Tank":
        clase = "Tanque";
        break;
    }

    List<String> charStats = [
      "Nombre: $name",
      "Clase: $clase",
      "Nivel: $level",
    ];

    stats.forEach((stat, value) => charStats.add("$stat: $value"));

    return charStats;
  }
}
