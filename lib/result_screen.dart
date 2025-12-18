import 'package:flutter/material.dart';

import 'models/character.dart';
/*
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}
 */

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<dynamic> matchData =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    Character player = matchData.first;
    String result = matchData.last;

    // Aqui pillo la altura de pantalla para poner porcentajes de altura
    double screenHeight = MediaQuery.of(context).size.height;

    // Aqui pillo la anchura de pantalla para poner porcentajes de anchura
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              (result == "Run Away")
                  ? "assets/background/result/run_away.png"
                  : (result == "Win")
                  ? "assets/background/result/winner_room.png"
                  : "assets/background/result/loser_room.png",
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              height: screenHeight * 0.8,
              width: screenWidth * 0.8,
              color: Color.fromRGBO(0, 0, 0, 0.5),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: (result == "Run Away")
                          ? Text(
                              "Has Huido",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                                fontSize: 40,
                              ),
                            )
                          : (result == "Win")
                          ? Text(
                              "Has Ganado!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow.shade700,
                                fontSize: 40,
                              ),
                            )
                          : Text(
                              "Has Perdido",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                fontSize: 40,
                              ),
                            ),
                    ),
                  ),

                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: ListView(
                        children: List.generate(player.characterStats.length, (
                          index,
                        ) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      
                            child: _screenText(player.characterStats[index], 20),
                          );
                        }),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/portrait");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: EdgeInsets.all(0),
                      fixedSize: Size(110, 30),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: _screenText("Jugar de Nuevo", 13),
                  ),
                ],
              ),
            ),
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
}
