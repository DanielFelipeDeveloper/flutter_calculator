class Calculator {
  final bool shouldAppend;
  final bool canAddPoint;
  final String equation;
  final String result;

  const Calculator({
    this.shouldAppend = true,
    this.canAddPoint = true,
    this.equation = '0',
    this.result = '0',
  });

  Calculator copy({
    bool shouldAppend,
    bool canAddPoint,
    String equation,
    String result,
  }) => Calculator(
    shouldAppend: shouldAppend ?? this.shouldAppend,
    canAddPoint: canAddPoint ?? this.canAddPoint,
    equation: equation ?? this.equation,
    result: result ?? this.result,
  );
}