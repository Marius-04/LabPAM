import 'package:flutter/material.dart';

import 'data.dart';
import 'widgets.dart';

class ProductListPage extends StatelessWidget {
  final String title;
  final List<Product> products;
  final bool favoritesOnly;
  const ProductListPage({
    super.key,
    required this.title,
    this.products = const [],
    this.favoritesOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: const [CartButton()],
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final items = favoritesOnly
              ? allProducts.where((p) => store.isFav(p)).toList()
              : products;
          if (items.isEmpty) {
            return const Center(
              child: Text('No products yet',
                  style: TextStyle(color: Colors.grey)),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => ProductCard(product: items[i]),
          );
        },
      ),
    );
  }
}
