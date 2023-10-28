import 'dart:io';
import 'dart:math';

import 'package:main/dice.dart';


main() async {

  const String nameGame = "Super Jogo de Dados";

  cleanConsole();
  showNameGame(nameGame);

  bool hadUsedMagicDice = false;
  bool magicDiceResult = false;

  int rounds = inputRoundsToPlay();

  int playerVictories = 0;
  int computerVictories = 0;
  int draws = 0;

  for(int i = 1; i <= rounds; i++){

    bool useMagicDice = false;
    
    cleanConsole();

    showNameGame(nameGame);
    showPoints(playerVictories, computerVictories, draws);

    print("\n${"-" * 3} Rodada $i de $rounds ${"-" * 3}\n");

    if(!hadUsedMagicDice){
      useMagicDice = inputUseMagicDice();
      
      if(useMagicDice){
        print("Lançando dado mágico...");
        await Future.delayed(Duration(seconds: 2));
        magicDiceResult = Random().nextBool();
        
        if(magicDiceResult){
          print("SEUS DADOS SERÃO MULTIPLICADOS POR 2!\n");
        }
        else{
          print("SEUS DADOS SERÃO DIVIDIDOS POR 2!\n");
        }
      } 
    }

    List<Dice> playersDices = createDices(3);
    List<Dice> computerDices = createDices(3);

    print("Lançando dados do jogador...");
    await Future.delayed(Duration(seconds: 2));
    playersDices = throwDices(playersDices);
    showDices(playersDices);

    if(useMagicDice){
      hadUsedMagicDice = true;
      if(magicDiceResult){
        print("Multiplicando seus dados por 2...");
        for(Dice dado in playersDices){
          dado.face *= 2;
        }
      }
      else{
        print("Dividindo seus dados por 2...");
        for(Dice dado in playersDices){
          dado.face = (dado.face / 2).round();
        }
      }
      showDices(playersDices);
    }
    
    print("\n");

    print("Lançando dados do computador...");
    await Future.delayed(Duration(seconds: 2));
    computerDices = throwDices(computerDices);
    showDices(computerDices);
    print("\n");

    int sumPlayersDices =  sumDices(playersDices);
    int sumComputerDices = sumDices(computerDices);

    if(sumPlayersDices > sumComputerDices){
      print("Jogador VENCEU!");
      playerVictories++;
    }
    else if(sumPlayersDices < sumComputerDices){
      print("Computador venceu!");
      computerVictories++;
    }
    else{
      print("Empate!");
      draws++;
    }

    print("\nRecolhendo os dados...\n");
    await Future.delayed(Duration(seconds: 2));
  }

  cleanConsole();
  showNameGame(nameGame);
  showFinalPoints(playerVictories, computerVictories, draws);

}

void showFinalPoints(int playerVictories, int computerVictories, int draws) {
  print("=== PLACAR FINAL ===\n");
  showPoints(playerVictories, computerVictories, draws);
  print("\n====================\n");
  
  if(playerVictories > computerVictories){
    print("Jogador VENCEU!");
  }
  else if(playerVictories < computerVictories){
    print("Computador venceu!");
  }
  else{
    print("Empate!");
  }
}

bool inputUseMagicDice(){
  bool useMagicDice = false;
  bool useMagicDiceIsValid = false;

  while(!useMagicDiceIsValid){
    print("Você tem um dado mágico! Deseja usa-lo? (s/n): ");
    String input = stdin.readLineSync() ?? "";
    if(input.toLowerCase() == "s"){
      useMagicDice = true;
      useMagicDiceIsValid = true;
      print("Você usou o dado mágico!");
    }
    else if(input.toLowerCase() == "n"){
      useMagicDice = false;
      useMagicDiceIsValid = true;
      print("Você não usou o dado mágico!");
    }
    else{
      print("Opção inválida!");
      useMagicDiceIsValid = false;
    }
  }
  print("\n");
  return useMagicDice;
}

void cleanConsole(){
  if(Platform.isWindows){
    print(Process.runSync("cls", [], runInShell: true).stdout);
  }
  else{
    print(Process.runSync("clear", [], runInShell: true).stdout);
  }
}

void showPoints(int playerVictories, int computerVictories, int draws){

  int numberOfCharacters = " Você: $playerVictories x $computerVictories CPU ".length;
  int drawPadding = ((numberOfCharacters - "Empates: $draws".length) / 2).round();

  print("-" * numberOfCharacters);
  print(" Você: $playerVictories x $computerVictories CPU  ");
  print("${" " * drawPadding}Empates: $draws${" " * drawPadding}");
  print("-" * numberOfCharacters);
}

void showDices(List<Dice> dices){
  List<String> dicesFaces = [];

  for(Dice dado in dices){
    dicesFaces.add(dado.face.toString());
  }
  print("Dados: ${dicesFaces.join(" - ")}");
  print("Soma ${sumDices(dices)}");

}

List<Dice> throwDices(List<Dice> dices){
  for(Dice dado in dices){
    dado.throwDice();
  }
  return dices;
}

List<Dice> createDices(int number){

  List<Dice> dices = [];
  for(int i = 0; i < number; i++){
    dices.add(Dice());
  }
  return dices;
}

int inputRoundsToPlay(){
  int rounds = 0;
  bool roundsIsValid = false;

  while(!roundsIsValid){
    print("Informe quantas rodadas deseja jogar: ");

    try{
      String input = stdin.readLineSync() ?? "";
      rounds = int.parse(input);
      if(rounds > 0){
        roundsIsValid = true;
      }
      else{
        print("O número de rodadas deve ser maior que zero.");
      }
    }
    catch(e){
      print("O número de rodadas deve ser um número inteiro.");
      roundsIsValid = false;
    }
  }
  return rounds;
}

void showNameGame(String nameGame){
  const int nameGameFactor = 2;

  final String spacePadding = " " * (nameGame.length / nameGameFactor).round();
  final nameGameToShow = "$spacePadding$nameGame$spacePadding".toUpperCase();

  print("=" * nameGame.length * nameGameFactor);
  print(nameGameToShow);
  print("=" * nameGame.length * nameGameFactor);
  print("\n");
}

int sumDices(List<Dice> dados){
  int soma = 0;
  for(Dice dado in dados){
    soma += dado.face;
  }
  return soma;
}