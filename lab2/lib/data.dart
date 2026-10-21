import 'package:flutter/material.dart';

const kDark = Color(0xFF2F2F2F);
const kGreen = Color(0xFF5E8C7E);
const kGrey = Color(0xFFF1F1F4);
const kPeach = Color(0xFFFFF7F3);

String money(double v) => '\$${v.toStringAsFixed(2)}';

class ProductColor {
  final Color color;
  final String name;
  final int? imageIndex; // index in Product.images, or null
  const ProductColor(this.color, this.name, [this.imageIndex]);
}

class Review {
  final String name;
  final String? avatar;
  final int stars;
  final String text;
  final String time;
  const Review({
    required this.name,
    this.avatar,
    required this.stars,
    required this.text,
    required this.time,
  });
}

class Product {
  final String id;
  final String name;
  final double price;
  final List<String> images;
  final bool cutout; // transparent PNG (true) or full photo (false)
  final String description;
  final List<ProductColor> colors;
  final List<String> sizes;
  final List<int> distribution; // % for 5,4,3,2,1 stars
  final List<String> similarIds;
  final List<Review> reviews;
  double rating;
  int ratingCount;
  int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    this.cutout = false,
    this.description =
        'Soft, comfortable and made to last. A versatile piece that works '
            'for the gym, the street and everything in between. Easy to match '
            'with the rest of your wardrobe. Machine washable at 30 degrees.',
    this.colors = const [
      ProductColor(Color(0xFF2F2F2F), 'Black'),
      ProductColor(Color(0xFFE0A59A), 'Rose'),
    ],
    this.sizes = const ['S', 'M', 'L'],
    this.distribution = const [80, 12, 5, 3, 0],
    this.similarIds = const [],
    List<Review>? reviews,
    this.rating = 4.9,
    this.ratingCount = 83,
    this.reviewCount = 47,
  }) : reviews = reviews ?? [];
}

final _baseReviews = <Review>[
  const Review(
    name: 'Jennifer Rose',
    avatar: 'assets/images/avatar_jennifer.jpg',
    stars: 5,
    text: 'I love it. Awesome customer service! Helped me out with adding an '
        'additional item to my order. Thanks again!',
    time: '5m ago',
  ),
  const Review(
    name: 'Kelly Rihana',
    avatar: 'assets/images/avatar_kelly.jpg',
    stars: 5,
    text: "I'm very happy with order, it was delivered on and good quality. "
        'Recommended!',
    time: '9m ago',
  ),
];

final turtleneck = Product(
  id: 'turtleneck',
  name: 'Turtleneck Sweater',
  price: 39.99,
  images: ['assets/images/turtleneck.jpg'],
  colors: const [
    ProductColor(Color(0xFFF4F0EA), 'White'),
    ProductColor(Color(0xFF2F2F2F), 'Black'),
    ProductColor(Color(0xFFB7BBC4), 'Grey'),
  ],
  reviews: List.of(_baseReviews),
);

final longDress = Product(
  id: 'long_dress',
  name: 'Long Sleeve Dress',
  price: 45.00,
  images: ['assets/images/long_dress.jpg'],
  colors: const [
    ProductColor(Color(0xFF3B2F2A), 'Brown'),
    ProductColor(Color(0xFF2F2F2F), 'Black'),
  ],
  reviews: List.of(_baseReviews),
);

final sportwear = Product(
  id: 'sportwear',
  name: 'Sportwear Set',
  price: 80.00,
  images: ['assets/images/set_beige.png', 'assets/images/set_black.png'],
  cutout: true,
  description:
      'Sportwear is no longer under culture, it is no longer indie or '
      'cobbled together as it once was. Sport is fashion today. The top is '
      'oversized in fit and style, may need to size down.',
  colors: const [
    ProductColor(Color(0xFFE3BFA6), 'Beige', 0),
    ProductColor(Color(0xFF1E1E1E), 'Black', 1),
    ProductColor(Color(0xFFE07A6E), 'Coral'),
  ],
  similarIds: const ['rise_hoodie', 'gym_crop', 'sport_sweater'],
  reviews: List.of(_baseReviews),
);

final whiteHoodie = Product(
  id: 'white_hoodie',
  name: 'White fashion hoodie',
  price: 29.00,
  images: ['assets/images/white_hoodie.jpg'],
  colors: const [
    ProductColor(Color(0xFFF4F0EA), 'White'),
    ProductColor(Color(0xFF2F2F2F), 'Black'),
  ],
  reviews: List.of(_baseReviews),
);

