int stateId = 0;
int inputId = 0;

class StateNode {
  late int id;
  late String stringVal;
  List<Transition> transitions = [];

  StateNode.named(String str) {
    id = stateId;
    stringVal = str;
    stateId++;
  }

  StateNode() {
    id = stateId;
    stringVal = id.toString();
    stateId++;
  }

  StateNode.noState() {
    id = stateId;
    stringVal = 'Φ';
    stateId++;
  }

  void applyTransition(StateNode toState, Input inp) {
    transitions.add(Transition.named(toState, inp));
  }
}

class Transition {
  late StateNode nextState;
  late Input input;

  Transition.named(StateNode nextStateA, Input inputA) {
    nextState = nextStateA;
    input = inputA;
  }

  Transition() {
    nextState = noState;
    input = Input();
  }
}

class Input {
  late int id;
  late String stringVal;

  Input.named(String str) {
    id = inputId;
    stringVal = str;
    inputId++;
  }

  Input() {
    id = inputId;
    stringVal = id.toString();
    inputId++;
  }

  static Input epsilon() {
    return Input.named("ε");
  }
}

Input a = Input.named('a');
Input b = Input.named('b');
Input epsilon = Input.epsilon();

StateNode noState = StateNode.noState();

List<Input> inputs = [a, b, epsilon];

Map<String, Input> inputsMap = {
  "a": a,
  "b": b,
  "e": epsilon,
};

class NFA {
  late StateNode startState;
  late StateNode acceptState;
  List<StateNode> allStatesList = [];

  NFA.singleTransition(Input inp) {
    startState = StateNode();
    acceptState = StateNode();
    startState.transitions.add(Transition.named(acceptState, inp));
    allStatesList.addAll([startState, acceptState]);
  }

  NFA.customSingleTransition(this.startState, this.acceptState, Input inp) {
    startState.transitions.add(Transition.named(acceptState, inp));
    allStatesList.addAll([startState, acceptState]);
  }

  NFA() {
    startState = noState;
    acceptState = noState;
  }

  Map<StateNode, Map<Input, List<StateNode>>> generateTransitionTable() {
    var transitionTable = <StateNode, Map<Input, List<StateNode>>>{};

    for (var state in allStatesList) {
      var stateTransitions = <Input, List<StateNode>>{};
      bool isOutputOnInputAEmpty = true;
      bool isOutputOnInputBEmpty = true;
      bool isOutputOnInputeEmpty = true;

      for (var trans in state.transitions) {
        if (trans.input == a) {
          isOutputOnInputAEmpty = false;
        } else if (trans.input == b) {
          isOutputOnInputBEmpty = false;
        } else if (trans.input == epsilon) {
          isOutputOnInputeEmpty = false;
        }
        stateTransitions
            .putIfAbsent(trans.input, () => [])
            .add(trans.nextState);
      }

      if (isOutputOnInputAEmpty) {
        stateTransitions.putIfAbsent(a, () => []).add(noState);
      }
      if (isOutputOnInputBEmpty) {
        stateTransitions.putIfAbsent(b, () => []).add(noState);
      }
      if (isOutputOnInputeEmpty) {
        stateTransitions.putIfAbsent(epsilon, () => []).add(noState);
      }

      transitionTable[state] = stateTransitions;
    }
    return transitionTable;
  }

  void printTansitionTable() {
    var transitionTable = generateTransitionTable();

    print('Start State: ${startState.stringVal}');
    print('Accept State: ${acceptState.stringVal}');

    print(
        '''|----------------|----------------|----------------|----------------|
|     Inputs     |       a        |       b        |       ε        |
|-----States-----|----------------|----------------|----------------|''');

    for (var state in allStatesList) {
      var outputStr = '|       ${state.stringVal.padRight(9)}';

      for (var input in inputs) {
        var nextStateStr = '';

        if (transitionTable[state]![input] != null) {
          nextStateStr =
              transitionTable[state]![input]!.map((s) => s.stringVal).join(' ');
        }

        outputStr += '| ${nextStateStr.padRight(15)}'; // Adjusted padding
      }

      print(outputStr + '|');
      print(
          '|----------------|----------------|----------------|----------------|');
    }
  }
}

