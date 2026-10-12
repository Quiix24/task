import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task/core/errors/app_exception.dart';
import 'package:task/core/network/api_client.dart';
import 'package:task/features/products/data/product_remote_data_source.dart';
import 'package:task/features/products/data/repositories/product_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late ProductRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    repository = ProductRepository(ProductRemoteDataSource(apiClient));
  });

  test('getProducts returns parsed products', () async {
    when(() => apiClient.get('/products')).thenAnswer(
      (_) async => Response<dynamic>(
        requestOptions: RequestOptions(path: '/products'),
        data: [
          {
            'id': 1,
            'title': 'Backpack',
            'price': 29.99,
            'description': 'A backpack',
            'category': 'bags',
            'image': 'https://example.com/bag.png',
            'rating': {'rate': 4.5, 'count': 10},
          },
        ],
      ),
    );

    final products = await repository.getProducts();

    expect(products, hasLength(1));
    expect(products.first.title, 'Backpack');
    expect(products.first.price, 29.99);
  });

  test('getProducts rethrows a ServerException', () async {
    const exception = ServerException(
      statusCode: 500,
      message: 'The server returned an error.',
    );
    when(() => apiClient.get('/products')).thenThrow(exception);

    await expectLater(repository.getProducts(), throwsA(same(exception)));
  });

  test('getProducts rethrows a NetworkException', () async {
    const exception = NetworkException('Unable to connect.');
    when(() => apiClient.get('/products')).thenThrow(exception);

    await expectLater(repository.getProducts(), throwsA(same(exception)));
  });
}
