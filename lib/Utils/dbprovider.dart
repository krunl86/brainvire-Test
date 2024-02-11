import 'dart:io';
import 'dart:async';

import 'package:brainvire_test/model/productModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), "brainvire.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onUpgrade: (db, oldVersion, newVersion) async {
      dropTable(db);
      onCreateDb(db);
    }, onCreate: (Database db, int version) async {
      onCreateDb(db);
    });
  }

//  droping current table on database upgrade
  dropTable(Database db) {
    db.execute("DROP TABLE IF EXISTS Products");
  }

// raw qery to create products table in database
  onCreateDb(Database db) async {
    await db.execute("CREATE TABLE Products ("
        "id INTEGER PRIMARY KEY,"
        "title TEXT,"
        "description TEXT,"
        "price INTEGER,"
        "rating REAL,"
        "stock INTEGER,"
        "brand TEXT,"
        "category TEXT,"
        "thumbnail TEXT,"
        "updatedAt INTEGER"
        ")");
  }

  insertProduct(ProductsDetail product) async {
    // getting instand of db
    final db = await database;
    // raw query to insert field is database
    var raw = await db.rawInsert(
        "INSERT Into Products (id,title,description,price,rating,stock,brand,category,thumbnail,updatedAt)"
        " VALUES (?,?,?,?,?,?,?,?,?,?)",
        [
          product.id,
          product.title,
          product.description,
          product.price,
          product.rating,
          product.stock,
          product.brand,
          product.category,
          product.thumbnail,
          product.updatedAt,
        ]);

    return raw;
  }

  updateProduct(ProductsDetail master) async {
    final db = await database;
    // updating product based on product id stored in local db
    var raw = await db.rawInsert('''UPDATE  Products SET 
    title = ? ,
    description = ?,
    price = ?,
    rating  = ?,   
    stock =?,
    brand =?,
    category =?,
    updatedAt =?
    WHERE id = ?   
    ''', [
      master.title,
      master.description,
      master.price,
      master.rating,
      master.stock,
      master.brand,
      master.category,
      master.updatedAt,
      master.id,
    ]);

    return raw;
  }

  Future<List<ProductsDetail>> getProductList() async {
    final db = await database;
    // fetching all item from local db.
    var res = await db.rawQuery('''select * from Products ''', []);
    try {
      // returngin list of product from raw query
      List<ProductsDetail> list = res.isNotEmpty
          ? res.map((c) => ProductsDetail.fromJson(c)).toList()
          : [];
      return list;
    } catch (e) {
      print(e);
      return [];
    }
  }

  /// checking is given id is stored in local db or not
  checkIsProductAvailable(int id) async {
    final db = await database;
    var res =
        await db.rawQuery('''SELECT * FROM Products WHERE id = ?  ''', [id]);

    int count = res.length;
    // returning true or false based on produc count stored in db
    return count == 0 ? false : true;
  }
}
