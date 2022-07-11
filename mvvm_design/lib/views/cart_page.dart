import 'package:flutter/material.dart';

import '../models/product.dart';
import '../viewmodels/product_list_view_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final List<Product> productList = AppStateWidget.of(context).getCartItems();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text('Cart', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
          color: Colors.yellow.shade300,
          child: Column(children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  final product = productList[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.circle,
                      size: 10,
                    ),
                    title: Text(product.title.toString()),
                  );
                }),
                itemCount: productList.length,
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 5,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$ ${productList.map((item) => item.price!.toDouble()).reduce((a, b) => a + b)}",
                    style: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        primary: Colors.white,
                        // borderRadius: BorderRadius.zero,
                      ),
                      onPressed: () {},
                      child: const Text('Buy'))
                ],
              ),
            )
          ])),
    );
  }
}
