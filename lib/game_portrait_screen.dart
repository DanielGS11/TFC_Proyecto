import 'package:flutter/material.dart';
import 'package:prueba_1/models/character.dart';

class GamePortraitScreen extends StatefulWidget {
  const GamePortraitScreen({super.key});

  @override
  State<GamePortraitScreen> createState() => _GamePortraitScreenState();
}

class _GamePortraitScreenState extends State<GamePortraitScreen> {
  final _formKey = GlobalKey<FormState>();

  String playerName = "";
  int enemiesNumber = 1;
  bool classSelected = true;
  CharacterClass? playerClass;

  Map<CharacterClass, bool> classes = {
    for (int i = 0; i < CharacterClass.values.length; i++)
      CharacterClass.values[i]: false,
  };

  int filasClases = 0;
  bool elementosImpares = false;

  @override
  Widget build(BuildContext context) {
    if ((classes.length % 2) != 0) {
      elementosImpares = true;
      filasClases = (classes.length / 2).round();
    } else {
      filasClases = (classes.length / 2).round();
    }

    // Aqui pillo la altura de pantalla para poner porcentajes de altura
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Para evitar problemas de overflow con el teclado del movil
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Stack(
          children: [
            // Fondo
            Positioned.fill(
              child: Image.asset(
                "assets/background/portrait/portrait_background.png",
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(
              // 100%
              height: screenHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/title/title.png",
                      height: 200,
                      width: 400,
                    ),
                  ),

                  SizedBox(
                    // 55%
                    height: screenHeight * 0.55,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: _playerData(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Spacer(),

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: _playButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------- MODULOS ---------------------------------
  // Formulario
  Form _playerData() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _screenText("Introduzca el nombre de su personaje", 17),
          Divider(height: 5, color: Colors.transparent),

          Container(
            height: 70,
            width: 300,
            color: Color.fromRGBO(0, 0, 0, 0.6),
            child: _playerNameField(),
          ),

          Divider(height: 40, color: Colors.transparent),
          _screenText("Introduzca el numero de enemigos", 17),

          Divider(height: 5, color: Colors.transparent),
          _enemiesNumForm(),

          Divider(height: 40, color: Colors.transparent),
          _screenText("Elija la clase de su personaje", 17),

          Divider(height: 5, color: Colors.transparent),
          _playerClass(),
          Text(
            classSelected ? "" : "Selecciona una clase",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
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

  // Campo de texto del nombre de Usuario
  TextFormField _playerNameField() {
    return TextFormField(
      onChanged: (value) => playerName = value.toString(),

      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),

        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),

        labelText: "Nombre del Personaje",
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
        ),
      ),

      keyboardType: TextInputType.text,

      style: TextStyle(color: Colors.white),

      validator: (value) {
        if (value!.isEmpty) {
          return "Este Campo no Puede Estar Vacio";
        }
        return null;
      },
    );
  }

  // Formulario de numero de enemigos
  Container _enemiesNumForm() {
    return Container(
      height: 40,
      width: 80,
      color: Color.fromRGBO(0, 0, 0, 0.6),

      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: _screenText(enemiesNumber.toString(), 22),
              ),
            ),
          ),

          Expanded(flex: 2, child: _numEnemiesButtons()),
        ],
      ),
    );
  }

  // Botones para ajustar el numero de enemigos
  Column _numEnemiesButtons() {
    return Column(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (enemiesNumber < 5) {
                  enemiesNumber++;
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Icon(Icons.arrow_drop_up),
          ),
        ),

        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (enemiesNumber > 1) {
                  enemiesNumber--;
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(0, 0, 0, 100),
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }

  // Clases de Personaje
  SizedBox _playerClass() {
    return SizedBox(
      child: Column(
        children: List.generate(filasClases, (index) {
          int cursorLista = index * 2;
          Row fila = Row();

          if (index + 1 == filasClases && elementosImpares) {
            fila = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_classContainer(classes.keys.toList()[cursorLista])],
            );
          } else {
            fila = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _classContainer(classes.keys.toList()[cursorLista]),
                _classContainer(classes.keys.toList()[cursorLista + 1]),
              ],
            );
          }

          return fila;
        }),
      ),
    );
  }

  // Casillas de Clases de Personaje
  GestureDetector _classContainer(CharacterClass characterClass) {
    Color? classColor;
    String className = "";

    switch (characterClass) {
      case CharacterClass.Cleric:
        classColor = Color.fromRGBO(191, 222, 245, 0.6);
        className = "Clerigo";
        break;
      case CharacterClass.Mage:
        classColor = Color.fromRGBO(232, 191, 245, 0.6);
        className = "Mago";
        break;
      case CharacterClass.Tank:
        classColor = Color.fromRGBO(102, 89, 247, 0.6);
        className = "Tanque";
        break;
      case CharacterClass.Warrior:
        classColor = Color.fromRGBO(255, 51, 51, 0.6);
        className = "Guerrero";
        break;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          classes.updateAll((key, value) => value = false);
          classes[characterClass] = true;
          playerClass = characterClass;
          classSelected = true;
        });
      },

      child: Container(
        margin: EdgeInsets.all(5),
        height: 50,
        width: 150,

        decoration: BoxDecoration(
          shape: BoxShape.rectangle,

          color: classColor,

          border: Border.all(
            color: classes[characterClass]! ? Colors.deepOrange : Colors.black,
            width: 1.5,
          ),
        ),

        child: Center(child: _screenText(className, 17)),
      ),
    );
  }

  // Boton para empezar el juego
  ElevatedButton _playButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (classes.values.any((value) => value)) {
          } else {
            classSelected = false;
          }

          if (_formKey.currentState!.validate() && classSelected) {
            Character player = Character(playerName, playerClass!);

            Navigator.pushNamed(
              context,
              "/in_game",
              arguments: [player, enemiesNumber],
            );
          }
        });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        backgroundColor: Colors.deepPurpleAccent,
        maximumSize: Size(100, 40),
      ),
      child: _screenText("Jugar", 17),
    );
  }
}
