import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/product_model.dart';
import '../providers/products_provider.dart';
import 'widgets/error_view.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({required this.productId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(addToCartProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added to cart.'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (previous?.isLoading == true && next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final product = ref.watch(productDetailProvider(productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: product.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(productDetailProvider(productId)),
        ),
        data: (product) => _ProductDetails(product: product, ref: ref),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final ProductModel product;
  final WidgetRef ref;

  const _ProductDetails({required this.product, required this.ref});

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(addToCartProvider);
    final isAddingToCart = cartState.isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 260,
            width: double.infinity,
            child: Image.network(
              product.image,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(height: 20),
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text('Category: ${product.category}'),
          const SizedBox(height: 8),
          Text(
            'Rating: ${product.rating.rate.toStringAsFixed(1)} '
            '(${product.rating.count} reviews)',
          ),
          const SizedBox(height: 20),
          Text(product.description),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isAddingToCart
                  ? null
                  : () => ref
                        .read(addToCartProvider.notifier)
                        .addToCart(product.id),
              icon: isAddingToCart
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_shopping_cart),
              label: Text(isAddingToCart ? 'Adding...' : 'Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
