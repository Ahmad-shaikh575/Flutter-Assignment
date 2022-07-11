import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_design/models/product.dart';
import 'package:mvvm_design/services/authservice.dart';
import 'package:mvvm_design/services/webservice.dart';

class ProductListViewModel extends ChangeNotifier {
  List<Product> products = <Product>[];

  Future<void> fetchProducts() async {
    final results = await Webservice().fetchProducts();
    products = results.toList();
    // ignore: avoid_print
    // print(products);

    notifyListeners();
  }
}

class AppState {
  AppState({
    this.user,
    required this.productList,
    this.itemsInCart = const <String>{},
  });

  final List<Product> productList;
  final Set<String> itemsInCart;
  final User? user;

  AppState copyWith({
    List<Product>? productList,
    Set<String>? itemsInCart,
    User? user,
  }) {
    return AppState(
        productList: productList ?? this.productList,
        itemsInCart: itemsInCart ?? this.itemsInCart,
        user: user ?? this.user);
  }
}

class AppStateScope extends InheritedWidget {
  const AppStateScope(this.data, {Key? key, required Widget child})
      : super(key: key, child: child);

  final AppState data;

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateScope>()!.data;
  }

  @override
  bool updateShouldNotify(AppStateScope oldWidget) {
    return data != oldWidget.data;
  }
}

class AppStateWidget extends StatefulWidget {
  const AppStateWidget({required this.child, Key? key}) : super(key: key);

  final Widget child;

  static AppStateWidgetState of(BuildContext context) {
    return context.findAncestorStateOfType<AppStateWidgetState>()!;
  }

  @override
  AppStateWidgetState createState() => AppStateWidgetState();
}

class AppStateWidgetState extends State<AppStateWidget> {
  AppState _data = AppState(
    productList: <Product>[],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  void signIn ({required String email, required String password}) async{
   await AuthenticationHelper().signIn(email: email, password: password);
    User user = await AuthenticationHelper().user;
    setState(() {
      _data = _data.copyWith(user: user);
    });
  }

  void signUp({required String email, required String password})async {
   await AuthenticationHelper().signUp(email: email, password: password);
   User user = await AuthenticationHelper().user;
    setState(() {
      _data = _data.copyWith(user: user);
    });
  }

  _asyncMethod() async {
    _data = AppState(
      productList: await Webservice().fetchProducts(),
    );
    setState(() {});
  }

  void setProductList(List<Product> newProductList) {
    if (newProductList != _data.productList) {
      setState(() {
        _data = _data.copyWith(
          productList: newProductList,
        );
      });
    }
  }

  void addToCart(String id) {
    if (!_data.itemsInCart.contains(id)) {
      final Set<String> newItemsInCart = Set<String>.from(_data.itemsInCart);
      newItemsInCart.add(id);
      setState(() {
        _data = _data.copyWith(
          itemsInCart: newItemsInCart,
        );
      });
    }
  }

  void removeFromCart(String id) {
    if (_data.itemsInCart.contains(id)) {
      final Set<String> newItemsInCart = Set<String>.from(_data.itemsInCart);
      newItemsInCart.remove(id);
      setState(() {
        _data = _data.copyWith(
          itemsInCart: newItemsInCart,
        );
      });
    }
  }

  List<Product> getCartItems() {
    return _data.productList.where((product) {
      return _data.itemsInCart.contains(product.id.toString());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      _data,
      child: widget.child,
    );
  }
}
