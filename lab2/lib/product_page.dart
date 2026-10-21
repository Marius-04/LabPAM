import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'data.dart';
import 'widgets.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _pc = PageController();
  int _img = 0;
  int _color = 0;
  late String _size;
  bool _descOpen = true;
  bool _readMore = false;
  bool _reviewsOpen = true;
  bool _similarOpen = true;

  Product get p => widget.product;

  @override
  void initState() {
    super.initState();
    _size = p.sizes.last;
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _pickColor(int i) {
    setState(() => _color = i);
    final idx = p.colors[i].imageIndex;
    if (idx != null && _pc.hasClients) {
      _pc.animateToPage(idx,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _addToCart() {
    store.add(p, _color, _size);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('${p.name} added to cart'),
          action: SnackBarAction(
            label: 'VIEW',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            ),
          ),
        ),
      );
  }

  void _writeReview() {
    int stars = 5;
    final ctrl = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setM) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Write a review',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (i) => IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => setM(() => stars = i + 1),
                    icon: Icon(
                      i < stars
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: kGreen,
                      size: 34,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ctrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Your review',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    final text = ctrl.text.trim();
                    if (text.isEmpty) return;
                    setState(() {
                      p.reviews.insert(
                        0,
                        Review(
                            name: 'You', stars: stars, text: text, time: 'now'),
                      );
                      p.reviewCount++;
                      p.ratingCount++;
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _gallery(context),
            Transform.translate(
              offset: const Offset(0, -26),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: _details(context),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: kDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _addToCart,
          child: SafeArea(
            top: false,
            child: const SizedBox(
              height: 64,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_bag, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Add To Cart',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gallery(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: p.cutout ? kPeach : kGrey),
          ),
          if (p.cutout)
            Align(
              alignment: const Alignment(0, 0.1),
              child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF9E9E1),
                ),
              ),
            ),
          Positioned.fill(
            child: PageView.builder(
              controller: _pc,
              itemCount: p.images.length,
              onPageChanged: (i) => setState(() => _img = i),
              itemBuilder: (_, i) => p.cutout
                  ? Padding(
                      padding: EdgeInsets.only(top: top + 8, bottom: 30),
                      child: Image.asset(p.images[i], fit: BoxFit.contain),
                    )
                  : Image.asset(p.images[i],
                      fit: BoxFit.cover, alignment: Alignment.topCenter),
            ),
          ),
          Positioned(
            top: top + 8,
            left: 16,
            child: _roundBtn(
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 16, color: kDark),
              onTap: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: top + 8,
            right: 16,
            child: AnimatedBuilder(
              animation: store,
              builder: (_, __) => _roundBtn(
                child: Icon(
                  store.isFav(p) ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: Colors.redAccent,
                ),
                onTap: () => store.toggleFav(p),
              ),
            ),
          ),
          if (p.images.length > 1)
            Positioned(
              bottom: 38,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  p.images.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _img ? kDark : Colors.black26,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _roundBtn({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 6)],
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _details(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(p.name,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600)),
            ),
            Text(money(p.price),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const StarRow(size: 20),
            const SizedBox(width: 6),
            Text('(${p.ratingCount})',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const Divider(height: 28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _colorPicker()),
            Expanded(child: _sizePicker()),
          ],
        ),
        const Divider(height: 28),
        _section(
          title: 'Description',
          open: _descOpen,
          onToggle: () => setState(() => _descOpen = !_descOpen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.description,
                maxLines: _readMore ? null : 4,
                overflow:
                    _readMore ? TextOverflow.visible : TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12, height: 1.5, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => setState(() => _readMore = !_readMore),
                child: Text(
                  _readMore ? 'Read less' : 'Read more',
                  style: const TextStyle(
                    fontSize: 12,
                    color: kGreen,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        _section(
          title: 'Reviews',
          open: _reviewsOpen,
          onToggle: () => setState(() => _reviewsOpen = !_reviewsOpen),
          child: _reviews(),
        ),
        _section(
          title: 'Similar Product',
          open: _similarOpen,
          onToggle: () => setState(() => _similarOpen = !_similarOpen),
          child: _similar(),
          last: true,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _section({
    required String title,
    required bool open,
    required VoidCallback onToggle,
    required Widget child,
    bool last = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                Icon(open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        const Divider(height: 16),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: open
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(width: double.infinity, child: child),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  Widget _colorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: TextStyle(fontSize: 13)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: List.generate(p.colors.length, (i) {
            final sel = i == _color;
            return GestureDetector(
              onTap: () => _pickColor(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: sel ? Colors.black26 : Colors.transparent),
                ),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: p.colors[i].color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _sizePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Size', style: TextStyle(fontSize: 13)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: p.sizes.map((s) {
            final sel = s == _size;
            return GestureDetector(
              onTap: () => setState(() => _size = s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: sel ? const Color(0xFF555555) : kGrey,
                ),
                child: Text(s,
                    style: TextStyle(
                        fontSize: 12,
                        color: sel ? Colors.white : Colors.grey)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _reviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(p.rating.toStringAsFixed(1),
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(width: 6),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('OUT OF 5',
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const StarRow(size: 18),
                const SizedBox(height: 2),
                Text('${p.ratingCount} ratings',
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (int i = 0; i < 5; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text('${5 - i}', style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 4),
                const Icon(Icons.star_rounded, size: 12, color: kGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: p.distribution[i] / 100,
                      minHeight: 5,
                      backgroundColor: kGrey,
                      valueColor: const AlwaysStoppedAnimation(kGreen),
                    ),
                  ),
                ),
                SizedBox(
                  width: 38,
                  child: Text('${p.distribution[i]}%',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${p.reviewCount} Reviews',
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
            GestureDetector(
              onTap: _writeReview,
              child: const Row(
                children: [
                  Text('WRITE A REVIEW',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                  SizedBox(width: 4),
                  Icon(Icons.edit, size: 12, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (final r in p.reviews) _reviewTile(r),
      ],
    );
  }

  Widget _reviewTile(Review r) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: kGrey,
                backgroundImage: r.avatar == null ? null : AssetImage(r.avatar!),
                child: r.avatar == null
                    ? const Icon(Icons.person, size: 16, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    StarRow(filled: r.stars, size: 12),
                  ],
                ),
              ),
              Text(r.time,
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Text(r.text,
              style: const TextStyle(
                  fontSize: 11.5, height: 1.45, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _similar() {
    final items = p.similarIds.isNotEmpty
        ? p.similarIds.map(productById).toList()
        : allProducts.where((x) => x.id != p.id).take(4).toList();
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => ProductCard(
          product: items[i],
          width: 100,
          imageHeight: 132,
        ),
      ),
    );
  }
}
