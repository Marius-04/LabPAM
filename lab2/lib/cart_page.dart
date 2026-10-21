import 'package:flutter/material.dart';

import 'data.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          if (store.cart.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 56, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Your cart is empty',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: store.cart.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, i) => _CartTile(item: store.cart[i]),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Color(0x14000000), blurRadius: 12),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(fontSize: 16)),
                          Text(money(store.cartTotal),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () => _checkout(context),
                          child: const Text('Checkout',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _checkout(BuildContext context) {
    final total = store.cartTotal;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Order placed'),
        content: Text('Thank you! Your order of ${money(total)} was placed.'),
        actions: [
          TextButton(
            onPressed: () {
              store.clear();
              Navigator.pop(ctx);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 96,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: kGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(item.image,
              fit: BoxFit.cover, alignment: Alignment.topCenter),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('${item.colorName} · Size ${item.size}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _QtyBtn(icon: Icons.remove, onTap: () => store.dec(item)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('${item.qty}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  _QtyBtn(icon: Icons.add, onTap: () => store.inc(item)),
                  const Spacer(),
                  Text(money(item.total),
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => store.remove(item),
          icon: const Icon(Icons.delete_outline, color: Colors.grey),
        ),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(color: kGrey, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: kDark),
      ),
    );
  }
}
