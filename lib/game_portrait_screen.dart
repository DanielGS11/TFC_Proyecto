import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba_1/data/character_Data.dart';

class GamePortraitScreen extends StatefulWidget {
  const GamePortraitScreen({super.key});

  @override
  State<GamePortraitScreen> createState() => _GamePortraitScreenState();
}

class _GamePortraitScreenState extends State<GamePortraitScreen> {
  var _formKey = GlobalKey<FormState>();

  String playerName = "";
  int enemiesNumber = 1;
  var playerClass = "";
  bool classSelected = true;

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

      body: Stack(
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
                    child: Image.asset("assets/title/title.png", height: 200, width: 400)),

                SizedBox(
                  // 55%
                  height: screenHeight * 0.55,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: _playerData()),
                      ],
                    ),
                  ),
                ),

                Spacer(),

                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: _playButton()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------- MODULOS ---------------------------------
  Form _playerData() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _formText("Introduzca el nombre de su Personaje"),
          Divider(height: 5, color: Colors.transparent),

          Container(
            height: 70,
            width: 300,
            color: Color.fromRGBO(0, 0, 0, 0.6),
            child: _playerNameField(),
          ),

          Divider(height: 40, color: Colors.transparent),
          _formText("Introduzca el Numero de Enemigos"),

          Divider(height: 5, color: Colors.transparent),
          _enemiesNumForm(),

          Divider(height: 40, color: Colors.transparent),
          _formText("Elija la clase de su Personaje"),

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

  Text _formText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    );
  }

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

  Container _enemiesNumForm() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      height: 40,
      width: 100,
      color: Color.fromRGBO(0, 0, 0, 0.6),

      child: Row(
        children: [
          Expanded(flex: 5, child: _formText(enemiesNumber.toString())),

          Expanded(flex: 2, child: _numEnemiesButtons()),
        ],
      ),
    );
  }

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

  SizedBox _playerClass() {
    return SizedBox(
      child: Column(
        children: List.generate(filasClases, (index) {
          int cursorLista = index * 2;
          Row fila = Row();

          if (index + 1 == filasClases && elementosImpares) {
            fila = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _classContainer(classes.keys.toList()[cursorLista]),

              ],
            );
          } else {
            fila = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _classContainer(classes.keys.toList()[cursorLista]),
                _classContainer(classes.keys.toList()[cursorLista + 1])
              ],
            );
          }

          return fila;
        }),
      )
    );
  }

  GestureDetector _classContainer(CharacterClass characterClass) {
    Color? classColor = null;
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

        child: Center(child: _formText(className)),
      ),
    );
  }

  ElevatedButton _playButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (classes.values.any((value) => value)) {
          } else {
            classSelected = false;
          }

          if (_formKey.currentState!.validate() && classSelected) {}
        });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        backgroundColor: Colors.deepPurpleAccent,
        maximumSize: Size(100, 40)
      ),
      child: _formText("Jugar"),
    );
  }
}
