import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'data.dart';
import 'product_page.dart';

class StarRow extends StatelessWidget {
  final int filled;
  final double size;
  const StarRow({super.key, this.filled = 5, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < filled ? Icons.star_rounded : Icons.star_outline_rounded,
          color: kGreen,
          size: size,
        ),
      ),
    );
  }
}

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartPage()),
        ),
        icon: Badge(
          isLabelVisible: store.cartCount > 0,
          label: Text('${store.cartCount}'),
          child: const Icon(Icons.shopping_bag_outlined),
        ),
      ),
    );
  }
}

/// Product image inside a grey rounded box.
class ProductImage extends StatelessWidget {
  final Product product;
  final double? width;
  final double? height;
  final double radius;
  const ProductImage({
    super.key,
    required this.product,
    this.width,
    this.height,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: kGrey,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Image.asset(
        product.images.first,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

void openProduct(BuildContext context, Product p) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ProductPage(product: p)),
  );
}

class ProductCard extends StatelessWidget {
  final Product product;
  final double? width;
  final double? imageHeight; // null => image expands to fill
  const ProductCard({
    super.key,
    required this.product,
    this.width,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final image = ProductImage(
      product: product,
      width: double.infinity,
      height: imageHeight,
    );
    return GestureDetector(
      onTap: () => openProduct(context, product),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageHeight == null) Expanded(child: image) else image,
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              money(product.price),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
