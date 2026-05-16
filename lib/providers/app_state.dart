import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/db_service.dart';
import '../services/session_service.dart';

class AppState extends ChangeNotifier {
  final _db = DatabaseService();
  final _session = SessionService();

  String? _currentUsername;
  bool _isLoggedIn = false;

  List<CartItem> _cart = [];
  bool isLoadingCart = false;

  String? get currentUsername => _currentUsername;
  bool get isLoggedIn => _isLoggedIn;
  
  List<CartItem> get currentCart => _cart;
  int get cartItemCount => _cart.fold(0, (s, i) => s + i.quantity);

  Future<void> tryAutoLogin() async {
    final savedUsername = await _session.getSavedUsername();
    if (savedUsername != null) {
      _currentUsername = savedUsername;
      _isLoggedIn = true;
      await _loadCart();
      notifyListeners();
    }
  }

  // ─── LOGIN 
  Future<void> login(String username) async {
    _currentUsername = username;
    _isLoggedIn = true;
    await _session.saveSession(username); // simpan ke SharedPreferences
    await _loadCart();                     // load cart dari Sembast
    notifyListeners();
  }

  // ─── LOGOUT 
  Future<void> logout() async {
    await _session.clearSession(); // hapus dari SharedPreferences
    _currentUsername = null;
    _isLoggedIn = false;
    _cart = [];
    notifyListeners();
  }

  // ─── LOAD CART dari Sembast 
  Future<void> _loadCart() async {
    if (_currentUsername == null) return;

    isLoadingCart = true;
    notifyListeners();

    final rawItems = await _db.getCart(_currentUsername!);

    // Konversi Map → CartItem
    _cart = rawItems.map((map) {
      final product = Product.fromJson(map['product'] as Map<String, dynamic>);
      return CartItem(
        product: product,
        username: map['username'] as String,
        quantity: map['quantity'] as int,
      );
    }).toList();

    isLoadingCart = false;
    notifyListeners();
  }

  // ─── SIMPAN CART ke Sembast 
  Future<void> _persistCart() async {
    if (_currentUsername == null) return;

    // Konversi CartItem → Map untuk disimpan
    final rawItems = _cart.map((item) => {
      'username': item.username,
      'quantity': item.quantity,
      'product': {
        'id': item.product.id,
        'title': item.product.title,
        'description': item.product.description,
        'price': item.product.price,
        'discountPercentage': item.product.discountPercentage,
        'rating': item.product.rating,
        'stock': item.product.stock,
        'brand': item.product.brand,
        'category': item.product.category,
        'thumbnail': item.product.thumbnail,
        'images': item.product.images,
      },
    }).toList();

    await _db.saveCart(_currentUsername!, rawItems);
  }

  // ─── ADD TO CART
  Future<void> addToCart(Product product, int quantity) async {
    if (_currentUsername == null) return;

    final existingIndex = _cart.indexWhere((i) => i.product.id == product.id);
    if (existingIndex >= 0) {
      _cart[existingIndex].quantity += quantity;
    } else {
      _cart.add(CartItem(
        product: product,
        username: _currentUsername!,
        quantity: quantity,
      ));
    }

    notifyListeners();
    await _persistCart(); // langsung simpan ke Sembast
  }

  // ─── REMOVE FROM CART
  Future<void> removeFromCart(int productId) async {
    _cart.removeWhere((i) => i.product.id == productId);
    notifyListeners();
    await _persistCart();
  }
}