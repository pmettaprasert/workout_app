class Exercise {
  final String name;
  final int targetOutput;
  final String unit;

  Exercise({
    required this.name,
    required this.targetOutput,
    required this.unit,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {

    final targetValue = json.containsKey('target')
        ? json['target'] as int
        : (json['targetOutput'] != null ? json['targetOutput'] as int : 0);
    return Exercise(
      name: json['name'] as String,
      targetOutput: targetValue,
      unit: json['unit'] as String,
    );
  }
}