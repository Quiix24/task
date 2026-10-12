import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task/main.dart';
import 'package:task/features/products/data/models/product_model.dart';
import 'package:task/features/products/providers/products_provider.dart';

void main() {
  testWidgets('Product Explorer loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          categoriesProvider.overrideWithValue(
            const AsyncData<List<String>>([]),
          ),
          productsProvider.overrideWithValue(
            const AsyncData<List<ProductModel>>([]),
          ),
        ],
        child: const ProductExplorerApp(),
      ),
    );

    expect(find.text('Product Explorer'), findsOneWidget);
  });
}
