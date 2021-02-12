
class CategoryModel {
  int id;
  String categoryName;
  String categoryPart;

  CategoryModel({this.id, this.categoryName, this.categoryPart});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    categoryPart = json['categoryPart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['categoryPart'] = this.categoryPart;
    return data;
  }
}