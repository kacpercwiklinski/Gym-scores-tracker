abstract class BaseModel {
  int id;

  BaseModel.allArgs(this.id);

  Map<String, dynamic> toMap();
  BaseModel fromMap(Map<String, dynamic> data);
}
