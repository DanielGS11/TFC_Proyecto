import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prueba_1/data/monster_data.dart';
import 'package:prueba_1/models/character.dart';
import 'package:prueba_1/models/monster.dart';

class InGameScreen extends StatefulWidget {
  const InGameScreen({super.key});

  @override
  State<InGameScreen> createState() => _InGameScreenState();
}

class _InGameScreenState extends State<InGameScreen> {
  int enemiesNum = 5;
  int enemiesDefeated = 0;

  Character player = Character("Dani", CharacterClass.Mage);

  bool skillMenuDeployed = false;
  bool runAwayMenuDeployed = false;

  String room = "assets/background/in_game/room.png";

  List<String> prompts = [];

  late List<Monster> monsters = List.generate(enemiesNum, (_) {
    Monster monster = monsterList[Random().nextInt(monsterList.length)];

    return Monster(
        monster.name,
        monster.photo,
        monster.maxLife,
        monster.life,
        monster.attack,
        monster.defense,
        monster.magic)
    ;
  });

  Monster get currentEnemy => monsters[enemiesDefeated];

  @override
  Widget build(BuildContext context) {
    if (enemiesDefeated == enemiesNum - 1) {
      room = "assets/background/in_game/last_room.png";
    }

    // Aqui pillo la altura de pantalla para poner porcentajes de altura
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(room, fit: BoxFit.cover)),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _screenText(
                        "Enemigos Derrotados: $enemiesDefeated/$enemiesNum",
                        20,
                      ),
                    ],
                  ),
                ),

                Spacer(),

                SizedBox(height: 250, width: 300, child: _enemyImage()),

                Divider(height: 10, color: Colors.transparent),

                Container(
                  height: 20,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(194, 194, 194, 0.3),
                      width: 1.5,
                    ),

                    color: Color.fromRGBO(0, 0, 140, 0.6),
                  ),
                  child: _healthBar(currentEnemy.maxLife, currentEnemy.life),
                ),

                Spacer(),

                Container(
                  height: screenHeight * 0.3,
                  color: Color.fromRGBO(0, 0, 140, 0.6),
                  child: _playerMenu(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Imagen del Enemigo
  SizedBox _enemyImage() {
    return SizedBox(child: Image.asset(currentEnemy.photo, fit: BoxFit.cover));
  }

  // Menu del Jugador
  Column _playerMenu() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _commandPrompt()),

              Expanded(child: _menu()),
            ],
          ),
        ),

        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(child: _playerInfo()),

              Expanded(flex: 2, child: _playerOptions()),
            ],
          ),
        ),
      ],
    );
  }

  // Command Prompt
  Container _commandPrompt() {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 5, 0, 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(194, 194, 194, 0.3),
          width: 1.5,
        ),
      ),
      child: ListView(
        children: List.generate(
          prompts.length,
              (index) => _screenText("> ${prompts[index]}", 12),
        ),
      ),
    );
  }

  // Menu de skills
  Container _menu() {
    Container menu = Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(194, 194, 194, 0.3),
          width: 1.5,
        ),
      ),
    );

    if (skillMenuDeployed) {
      menu = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(194, 194, 194, 0.3),
            width: 1.5,
          ),
        ),
        child: ListView(
          children: List.generate(player.magic.length, (index) {
            String magicName = player.magic.keys.toList()[index];

            return Container(
              margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
              child: _screenText("- $magicName", 12),
            );
          }),
        ),
      );
    }

    if (runAwayMenuDeployed) {
      menu = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(194, 194, 194, 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _screenText("¿Seguro de que Quieres Huir?", 12),

            Divider(height: 10, color: Colors.transparent),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  child: _screenText("Si", 17),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: Colors.grey.shade700,
                  ),
                  child: _screenText("No", 17),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return menu;
  }

  // Info del Jugador
  Container _playerInfo() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(194, 194, 194, 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SizedBox(
            height: 70,
            width: 60,
            child: Image.asset(player.avatar, fit: BoxFit.fill),
          ),

          Divider(height: 5, color: Colors.transparent),

          _screenText(player.name, 15),

          Divider(height: 5, color: Colors.transparent),

          Container(
            height: 20,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(194, 194, 194, 0.3),
                width: 1.5,
              ),
            ),

            child: Center(
              child: _healthBar(
                player.stats["maxLife"]!,
                player.stats["life"]!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Opciones del Jugador
  Container _playerOptions() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_option("Ataque"), _option("Magia")],
            ),
          ),

          Divider(height: 20, color: Colors.transparent),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_option("Defensa"), _option("Huir")],
            ),
          ),
        ],
      ),
    );
  }

  // Casilla de opcion
  GestureDetector _option(String option) {
    int damage;

    return GestureDetector(
      onTap: () {
        setState(() {
          switch (option) {
            case "Magia":
              runAwayMenuDeployed = false;
              skillMenuDeployed = true;
              break;

            case "Ataque":
              runAwayMenuDeployed = false;
              skillMenuDeployed = false;

              damage = (player.stats["attack"]! * (200 / currentEnemy.defense))
                  .round();

              if ((currentEnemy.life - damage) <= 0) {
                currentEnemy.life = 0;
                enemiesDefeated++;
              } else {
                currentEnemy.life -= damage;
              }

              prompts.addAll([
                "${player.name} ataco a ${currentEnemy.name}",
                "${player.name} hizo $damage puntos de daño",
              ]);
              break;

            case "Defensa":
              runAwayMenuDeployed = false;
              skillMenuDeployed = false;
              break;

            case "Huir":
              runAwayMenuDeployed = true;
              skillMenuDeployed = false;
              break;
          }
        });
      },

      child: _optionContainer(option),
    );
  }

  // Contenedor del Option
  Container _optionContainer(String option) {
    Color? optionColor;

    switch (option) {
      case "Magia":
        optionColor = Color.fromRGBO(102, 89, 247, 0.25);
        break;

      case "Ataque":
        optionColor = Color.fromRGBO(255, 51, 51, 0.25);
        break;

      case "Defensa":
        optionColor = Color.fromRGBO(0, 0, 255, 0.25);
        break;

      case "Huir":
        optionColor = Color.fromRGBO(0, 255, 0, 0.25);
        break;
    }

    return Container(
      height: 40,
      width: 100,

      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(194, 194, 194, 0.3),
          width: 1.5,
        ),
        color: optionColor,
      ),
      child: Center(child: _screenText(option, 15)),
    );
  }

  // Barras de Vida
  Stack _healthBar(int maxLife, int life) {
    int lifePerSection = (maxLife / 10).round();

    return Stack(
      children: [
        Row(
          children: List.generate(10, (index) {
            return Expanded(
              child: Container(
                color: ((lifePerSection * (index)) >= life)
                    ? Colors.transparent
                    : ((maxLife / 2) >= life)
                    ? Colors.orange
                    : ((maxLife / 4) > life)
                    ? Colors.red.shade700
                    : Colors.green,
              ),
            );
          }),
        ),

        Center(child: _screenText(life.toString(), 14)),
      ],
    );
  }

  // Textos de la pantalla
  Text _screenText(String text, double size) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}
