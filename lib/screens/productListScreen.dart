import 'package:brainvire_test/common/widgets/productTile.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/productController.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key, required this.title});

  final String title;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool isNetworkAvailable = false;
  @override
  void initState() {
    // function to check netowrk connectivity
    checkIsNetworkAvailable();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appbar with title and one Option button
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Appbar title
          title: Text(widget.title),
          actions: [
            // refresh action button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    // getting list from local database
                    Provider.of<ProductController>(context, listen: false)
                        .getLocalProductList();
                  },
                  child: const Icon(Icons.refresh)),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // consumer widget to update UI as per notify from provider
              Consumer<ProductController>(builder: (_, controller, child) {
                // if network is available and list is empty show progress bar
                if (isNetworkAvailable && controller.productList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // if network is not available and list is empty load local list
                else if (!isNetworkAvailable &&
                    controller.productList.isEmpty) {
                  return const Center(
                    child: Text(
                        'Please tap on Referesh Button to Load offline list'),
                  );
                }
                return Expanded(
                  child: ListView.separated(
                      itemCount: controller
                          .productList.length, // length of product list
                      // separator to divede list items
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        // getting product item from list
                        var product = controller.productList[index];

                        // product Tile Widget
                        return ProductTile(
                          product: product,
                        );
                      }),
                );
              })
            ],
          ),
        ));
  }

  void checkIsNetworkAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isNetworkAvailable = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        Provider.of<ProductController>(context, listen: false).getProductList();
      });
    } else {
      isNetworkAvailable = false;
    }
    setState(() {});
  }
}