final cottonTee = Product(
  id: 'cotton_tee',
  name: 'Cotton T-shirt',
  price: 30.00,
  images: ['assets/images/tee.png'],
  cutout: true,
  colors: const [
    ProductColor(Color(0xFFF4F0EA), 'White'),
    ProductColor(Color(0xFF2F2F2F), 'Black'),
  ],
  reviews: List.of(_baseReviews),
);

final riseHoodie = Product(
  id: 'rise_hoodie',
  name: 'Rise Crop Hoodie',
  price: 43.00,
  images: ['assets/images/rise_hoodie.jpg'],
  colors: const [
    ProductColor(Color(0xFF6E6E6E), 'Grey'),
    ProductColor(Color(0xFF2F2F2F), 'Black'),
  ],
  reviews: List.of(_baseReviews),
);

final gymCrop = Product(
  id: 'gym_crop',
  name: 'Gym Crop Top',
  price: 39.99,
  images: ['assets/images/gym_crop.jpg'],
  colors: const [
    ProductColor(Color(0xFFA88A8E), 'Mauve'),
    ProductColor(Color(0xFF2F2F2F), 'Black'),
  ],
  reviews: List.of(_baseReviews),
);

final sportSweater = Product(
  id: 'sport_sweater',
  name: 'Sport Sweater',
  price: 47.99,
  images: ['assets/images/sport_sweater.jpg'],
  colors: const [
    ProductColor(Color(0xFF7A8BA3), 'Blue'),
    ProductColor(Color(0xFF2F2F2F), 'Black'),
  ],
  reviews: List.of(_baseReviews),
);

final yellowWrapDress = Product(
  id: 'yellow_dress',
  name: 'Wrap Dress',
  price: 59.00,
  images: ['assets/images/yellow.png'],
  cutout: true,
  colors: const [ProductColor(Color(0xFFE9B94E), 'Yellow')],
  reviews: List.of(_baseReviews),
);

final brownSuit = Product(
  id: 'brown_suit',
  name: 'Linen Summer Set',
  price: 69.00,
  images: ['assets/images/brown.png'],
  cutout: true,
  colors: const [ProductColor(Color(0xFF7A6455), 'Brown')],
  reviews: List.of(_baseReviews),
);

final whiteDress = Product(
  id: 'white_dress',
  name: 'Elegant Satin Dress',
  price: 75.00,
  images: ['assets/images/dress_white.png'],
  cutout: true,
  colors: const [ProductColor(Color(0xFFF4F0EA), 'Ivory')],
  reviews: List.of(_baseReviews),
);

final allProducts = <Product>[
  turtleneck,
  longDress,
  sportwear,
  whiteHoodie,
  cottonTee,
  riseHoodie,
  gymCrop,
  sportSweater,
  yellowWrapDress,
  brownSuit,
  whiteDress,
];

Product productById(String id) => allProducts.firstWhere((p) => p.id == id);

// ---------------------------------------------------------------- store

class CartItem {
  final Product product;
  final int colorIndex;
  final String size;
  int qty;
  CartItem(this.product, this.colorIndex, this.size, [this.qty = 1]);

  double get total => product.price * qty;
  String get colorName => product.colors[colorIndex].name;
  String get image {
    final idx = product.colors[colorIndex].imageIndex ?? 0;
    return product.images[idx];
  }
}

class Store extends ChangeNotifier {
  final Set<String> favorites = {};
  final List<CartItem> cart = [];

  bool isFav(Product p) => favorites.contains(p.id);

  void toggleFav(Product p) {
    if (!favorites.remove(p.id)) favorites.add(p.id);
    notifyListeners();
  }

  int get cartCount => cart.fold(0, (s, i) => s + i.qty);
  double get cartTotal => cart.fold(0.0, (s, i) => s + i.total);

  void add(Product p, int colorIndex, String size) {
    final i = cart.indexWhere((c) =>
        c.product.id == p.id && c.colorIndex == colorIndex && c.size == size);
    if (i >= 0) {
      cart[i].qty++;
    } else {
      cart.add(CartItem(p, colorIndex, size));
    }
    notifyListeners();
  }

  void inc(CartItem i) {
    i.qty++;
    notifyListeners();
  }

  void dec(CartItem i) {
    if (i.qty > 1) {
      i.qty--;
    } else {
      cart.remove(i);
    }
    notifyListeners();
  }

  void remove(CartItem i) {
    cart.remove(i);
    notifyListeners();
  }

  void clear() {
    cart.clear();
    notifyListeners();
  }
}

final store = Store();
