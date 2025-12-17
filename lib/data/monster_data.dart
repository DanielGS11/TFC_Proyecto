import 'package:prueba_1/models/monster.dart';

List<Monster> monsterList  = [
  Monster(
    "Dragon",
    "assets/monsters/dragon.png",
    300,
    300,
    17,
    20,
      {
        "Aliento Igneo": 20,
        "Temblor": 17
      }
  ),

  Monster(
      "Golem",
      "assets/monsters/golem.png",
      400,
      400,
      15,
      30,
      {
        "Temblor": 17,
        "Aumentar Defensa": 0,
      }
  ),

  Monster(
      "Goblin Campeon",
      "assets/monsters/champion_goblin.png",
      200,
      200,
      12,
      17,
      {
        "Aumentar Ataque": 0,
        "Aumentar Defensa": 0,
      }
  ),

  Monster(
      "Minotauro",
      "assets/monsters/minotaur.png",
      270,
      270,
      15,
      17,
      {
        "Aumentar Ataque": 0,
        "Temblor": 17,
      }
  ),

  Monster(
      "Archidemonio",
      "assets/monsters/archdemon.png",
      320,
      320,
      17,
      17,
      {
        "Aumentar Ataque": 0,
        "AquaGarra": 15,
        "Garra Ignea": 15,
      }
  ),
];