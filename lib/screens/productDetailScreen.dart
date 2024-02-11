import 'package:brainvire_test/Utils/dbprovider.dart';
import 'package:brainvire_test/common/consts/const.dart';
import 'package:brainvire_test/common/widgets/productTextField.dart';
import 'package:brainvire_test/model/productModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../providers/productController.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final ProductsDetail product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var priceController = TextEditingController();
  var stockController = TextEditingController();
  var brandController = TextEditingController();
  var categoryController = TextEditingController();
  var productRating = 0.0;
  bool isEditable = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.product.title!;
    descriptionController.text = widget.product.description!;
    priceController.text = widget.product.price.toString();
    stockController.text = widget.product.stock.toString();
    brandController.text = widget.product.brand!;
    categoryController.text = widget.product.category!;
    productRating = widget.product.rating!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.product.title!),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => setState(() {
                isEditable = !isEditable;
              }),
              child: const Icon(Icons.edit),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    /// product image
                    Image.network(
                      widget.product.thumbnail!,
                      errorBuilder: (context, error, stackTrace) {
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlutterLogo(),
                            Text(
                              "Unable Load Image",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // product rating bar
                    RatingBar.builder(
                      initialRating: productRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: !isEditable,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        productRating = rating;
                      },
                    ),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // product Title TextField
                          ProductTextField(
                            controller: titleController,
                            isEditable: isEditable,
                            TextFieldType: textFieldTypeText,
                            hint: 'Title',
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          ProductTextField(
                            controller: descriptionController,
                            isEditable: isEditable,
                            TextFieldType: textFieldTypeText,
                            hint: 'Description',
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          ProductTextField(
                            controller: priceController,
                            isEditable: isEditable,
                            TextFieldType: textFieldTypeDouble,
                            hint: 'Price',
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          ProductTextField(
                            controller: stockController,
                            isEditable: isEditable,
                            TextFieldType: textFieldTypeDouble,
                            hint: 'Stock',
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          ProductTextField(
                            controller: brandController,
                            isEditable: isEditable,
                            TextFieldType: textFieldTypeText,
                            hint: 'Brand',
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          ProductTextField(
                            controller: categoryController,
                            isEditable: isEditable,
                            TextFieldType: textFieldTypeText,
                            hint: 'Category',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (isEditable) {
                  if (_formKey.currentState!.validate()) {
                    widget.product.title = titleController.text;
                    widget.product.description = descriptionController.text;
                    widget.product.stock = int.tryParse(stockController.text) ??
                        widget.product.stock;
                    widget.product.price = int.tryParse(priceController.text) ??
                        widget.product.price;
                    widget.product.category = categoryController.text;
                    widget.product.brand = brandController.text;
                    widget.product.rating = productRating;
                    widget.product.updatedAt =
                        DateTime.now().millisecondsSinceEpoch;

                    saveProduct();
                  }
                } else {
                  /* setState(() {
                    isEditable = true;
                  }); */
                }
              },
              child: Text(
                'Save',
                style:
                    TextStyle(color: isEditable ? Colors.black : Colors.grey),
              ))
        ],
      ),
    );
  }

  // saving product to local Db
  saveProduct() async {
    Provider.of<ProductController>(context, listen: false)
        .updateProduct(widget.product);

    // navigating bact to product List Screen on prouct save success
    Navigator.pop(context);
  }
}