NFA unionOperation(NFA nfa1, NFA nfa2) {
  var newStartState = StateNode();
  var newAcceptState = StateNode();

  newStartState.applyTransition(nfa1.startState, epsilon);
  newStartState.applyTransition(nfa2.startState, epsilon);

  nfa1.acceptState.applyTransition(newAcceptState, epsilon);
  nfa2.acceptState.applyTransition(newAcceptState, epsilon);

  var result = NFA();
  result.startState = newStartState;
  result.acceptState = newAcceptState;

  result.allStatesList.add(newStartState);

  result.allStatesList.addAll(nfa1.allStatesList);
  result.allStatesList.addAll(nfa2.allStatesList);

  result.allStatesList.add(newAcceptState);

  return result;
}

NFA kleeneClosure(NFA nfa) {
  var newStartState = StateNode();
  var newAcceptState = StateNode();

  newStartState.applyTransition(nfa.startState, epsilon);
  newStartState.applyTransition(newAcceptState, epsilon);
  nfa.acceptState.applyTransition(newAcceptState, epsilon);
  nfa.acceptState.applyTransition(nfa.startState, epsilon);

  var result = NFA();
  result.startState = newStartState;
  result.acceptState = newAcceptState;

  result.allStatesList.add(newStartState);

  result.allStatesList.addAll(nfa.allStatesList);

  result.allStatesList.add(newAcceptState);

  return result;
}

NFA concatenationOperation(NFA nfa1, NFA nfa2) {
  nfa1.acceptState.transitions = nfa2.startState.transitions;
  nfa1.acceptState.stringVal =
      '(${nfa1.acceptState.stringVal}+${nfa2.startState.stringVal})';

  nfa2.allStatesList.remove(nfa2.startState);
  nfa2.startState = nfa1.acceptState;

  var result = NFA();
  result.startState = nfa1.startState;
  result.acceptState = nfa2.acceptState;

  result.allStatesList.addAll(nfa1.allStatesList);
  result.allStatesList.addAll(nfa2.allStatesList);
  return result;
}

int precedence(String op) {
  switch (op) {
    case '*':
      return 3;
    case '?':
      return 2;
    case '.':
      return 2;
    case '|':
      return 1;
    case '+':
      return 1;
  }
  return 0;
}

String infixToPostfix(String infix) {
  String postfix = "";
  var operators = <String>[];

  for (var c in infix.runes) {
    if (RegExp(r'[a-zA-Z0-9]').hasMatch(String.fromCharCode(c))) {
      postfix += String.fromCharCode(c);
    } else if (String.fromCharCode(c) == '(') {
      operators.add('(');
    } else if (String.fromCharCode(c) == ')') {
      while (operators.isNotEmpty && operators.last != '(') {
        postfix += operators.last;
        operators.removeLast();
      }
      if (operators.isNotEmpty) {
        operators.removeLast();
      }
    } else {
      while (operators.isNotEmpty &&
          precedence(operators.last) >= precedence(String.fromCharCode(c))) {
        postfix += operators.last;
        operators.removeLast();
      }
      operators.add(String.fromCharCode(c));
    }
  }

  while (operators.isNotEmpty) {
    postfix += operators.last;
    operators.removeLast();
  }

  return postfix;
}

NFA solvePostfixExpression(String postFix) {
  var nfas = <NFA>[];

  for (var c in postFix.runes) {
    if (RegExp(r'[a-zA-Z0-9]').hasMatch(String.fromCharCode(c))) {
      var tempInput = inputsMap[String.fromCharCode(c)];
      var tempNFA = NFA.singleTransition(tempInput!);
      nfas.add(tempNFA);
    } else if (String.fromCharCode(c) == '+' ||
        String.fromCharCode(c) == '|') {
      var poppedNFA2 = nfas.last;
      nfas.removeLast();
      var poppedNFA1 = nfas.last;
      nfas.removeLast();
      var resultNFA = unionOperation(poppedNFA1, poppedNFA2);
      nfas.add(resultNFA);
    } else if (String.fromCharCode(c) == '*') {
      var poppedNFA = nfas.last;
      nfas.removeLast();
      var resultNFA = kleeneClosure(poppedNFA);
      nfas.add(resultNFA);
    } else if (String.fromCharCode(c) == '.' ||
        String.fromCharCode(c) == '?') {
      var poppedNFA2 = nfas.last;
      nfas.removeLast();
      var poppedNFA1 = nfas.last;
      nfas.removeLast();
      var resultNFA = concatenationOperation(poppedNFA1, poppedNFA2);
      nfas.add(resultNFA);
    }
  }

  // now nfas stack is empty
  var ansNFA = nfas.last;
  nfas.removeLast();

  return ansNFA;
}

