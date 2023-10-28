import 'dart:math';

class Dice {

  late int face;

  Dice(){
    this.face = 1;
  }

  void throwDice() {
    this.face = Random().nextInt(6) + 1;
  }

}