import 'package:flutter_calculator/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_calculator/model/calculator.dart';

final calculatorProvider = StateNotifierProvider<CalculatorNotifier>((ref) => CalculatorNotifier());

class CalculatorNotifier extends StateNotifier<Calculator> {
  CalculatorNotifier() : super(Calculator());

  void delete() {
    final equation = state.equation;

    if (equation.isNotEmpty) {
      if (equation.substring(equation.length -1, equation.length) == '.') {
        state = state.copy(canAddPoint: true);
      } else if (Utils.isOperator(equation.substring(equation.length -1, equation.length))) {
        final values = state.equation.split(RegExp(r"([*+\/-]+|[A-Za-z]+)"));

        if (values[values.length -2].contains('.')) {
          state = state.copy(canAddPoint: false);
        } 
      }
      
      final newEquation = equation.substring(0, equation.length -1);

      if (newEquation.isEmpty) {
        reset();
      } else {
        state = state.copy(equation: newEquation);
        calculate();
      }
    }
  }

  void reset() {
    const equation = '0';
    const result = '0';

    state = state.copy(equation: equation, result: result);
  }

  void resetResult() {
    final equation = state.result;

    state = state.copy(
      equation: equation,
      shouldAppend: false,
    );
  }

  void append(String buttonText) {
    final equation = () {
      if (Utils.isOperator(buttonText) && Utils.isOperatorAtEnd(state.equation)) {
        print('test1');
        final newEquation = state.equation.substring(0, state.equation.length -1);
        
        return newEquation + buttonText;
      } else if (Utils.isOperator(buttonText)) {
        print('test2');
        state = state.copy(canAddPoint: true);

        return state.equation == '0' ? buttonText : state.equation + buttonText;
      } else if (state.shouldAppend) {
        print('test3');
        return state.equation == '0' ? buttonText : state.equation + buttonText;
      } else {
        print('test4');
        return Utils.isOperator(buttonText) ? state.equation + buttonText : buttonText;
      }
    }();

    state = state.copy(equation: equation, shouldAppend: true);
    calculate();
  }

  void equals() {
    calculate();
    resetResult();
  }

  void validatePoint() {
    if (state.canAddPoint && !Utils.isOperatorAtEnd(state.equation)) {
      state = state.copy(equation: state.equation + '.', canAddPoint: false);
    }
  }

  void calculate() {
    final expression = state.equation.replaceAll('x', '*').replaceAll('÷', '/');

    try {
      final exp = Parser().parse(expression);
      final model = ContextModel();

      final result = '${exp.evaluate(EvaluationType.REAL, model)}';
      state = state.copy(result: result);
    } catch (err) {
      
    }
  }
}