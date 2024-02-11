import 'dart:convert';

import 'package:brainvire_test/Utils/dbprovider.dart';
import 'package:brainvire_test/model/productModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductController extends ChangeNotifier {
  ProductController();
  List<ProductsDetail> productList = [];

/*
  getProductList 
  this function will fetch product from Restful API and stored it in localDB and updated it on UI
*/
  Future<void> getProductList() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products'),
    );
    if (response.statusCode == 200) {
      var model = ProductModel.fromJson(json.decode(response.body));
      productList.addAll(model.products!);
      // notify UI to upate product list
      notifyListeners();
      // sync new Products to localDB if any
      syncToLocalDB();
    }
  }

  // fetch products from local db And Update UI
  getLocalProductList() async {
    productList = await DBProvider.db.getProductList();
    notifyListeners();
  }

/*
  syncToLocalDB 
  this function will check that is currentl item in list is stored in local db or not 
  and based on that it will insert product to db or udpate current product in db 

*/
  syncToLocalDB() {
    productList.forEach((element) async {
      var isAvailable =
          await DBProvider.db.checkIsProductAvailable(element.id!);
      if (!isAvailable) {
        // insert product TO DB
        await DBProvider.db.insertProduct(element);
      } else {
        // updated product TO DB
        await DBProvider.db.updateProduct(element);
      }
    });
  }

  // updating product in local database
  updateProduct(ProductsDetail updatedProduct) async {
    await DBProvider.db.updateProduct(updatedProduct);
    // getting index of current product in product list based on product id
    final index =
        productList.indexWhere((product) => product.id == updatedProduct.id);
    //replacing product in product list without database qury
    productList[index] = updatedProduct;
    // notify UI to upate product list
    notifyListeners();
  }
}
