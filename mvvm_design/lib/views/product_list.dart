import 'package:flutter/material.dart';
import 'package:mvvm_design/models/product.dart';
import 'package:mvvm_design/views/cart_page.dart';

import '../viewmodels/product_list_view_model.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> productList = AppStateScope.of(context).productList;
    final Set<String> itemsInCart = AppStateScope.of(context).itemsInCart;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catalog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartPage()));
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: productList.isNotEmpty
                  ? ListView.builder(
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        final product = productList[index];
                        final id = product.id.toString();
                        return ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          trailing: itemsInCart.contains(id)
                              ? const Icon(Icons.check)
                              : TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Colors.black),
                                  onPressed: () {
                                    AppStateWidget.of(context).addToCart(id);
                                  },
                                  child: const Text(
                                    'ADD',
                                  ),
                                ),
                          leading: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(product.image!)),
                                borderRadius: BorderRadius.circular(6)),
                            width: 50,
                            height: 100,
                          ),
                          title: Text(product.title!),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
