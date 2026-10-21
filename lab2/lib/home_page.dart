import 'dart:async';

import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'data.dart';
import 'list_page.dart';
import 'widgets.dart';

class _BannerData {
  final String title;
  final String image;
  final bool fullBleed;
  final Color bg;
  final Product? product;
  const _BannerData(this.title, this.image, this.fullBleed, this.bg,
      [this.product]);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _cats = [
    ('Women', Icons.female),
    ('Men', Icons.male),
    ('Accessories', Icons.watch_outlined),
    ('Beauty', Icons.brush_outlined),
  ];

  static const _banners = [
    _BannerData('Autumn\nCollection\n2021', 'assets/images/banner_autumn.jpg',
        true, Color(0xFFC98E7B)),
    _BannerData('Sale up to\n40%', 'assets/images/yellow.png', false,
        Color(0xFFE9B94E)),
    _BannerData('Summer\nCollection\n2021', 'assets/images/brown.png', false,
        Color(0xFF8E7767)),
  ];

  int _cat = 0;
  int _banner = 0;
  final _pageCtrl = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageCtrl.hasClients) return;
      final next = (_banner + 1) % _banners.length;
      _pageCtrl.animateToPage(next,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _openList(String title, List<Product> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ProductListPage(title: title, products: items)),
    );
  }

  void _showNotifications() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.local_offer_outlined),
              title: Text('Autumn Collection is live'),
              subtitle: Text('Up to 40% off selected items'),
            ),
            ListTile(
              leading: Icon(Icons.local_shipping_outlined),
              title: Text('Free delivery'),
              subtitle: Text('On orders over \$100'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('GemStore',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Favorites'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProductListPage(
                            title: 'Favorites', favoritesOnly: true)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined),
                title: const Text('Cart'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('GemStore',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        actions: [
          IconButton(
            onPressed: _showNotifications,
            icon: const Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_none),
            ),
          ),
          const CartButton(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _categories(),
          if (_cat != 0)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Center(
                child: Text('Coming soon',
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            )
          else ...[
            _bannerView(),
            _header('Feature Products',
                () => _openList('Feature Products', allProducts)),
            _featured(),
            _hangOut(),
            _header('Recommended',
                () => _openList('Recommended', [whiteHoodie, cottonTee])),
            _recommended(),
            _header('Top Collection',
                () => _openList('Top Collection', allProducts)),
            _topCollection(),
          ],
        ],
      ),
    );
  }

  // ------------------------------------------------------------ sections

  Widget _categories() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: List.generate(_cats.length, (i) {
          final sel = i == _cat;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _cat = i),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sel ? kDark : kGrey,
                    ),
                    child: Icon(_cats[i].$2,
                        size: 22, color: sel ? Colors.white : kDark),
                  ),
                  const SizedBox(height: 6),
                  Text(_cats[i].$1,
                      style: TextStyle(
                          fontSize: 11,
                          color: sel ? kDark : Colors.grey,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _bannerView() {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _banner = i),
            itemBuilder: (_, i) {
              final b = _banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (b.fullBleed)
                        Image.asset(b.image,
                            fit: BoxFit.cover, alignment: Alignment.centerLeft)
                      else ...[
                        Container(color: b.bg),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Image.asset(b.image,
                                height: 140, fit: BoxFit.contain),
                          ),
                        ),
                      ],
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(b.fullBleed ? 0.35 : 0.0),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 22),
                          child: Text(
                            b.title,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _banner ? 14 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _banner ? kDark : Colors.black26,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(String title, VoidCallback onAll) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          GestureDetector(
            onTap: onAll,
            child: const Text('Show all',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _featured() {
    final items = [turtleneck, longDress, sportwear];
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) =>
            ProductCard(product: items[i], width: 130, imageHeight: 170),
      ),
    );
  }

  Widget _hangOut() {
    return GestureDetector(
      onTap: () => _openList('Hang out & Party', allProducts),
      child: Container(
        margin: const EdgeInsets.only(top: 22),
        height: 140,
        color: const Color(0xFFF5F5F7),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Container(width: 1, height: 14, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('NEW COLLECTION',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('HANG OUT\n& PARTY',
                      style: TextStyle(
                          fontSize: 20,
                          height: 1.25,
                          fontWeight: FontWeight.w300,
                          color: kDark)),
                ],
              ),
            ),
            SizedBox(
              width: 170,
              height: 140,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE8E8EA),
                      ),
                    ),
                  ),
                  Image.asset('assets/images/hangout.png',
                      height: 125, fit: BoxFit.contain),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommended() {
    final items = [whiteHoodie, cottonTee, gymCrop];
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final p = items[i];
          return GestureDetector(
            onTap: () => openProduct(context, p),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  ProductImage(
                      product: p, width: 56, height: 64, radius: 8),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(money(p.price),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topCollection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _bigCard(
            tag: 'Sale up to 40%',
            title: 'FOR SLIM\n& BEAUTY',
            product: yellowWrapDress,
            height: 110,
            titleStyle: const TextStyle(
                fontSize: 20, height: 1.25, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 14),
          _bigCard(
            tag: 'Summer Collection 2021',
            title: 'Most sexy\n& fabulous\ndesign',
            product: brownSuit,
            height: 150,
            titleStyle: const TextStyle(
                fontSize: 18, height: 1.3, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _smallCard('T-Shirts', 'The Office\nLife', cottonTee,
                    imageLeft: true),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _smallCard('Dresses', 'Elegant\nDesign', whiteDress,
                    imageLeft: false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bigCard({
    required String tag,
    required String title,
    required Product product,
    required double height,
    required TextStyle titleStyle,
  }) {
    return GestureDetector(
      onTap: () => openProduct(context, product),
      child: Container(
        height: height,
        padding: const EdgeInsets.only(left: 16),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 1, height: 12, color: Colors.grey),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(tag,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(title, style: titleStyle.copyWith(color: kDark)),
                ],
              ),
            ),
            SizedBox(
              width: 140,
              height: height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: height * 0.75,
                      height: height * 0.75,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE8E8EA),
                      ),
                    ),
                  ),
                  Image.asset(product.images.first,
                      height: height - 6, fit: BoxFit.contain),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallCard(String tag, String title, Product product,
      {required bool imageLeft}) {
    final image = Expanded(
      child: Image.asset(product.images.first,
          fit: BoxFit.contain, alignment: Alignment.bottomCenter),
    );
    final text = Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tag, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 6),
            Text(title,
                style: const TextStyle(
                    fontSize: 14, height: 1.25, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
    return GestureDetector(
      onTap: () => openProduct(context, product),
      child: Container(
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: imageLeft ? [image, text] : [text, image]),
      ),
    );
  }
}
