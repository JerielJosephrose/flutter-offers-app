/*
* Class containing all the categories
*
* */


class Categories {
  int id;
  int id_parent_class;
  String label;

  Categories({this.id, this.id_parent_class, this.label});

  //transforms a json into an object of type Categories
  factory Categories.fromJson(Map<String, dynamic> Json) {
    return Categories(
      id: Json['id'],
      id_parent_class: Json['name'],
      label: Json['label'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_parent_class": id_parent_class,
        "label": label,
      };
}
