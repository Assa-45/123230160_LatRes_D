import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class AppState extends ChangeNotifier {
  String? _currentUsername;
  bool _isLoggedIn = false;
  final Map<String, List<CartItem>> _cartByUser = {};

  String? get currentUsername => _currentUsername;
  bool get isLoggedIn => _isLoggedIn;

  List<CartItem> get currentCart {
    if (_currentUsername == null) return [];
    return _cartByUser[_currentUsername] ?? [];
  }

  int get cartItemCount => currentCart.fold(0, (sum, item) => sum + item.quantity);

  void login(String username) {
    _currentUsername = username;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _currentUsername = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void addToCart(Product product, int quantity) {
    if (_currentUsername == null) return;
    _cartByUser[_currentUsername!] ??= [];
    final cart = _cartByUser[_currentUsername!]!;
    final existingIndex = cart.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      cart[existingIndex].quantity += quantity;
    } else {
      cart.add(CartItem(product: product, username: _currentUsername!, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    if (_currentUsername == null) return;
    _cartByUser[_currentUsername!]?.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }
}