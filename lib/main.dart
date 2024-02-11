import 'package:brainvire_test/providers/productController.dart';
import 'package:brainvire_test/screens/productListScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const BrainVireApp());
}

class BrainVireApp extends StatelessWidget {
  const BrainVireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductController(),
        ),
      ],
      child: MaterialApp(
        title: 'BrainVire Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ProductListPage(title: 'Product List'),
      ),
    );
  }
}
