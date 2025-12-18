import 'package:prueba_1/data/skills_data.dart';
import 'package:prueba_1/models/monster.dart';

List<Monster> monsterList = [
  Monster("Dragon", "assets/monsters/dragon.png", 700, 700, 17, 20, [
    skillList.firstWhere((skill) => skill.name == "Aliento Igneo"),
    skillList.firstWhere((skill) => skill.name == "Temblor"),
    skillList.firstWhere((skill) => skill.name == "Aumentar Ataque"),
    skillList.firstWhere((skill) => skill.name == "Aumentar Defensa"),
  ]),

  Monster("Golem", "assets/monsters/golem.png", 800, 800, 15, 30, [
    skillList.firstWhere((skill) => skill.name == "Temblor"),
    skillList.firstWhere((skill) => skill.name == "Aumentar Defensa"),
  ]),

  Monster(
    "Goblin Campeon",
    "assets/monsters/champion_goblin.png",
    400,
    400,
    12,
    17,
    [
      skillList.firstWhere((skill) => skill.name == "Aumentar Ataque"),
      skillList.firstWhere((skill) => skill.name == "Aumentar Defensa"),
    ],
  ),

  Monster("Minotauro", "assets/monsters/minotaur.png", 540, 540, 15, 17, [
    skillList.firstWhere((skill) => skill.name == "Aumentar Ataque"),
    skillList.firstWhere((skill) => skill.name == "Temblor"),
  ]),

  Monster("Archidemonio", "assets/monsters/archdemon.png", 620, 620, 17, 17, [
    skillList.firstWhere((skill) => skill.name == "Aumentar Ataque"),
    skillList.firstWhere((skill) => skill.name == "Aqua Garra"),
    skillList.firstWhere((skill) => skill.name == "Garra Ignea"),
  ]),
];
