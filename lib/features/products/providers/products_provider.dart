import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client_provider.dart';
import '../data/models/product_model.dart';
import '../data/product_remote_data_source.dart';
import '../data/repositories/product_repository.dart';

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  return ProductRemoteDataSource(ref.watch(apiClientProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(productRemoteDataSourceProvider));
});

final categoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(productRepositoryProvider).getCategories();
});

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String?>(
      SelectedCategoryNotifier.new,
    );

class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? category) {
    state = category;
  }
}

final productsProvider = FutureProvider<List<ProductModel>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final repository = ref.watch(productRepositoryProvider);

  if (selectedCategory == null) {
    return repository.getProducts();
  }

  return repository.getProductsByCategory(selectedCategory);
});

final productDetailProvider = FutureProvider.family<ProductModel, int>((
  ref,
  id,
) {
  return ref.watch(productRepositoryProvider).getProductById(id);
});

final addToCartProvider = AsyncNotifierProvider<AddToCartNotifier, void>(
  AddToCartNotifier.new,
);

class AddToCartNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addToCart(int productId) async {
    state = const AsyncLoading();

    try {
      await ref.read(productRepositoryProvider).addToCart(productId);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
