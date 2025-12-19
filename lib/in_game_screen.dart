import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prueba_1/data/monster_data.dart';
import 'package:prueba_1/models/Skill.dart';
import 'package:prueba_1/models/character.dart';
import 'package:prueba_1/models/monster.dart';

class InGameScreen extends StatefulWidget {
  const InGameScreen({super.key});

  @override
  State<InGameScreen> createState() => _InGameScreenState();
}

class _InGameScreenState extends State<InGameScreen> {
  final _scrollPrompt = ScrollController();

  int enemiesDefeated = 0;
  int turnos = 1;

  bool skillMenuDeployed = false;
  bool runAwayMenuDeployed = false;

  // Coge una skill para mostrar detalles si se pulsa largo en el menu
  Skill? skillDetail = null;

  String room = "assets/background/in_game/room.png";

  late List<Monster> monsters;
  late Character player;
  late int enemiesNum;
  late Monster currentEnemy;
  late List<String> prompts;

  @override
  void initState() {
    super.initState();

    // Se asignarán desde los argumentos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<dynamic> matchData =
          ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      player = matchData.first;
      enemiesNum = matchData.last;

      monsters = List.generate(enemiesNum, (_) {
        Monster monster = monsterList[Random().nextInt(monsterList.length)];
        return Monster(
          monster.name,
          monster.photo,
          monster.maxLife,
          monster.life,
          monster.attack,
          monster.defense,
          monster.skills,
        );
      });

      currentEnemy = monsters[enemiesDefeated];

      if (enemiesDefeated == enemiesNum - 1) {
        room = "assets/background/in_game/last_room.png";
      }

      prompts = ["${currentEnemy.name} aparecio!"];
      setState(() {}); // fuerza rebuild después de crear la lista
    });
  }

  @override
  Widget build(BuildContext context) {
    // Aqui pillo la altura de pantalla para poner porcentajes de altura
    double screenHeight = MediaQuery.of(context).size.height;

    // Aqui pillo la anchura de pantalla para poner porcentajes de anchura
    double screenWidth = MediaQuery.of(context).size.width;

    /*
     Con este metodo espera a que se termine de llamar la command Prompt y
     se desplaza al final
     */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollPrompt.hasClients) {
        _scrollPrompt.jumpTo(_scrollPrompt.position.maxScrollExtent);
      }
    });

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
                        "Enemigos derrotados: $enemiesDefeated/$enemiesNum",
                        20,
                      ),
                    ],
                  ),
                ),

                Spacer(),

                SizedBox(height: 250, width: 300, child: _enemyImage()),

                Divider(height: 5, color: Colors.transparent),

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

                SizedBox(
                  height: screenHeight * 0.41,
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.03,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: skillMenuDeployed
                              ? [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: _screenText(
                                      "Manten pulsado sobre la magia para ver mas informacion",
                                      13,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Icon(
                                      Icons.help_outline,
                                      color: Colors.white,
                                      size: 11,
                                    ),
                                  ),
                                ]
                              : [],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Color.fromRGBO(0, 0, 140, 0.6),
                          child: _playerMenu(screenWidth),
                        ),
                      ),
                    ],
                  ),

                  // _playerMenu(),
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
  Column _playerMenu(double screenWidth) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.58, child: _commandPrompt()),

              SizedBox(width: screenWidth * 0.42, child: _menu()),
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
    Container promptContainer = Container();

    if (skillDetail != null) {
      promptContainer = Container(
        padding: EdgeInsets.fromLTRB(8, 5, 0, 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(194, 194, 194, 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [_screenText(skillDetail!.description, 12)]),

            Center(child: _screenText("Poder: ${skillDetail!.power}", 12)),
          ],
        ),
      );
    } else {
      promptContainer = Container(
        padding: EdgeInsets.fromLTRB(8, 5, 0, 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(194, 194, 194, 0.3),
            width: 1.5,
          ),
        ),
        child: ListView(
          controller: _scrollPrompt,
          children: List.generate(
            prompts.length,
            (index) => _prompt("> ${prompts[index]}", ValueKey(index)),
          ),
        ),
      );
    }

    return promptContainer;
  }

  // Menu de skills/huida
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
          children: List.generate(player.skills.length, (index) {
            String magicName = player.skills[index].name;

            return _skill(magicName);
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
            _screenText("¿Seguro de que quieres huir?", 12),
            Text(
              "La Partida acabará si te vas",
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/result",
                      arguments: [player, "Run Away"],
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    minimumSize: Size(35, 25),
                    backgroundColor: Colors.red,
                  ),
                  child: _screenText("Si", 14),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      runAwayMenuDeployed = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: Colors.grey.shade700,
                    minimumSize: Size(35, 25),
                  ),
                  child: _screenText("No", 14),
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
                player.stats["Vida Maxima"]!,
                player.stats["Vida"]!,
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
              prompts.add("- Turno ${turnos.toString()}");
              turnos++;
              runAwayMenuDeployed = false;
              skillMenuDeployed = false;

              damage = ((player.stats["Ataque"]! * 6) - currentEnemy.defense)
                  .round();

              if (damage < 2) {
                damage = 2;
              }

              prompts.add("${player.name} ataco a ${currentEnemy.name}");

              _attackToEnemy(damage);
              break;

            case "Defensa":
              prompts.add("- Turno ${turnos.toString()}");
              turnos++;
              runAwayMenuDeployed = false;
              skillMenuDeployed = false;

              player.stats["Defensa"] = player.stats["Defensa"]! * 3;

              prompts.add("${player.name} se defiende");
              if (currentEnemy.life > 0) {
                _enemyAttack();
              }

              player.stats["Defensa"] = (player.stats["Defensa"]! / 3).round();
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
    return Stack(
      children: [
        Row(
          children: List.generate(maxLife, (index) {
            return Expanded(
              child: Container(
                color: (index >= life)
                    ? Colors.transparent
                    : ((maxLife / 4) > life)
                    ? Colors.red.shade700
                    : ((maxLife / 2) >= life)
                    ? Colors.orange
                    : Colors.green,
              ),
            );
          }),
        ),

        Center(child: _screenText(life.toString(), 14)),
      ],
    );
  }

  // Magias del Personaje
  GestureDetector _skill(String skillName) {
    Skill skill = player.skills.firstWhere((skill) => skill.name == skillName);
    return GestureDetector(
      onTap: () {
        setState(() {
          prompts.add("- Turno ${turnos.toString()}");
          turnos++;
          if (skill.power != 0) {
            int damage =
                (((player.stats["Ataque Magico"]! + skill.power) * 3) - currentEnemy.defense)
                    .round();

            if (damage < 2) {
              damage = 2;
            }

            prompts.add("${player.name} uso $skillName");

            _attackToEnemy(damage);
          } else {
            switch (skillName) {
              case "Aumentar Ataque":
                if (player.attackBoostTurns == 0 && !player.attackBoost) {
                  player.stats["Ataque"] = player.stats["Ataque"]! * 2;
                  prompts.addAll(["${player.name} uso $skillName",
                  "Su Ataque Aumento!"]);
                  player.attackBoost = true;
                } else {
                  prompts.add("No paso nada");
                }
                break;

              case "Aumentar Defensa":
                if (player.defenseBoostTurns == 0 && !player.defenseBoost) {
                  player.stats["Defensa"] = player.stats["Defensa"]! * 2;
                  prompts.addAll(["${player.name} uso $skillName",
                  "Su Defensa Aumento!"]);
                  player.defenseBoost = true;
                } else {
                  prompts.add("No paso nada");
                }
                break;

              case "Meditar":
                prompts.add("${player.name} uso $skillName");

                if (player.stats["Vida"] == player.stats["Vida Maxima"]) {
                  prompts.add("${player.name} no puede curarse mas");
                } else {
                  int curacion = (player.stats["Vida Maxima"]! / 2).round();

                  if ((player.stats["Vida Maxima"]! - player.stats["Vida"]!) <
                      curacion) {
                    curacion =
                        player.stats["Vida Maxima"]! - player.stats["Vida"]!;

                    player.stats["Vida"] = player.stats["Vida Maxima"]!;
                  } else {
                    player.stats["Vida"] = player.stats["Vida"]! + curacion;
                  }

                  prompts.add("${player.name} se curo $curacion puntos");
                }
            }
            if (currentEnemy.life > 0) {
              _enemyAttack();
            }
          }
          skillMenuDeployed = false;
        });
      },

      onLongPressStart: (_) {
        setState(() {
          skillDetail = skill;
        });
      },

      onLongPressEnd: (_) {
        setState(() {
          skillDetail = null;
        });
      },


      child: Container(
        margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
        child: _screenText("- $skillName", 12),
      ),
    );
  }

  // Ataque enemigo
  void _enemyAttack() {
    int attackIndex = Random().nextInt(currentEnemy.skills.length + 4);
    int damage = 0;

    if (attackIndex >= currentEnemy.skills.length) {
      damage = ((currentEnemy.attack * 5) / player.stats["Defensa"]!).round();
      prompts.add("${currentEnemy.name} ataca a ${player.name}");

      if (damage < 5) {
        damage = 5;
      }

      player.stats["Vida"] = player.stats["Vida"]! - damage;

      prompts.add("Hizo $damage puntos de daño");
    } else {
      Skill skill = currentEnemy.skills.elementAt(attackIndex);

      prompts.add("${currentEnemy.name} uso ${skill.name}");

      if (skill.power != 0) {
        damage =
            (((currentEnemy.attack + skill.power) * 5) /
                    player.stats["Defensa"]!)
                .round();

        if (damage < 5) {
          damage = 5;
        }

        player.stats["Vida"] = player.stats["Vida"]! - damage;
        prompts.add("Hizo $damage puntos de daño");
      } else {
        switch (skill.name) {
          case "Aumentar Ataque":
            if (currentEnemy.attackBoostTurns == 0 &&
                !currentEnemy.attackBoost) {
              currentEnemy.attack = currentEnemy.attack * 2;
              prompts.add("Su Ataque Aumento!");
              currentEnemy.attackBoost = true;
            } else {
              prompts.add("No paso nada");
            }
            break;

          case "Aumentar Defensa":
            if (currentEnemy.defenseBoostTurns == 0 &&
                !currentEnemy.defenseBoost) {
              currentEnemy.defense = currentEnemy.defense * 2;
              prompts.add("Su Defensa Aumento!");
              currentEnemy.defenseBoost = true;
            } else {
              prompts.add("No paso nada");
            }
            break;
        }
      }
    }

    // Navegar si el jugador fue derrotado
    if (player.stats["Vida"]! <= 0) {
      player.stats["Vida"] = 0;
      Navigator.pushNamed(context, "/result", arguments: [player, "Lose"]);
    }

    // Contadores de turnos de los boosts
    //Enemigo
    if (currentEnemy.attackBoost || currentEnemy.defenseBoost) {
      _enemyEndBoostTurn();
    }

    if (player.attackBoost || player.defenseBoost) {
      _playerEndBoostTurn();
    }
  }

  // Atacar a un enemigo
  void _attackToEnemy(int damage) {
    setState(() {
    currentEnemy.life -= damage;
    prompts.add("Hizo $damage puntos de daño");

    if (currentEnemy.life > 0) {
      _enemyAttack();
    }

    // Cambiar de enemigo al derrotarlo
    if (currentEnemy.life <= 0) {
      currentEnemy.life = 0;
      player.levelUp();

      prompts.addAll([
        "${currentEnemy.name} fue derrotado",
        "${player.name} subio de nivel!",
        "",
      ]);

      enemiesDefeated++;

      // Navegar Cuando se acaben los enemigos
      if (enemiesDefeated == enemiesNum) {
        Navigator.pushNamed(context, "/result", arguments: [player, "Win"]);
      }

      currentEnemy = monsters[enemiesDefeated];

      prompts.add("${currentEnemy.name} aparecio!");
    }

    if (enemiesDefeated == enemiesNum - 1) {
      room = "assets/background/in_game/last_room.png";
    }
    });
  }

  // Contador de turnos restantes de boost del enemigo
  void _enemyEndBoostTurn() {
    if (currentEnemy.attackBoost) {
      currentEnemy.attackBoostTurns++;

      if (currentEnemy.attackBoostTurns == 3) {
        currentEnemy.attackBoostTurns = 0;
        currentEnemy.attackBoost = false;
        currentEnemy.attack = (currentEnemy.attack / 2).round();
        prompts.add("El Ataque de ${currentEnemy.name} volvio a la normalidad");
      }
    }

    if (currentEnemy.defenseBoost) {
      currentEnemy.defenseBoostTurns++;

      if (currentEnemy.defenseBoostTurns == 3) {
        currentEnemy.defenseBoostTurns = 0;
        currentEnemy.defenseBoost = false;
        currentEnemy.defense = (currentEnemy.defense / 2).round();
        prompts.add(
          "La Defensa de ${currentEnemy.name} volvio a la normalidad",
        );
      }
    }
  }

  // Contador de turnos restantes de boost del jugador
  void _playerEndBoostTurn() {
    if (player.attackBoost) {
      player.attackBoostTurns++;

      if (player.attackBoostTurns == 3) {
        player.attackBoostTurns = 0;
        player.attackBoost = false;
        player.stats["Ataque"] = (player.stats["Ataque"]! / 2).round();
        prompts.add("El Ataque de ${player.name} volvio a la normalidad");
      }
    }

    if (player.defenseBoost) {
      player.defenseBoostTurns++;

      if (player.defenseBoostTurns == 3) {
        player.defenseBoostTurns = 0;
        player.defenseBoost = false;
        player.stats["Defensa"] = (player.stats["Defensa"]! / 2).round();
        prompts.add(
          "La Defensa de ${player.name} volvio a la normalidad",
        );
      }
    }
  }

  // Texto solo para prompts
  Text _prompt(String text, Key key) {
    return Text(
      text,
      key: key,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
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
