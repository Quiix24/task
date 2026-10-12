import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/products/presentation/products_screen.dart';

void main() {
  runApp(
    ProviderScope(retry: (_, _) => null, child: const ProductExplorerApp()),
  );
}

class ProductExplorerApp extends StatelessWidget {
  const ProductExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Explorer',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ProductsScreen(),
    );
  }
}
