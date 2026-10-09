class Medicine {
  final String id;
  final String name;
  final String dose;
  final String frequency; // e.g., "Twice daily", "Once daily", "8 Hourly"
  final String duration; // e.g., "5 Days", "10 Days", "Ongoing"
  final String mealTiming; // e.g., "After Meal", "Before Meal"
  final String instructions;
  final String? visitId;
  final String? doctorName;
  final DateTime? prescribedDate;

  Medicine({
    required this.id,
    required this.name,
    required this.dose,
    required this.frequency,
    required this.duration,
    required this.mealTiming,
    required this.instructions,
    this.visitId,
    this.doctorName,
    this.prescribedDate,
  });

  Medicine copyWith({
    String? id,
    String? name,
    String? dose,
    String? frequency,
    String? duration,
    String? mealTiming,
    String? instructions,
    String? visitId,
    String? doctorName,
    DateTime? prescribedDate,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      mealTiming: mealTiming ?? this.mealTiming,
      instructions: instructions ?? this.instructions,
      visitId: visitId ?? this.visitId,
      doctorName: doctorName ?? this.doctorName,
      prescribedDate: prescribedDate ?? this.prescribedDate,
    );
  }
}
