// product Tile Widget
import 'package:brainvire_test/model/productModel.dart';
import 'package:brainvire_test/screens/productDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});
  final ProductsDetail product;

  @override
  Widget build(BuildContext context) {
    // converting timeStamp To string
    var dateTime = DateFormat('MM/dd/yyyy hh:mm:ss').format(
      DateTime.fromMillisecondsSinceEpoch(product.updatedAt!),
    );
    return GestureDetector(
      // navigating to detail screen with product object
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
                  product: product,
                )),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            color: Colors.black,
          ),
        ),
        elevation: 16,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // product image widget
              /*  SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    product.thumbnail!,
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
                  )),
              const SizedBox(
                width: 10,
              ), */

              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Product ID : ${product.id!.toString()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // product title
                      Text(
                        product.title!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // product description
                      Text(product.description!),

                      // update time stamp
                      Text('Last Updated Date : $dateTime',
                          textAlign: TextAlign.end)
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
