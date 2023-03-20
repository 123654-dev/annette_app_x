///Enthält alle Klassen und Stufen, die ausgewählt werden können.
enum ClassId {
  c5A(5),
  c5B(10),
  c5C(15),
  c5D(20),
  c5E(25),
  c6A(30),
  c6B(35),
  c6C(40),
  c6D(45),
  c6F(50),
  c7A(55),
  c7B(60),
  c7C(65),
  c7D(70),
  c7F(75),
  c8A(80),
  c8B(85),
  c8C(90),
  c8D(95),
  c8E(100),
  c9A(105),
  c9B(110),
  c9C(115),
  c9D(120),
  c9E(122),
  EF(127),
  Q1(132),
  Q2(137);

  final int internalID;

  ///[internalID] steht für die interne ID, die WebUntis verwendet.
  ///Warum sie so komisch sind? Gute Frage, nächste Frage.
  const ClassId(this.internalID);
}

///Super-duper-praktische Erweiterung, die die [ClassId]s in Strings und umgekehrt umwandelt.
extension ClassExt on ClassId {
  ///gibt den natürlichen Klassennamen als String zurück (in KLEINBUCHSTABEN).
  String get name {
    switch (this) {
      case ClassId.c5A:
        return '5a';
      case ClassId.c5B:
        return '5b';
      case ClassId.c5C:
        return '5c';
      case ClassId.c5D:
        return '5d';
      case ClassId.c5E:
        return '5e';
      case ClassId.c6A:
        return '6a';
      case ClassId.c6B:
        return '6b';
      case ClassId.c6C:
        return '6c';
      case ClassId.c6D:
        return '6d';
      case ClassId.c6F:
        return '6f';
      case ClassId.c7A:
        return '7a';
      case ClassId.c7B:
        return '7b';
      case ClassId.c7C:
        return '7c';
      case ClassId.c7D:
        return '7d';
      case ClassId.c7F:
        return '7f';
      case ClassId.c8A:
        return '8a';
      case ClassId.c8B:
        return '8b';
      case ClassId.c8C:
        return '8c';
      case ClassId.c8D:
        return '8d';
      case ClassId.c8E:
        return '8e';
      case ClassId.c9A:
        return '9a';
      case ClassId.c9B:
        return '9b';
      case ClassId.c9C:
        return '9c';
      case ClassId.c9D:
        return '9d';
      case ClassId.c9E:
        return '9e';
      case ClassId.EF:
        return 'ef';
      case ClassId.Q1:
        return 'q1';
      case ClassId.Q2:
        return 'q2';
      default:
        return 'unknown';
    }
  }

  ///Parst einen String und gibt die dazugehörige [ClassId] zurück.
  static ClassId fromString({required String key}) {
    switch (key.toUpperCase()) {
      case '5A':
        return ClassId.c5A;
      case '5B':
        return ClassId.c5B;
      case '5C':
        return ClassId.c5C;
      case '5D':
        return ClassId.c5D;
      case '5E':
        return ClassId.c5E;
      case '6A':
        return ClassId.c6A;
      case '6B':
        return ClassId.c6B;
      case '6C':
        return ClassId.c6C;
      case '6D':
        return ClassId.c6D;
      case '6F':
        return ClassId.c6F;
      case '7A':
        return ClassId.c7A;
      case '7B':
        return ClassId.c7B;
      case '7C':
        return ClassId.c7C;
      case '7D':
        return ClassId.c7D;
      case '7F':
        return ClassId.c7F;
      case '8A':
        return ClassId.c8A;
      case '8B':
        return ClassId.c8B;
      case '8C':
        return ClassId.c8C;
      case '8D':
        return ClassId.c8D;
      case '8E':
        return ClassId.c8E;
      case '9A':
        return ClassId.c9A;
      case '9B':
        return ClassId.c9B;
      case '9C':
        return ClassId.c9C;
      case '9D':
        return ClassId.c9D;
      case '9E':
        return ClassId.c9E;
      case 'EF':
        return ClassId.EF;
      case 'Q1':
        return ClassId.Q1;
      case 'Q2':
        return ClassId.Q2;
      default:
        return ClassId.c5A;
    }
  }
}
