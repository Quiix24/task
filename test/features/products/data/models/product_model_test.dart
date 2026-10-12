import 'package:flutter_test/flutter_test.dart';
import 'package:task/features/products/data/models/product_model.dart';

void main() {
  test('fromJson parses an integer price as a double', () {
    final product = ProductModel.fromJson({
      'id': 1,
      'title': 'Backpack',
      'price': 30,
      'description': 'A backpack',
      'category': 'bags',
      'image': 'https://example.com/bag.png',
      'rating': {'rate': 4, 'count': 10},
    });

    expect(product.price, 30.0);
  });
}
