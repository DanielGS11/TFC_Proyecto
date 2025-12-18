import 'package:prueba_1/models/Skill.dart';

List<Skill> skillList = [
  Skill("Fuego", 10, "Convoca una bola de fuego\npara atacar"),

  Skill("Agua", 10, "Convoca un chorro de agua\npara atacar"),

  Skill("Viento", 10, "Convoca una rafaga debil\nde viento para atacar"),

  Skill("Tierra", 10, "Convoca una una espina\nde tierra para atacar"),

  Skill("Luz Sagrada", 13, "Convoca un rayo de\nluz celestial para atacar"),

  Skill(
    "Aumentar Defensa",
    0,
    "Concentra mana para reforzar su\ndefensa y aguantar los golpes\nDuracion: 2 Turnos",
  ),

  Skill(
    "Aumentar Ataque",
    0,
    "Concentra mana para reforzar su\nataque y volverse mas letal\nDuracion: 2 Turnos",
  ),

  Skill("Meditar", 0, "Concentra su\nenergia y mana para curar sus heridas"),

  Skill(
    "Aliento Igneo",
    20,
    "Expulsa un aliento abrasador para\ndañar a su objetivo",
  ),

  Skill(
    "Temblor",
    17,
    "Usa toda su fuerza para hacer temblar\nla tierra y dañar a su objetivo",
  ),

  Skill("Aqua Garra", 15, "Imbuye sus garras\nen magia de agua para atacar"),

  Skill("Garra Ignea", 15, "Imbuye sus garras\nen magia de fuego para atacar"),
];
