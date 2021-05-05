class Exercise {
  final int id;
  final String name;
  static final columns = ["id", "name"];

  Exercise(this.id, this.name);

  factory Exercise.fromMap(Map<String, dynamic> data) {
    return Exercise(data['id'], data['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}