class TransactionModel {
  int id, balance;
  String date, description, status, rolecategory;

  TransactionModel({this.id, this.rolecategory, this.date, this.balance, this.description, this.status});

  TransactionModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    date = json['date'];
    balance = json['balance'];
    description = json['description'];
    rolecategory = json['rolecategory'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['balance'] = this.balance;
    data['description'] = this.description;
    data['rolecategory'] = this.rolecategory;
    data['status'] = this.status;
    return data;
  }
}