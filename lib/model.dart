
class Robot {
  final bool induct_1;
  final bool induct_2;
  final String location;

  const Robot({
    required this.induct_1,
    required this.induct_2,
    required this.location,
  });

  factory Robot.fromJson(Map<String, dynamic> json) {
    return Robot(
      induct_1: json['induct_1'] as bool,
      induct_2: json['induct_2'] as bool,
     location: json['Location'] as String,
    );
  }
}