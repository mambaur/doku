import 'package:dompet_apps/models/report-charts.dart';
import 'package:dompet_apps/models/transaction-model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dompet_apps/models/category-model.dart';
import 'dart:io';

class AppsDatabase {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "datadb.db");

    // await deleteDatabase(path);

    const initScript = [
      "CREATE TABLE Category (id INTEGER PRIMARY KEY AUTOINCREMENT, categoryName TEXT, categoryPart TEXT)",
      "CREATE TABLE ReportTransaction (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, balance TEXT, description TEXT, rolecategory TEXT, status TEXT)"
    ];

    const migrationScripts = [
      // do query
    ];

    return await openDatabase(path, version: migrationScripts.length + 1,
        onCreate: (Database db, int version) async {
      Batch batch = db.batch();
      initScript.forEach((script) async {
        batch.execute(script);
      });
      await batch.commit();
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      Batch batch = db.batch();
      migrationScripts.forEach((script) async {
        batch.execute(script);
      });
      await batch.commit();
    });
  }

  Future<int> insertCategory(CategoryModel categoryModel) async {
    final db = await init();
    return db.insert("Category", categoryModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<CategoryModel>> getCategory() async {
    final db = await init();
    final maps = await db.query("Category");

    return List.generate(maps.length, (index) {
      return CategoryModel(
          id: maps[index]['id'],
          categoryName: maps[index]['categoryName'],
          categoryPart: maps[index]['categoryPart']);
    });
  }

  Future<List<CategoryModel>> getCategoryPart(String categoryPart) async {
    final db = await init();
    final maps = await db.query("Category",
        where: "categoryPart = ?", whereArgs: [categoryPart]);

    return List.generate(maps.length, (index) {
      return CategoryModel(
          id: maps[index]['id'],
          categoryName: maps[index]['categoryName'],
          categoryPart: maps[index]['categoryPart']);
    });
  }

  Future<int> deleteCategory(int id) async {
    final db = await init();

    int result = await db.delete("Category", where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> updateCategory(CategoryModel categoryModel, int id) async {
    final db = await init();

    int result = await db.update("Category", categoryModel.toJson(),
        where: "id = ?", whereArgs: [id]);
    return result;
  }

  // ---------------------------- Transaction --------------------------------

  Future<int> insertTransaction(TransactionModel transactionModel) async {
    final db = await init();
    return db.insert("ReportTransaction", transactionModel.toJson(),
    conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> updateReport(TransactionModel data) async {
    final db = await init();
    print('tes 1 = ${data.rolecategory}');

    var getIdCategory = await db.rawQuery(
        "SELECT id FROM Category WHERE categoryName='${data.rolecategory}'");
    print('tes 2 = ${data.rolecategory}');
    Map<String, dynamic> dataUpdate = {'balance' : data.balance, 'description' : data.description, 'rolecategory' : getIdCategory[0]['id']};

    int result = await db.update("ReportTransaction", dataUpdate,
        where: "id = ?", whereArgs: [data.id]);
    return result;
  }

  // Get data transaction
  Future<dynamic> getTransaction() async {
    final db = await init();
    final maps =
        await db.query("ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory ORDER BY ReportTransaction.date DESC");
    return maps;
  }

  Future<dynamic> getTranOrderByDate() async {
    final db = await init();
    var result = await db.rawQuery(
        "SELECT * FROM ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory GROUP BY ReportTransaction.date ORDER BY ReportTransaction.date DESC");
    return result;
  }
  
  Future<dynamic> getTransByDate(String date) async {
    var db = await init();
    var maps = await db.query("Category JOIN ReportTransaction ON ReportTransaction.roleCategory = Category.id",
        where: "date = ?", whereArgs: [date],);
    return maps;
  }
  
  Future<dynamic> getSum(String params) async {
    final db = await init();
    var result = await db.rawQuery(
        "SELECT ReportTransaction.date, SUM(balance) as Total FROM ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory  WHERE categoryPart='$params' GROUP BY ReportTransaction.date ORDER BY ReportTransaction.date DESC");
    return result;
  }

  Future<int> deleteTransaction(int id) async {
    final db = await init();

    int result =
        await db.delete("ReportTransaction", where: "id = ?", whereArgs: [id]);
    return result;
  }
  
  Future<int> deleteTransByDate(String date) async {
    final db = await init();
    int result =
        await db.delete("ReportTransaction", where: "date = ?", whereArgs: [date]);
    return result;
  }


  Future<dynamic> getBalancePemasukan() async {
    final db = await init();
    var result = await db.rawQuery(
        "SELECT SUM(balance) as Total FROM ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory  WHERE categoryPart='Pemasukan'");
    return result;
  }

  Future<dynamic> getBalancePengeluaran() async {
    final db = await init();
    var result = await db.rawQuery(
        "SELECT SUM(balance) as Total FROM ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory  WHERE categoryPart='Pengeluaran'");
    return result;
  }

  Future<dynamic> getBalanceLastTransaction() async {
    final db = await init();
    var result = await db.rawQuery(
        "SELECT * FROM ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory ORDER BY ReportTransaction.id DESC");
    return result;
  }

  Future<dynamic> getPemasukan() async {
    final db = await init();
    var result = await db.rawQuery(
        "SELECT * FROM Category JOIN ReportTransaction ON Category.id=ReportTransaction.rolecategory WHERE categoryPart='Pemasukan' ORDER BY date DESC");
    return result;
  }
  
  Future<dynamic> getPengeluaran() async {
    final db = await init();
    var result = await db.rawQuery(
        "SELECT * FROM Category JOIN ReportTransaction ON Category.id=ReportTransaction.rolecategory WHERE categoryPart='Pengeluaran' ORDER BY date DESC");
    return result;
  }


  // ---------------------------- Transaction Chart --------------------------------

  Future<List<ReportChart>> getReportChartPemasukan() async {
    final db = await init();
    var maps = await db.rawQuery(
        "SELECT * FROM ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory WHERE Category.categoryPart='Pemasukan' GROUP BY date ORDER BY ReportTransaction.date DESC LIMIT 5");
    var sum = await db.rawQuery(
        "SELECT SUM(balance) as Total FROM ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory  WHERE categoryPart='Pemasukan' GROUP BY date ORDER BY ReportTransaction.date DESC LIMIT 5");

    return List.generate(maps.length, (index) {
      return ReportChart(
          maps[index]['date'].substring(maps[index]['date'].length - 5), sum[index]['Total'], Colors.green);
    });
  }
  Future<List<ReportChart>> getReportChartPengeluaran() async {
    final db = await init();
    var maps = await db.rawQuery(
        "SELECT * FROM ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory WHERE Category.categoryPart='Pengeluaran' GROUP BY date ORDER BY ReportTransaction.date DESC LIMIT 5");
    var sum = await db.rawQuery(
        "SELECT SUM(balance) as Total FROM ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory  WHERE categoryPart='Pengeluaran' GROUP BY date ORDER BY ReportTransaction.date DESC LIMIT 5");

    return List.generate(maps.length, (index) {
      return ReportChart(
          maps[index]['date'].substring(maps[index]['date'].length - 5), sum[index]['Total'], Colors.orange);
    });
  }

  Future<dynamic> coba() async{
    final db = await init();
    var sum = await db.rawQuery(
        "SELECT SUM(balance) as Total FROM ReportTransaction JOIN Category ON Category.id=ReportTransaction.rolecategory  WHERE categoryPart='Pengeluaran' GROUP BY date");
    // return sum;
    print(sum);
  }
}
