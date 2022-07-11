import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mvvm_design/models/product.dart';

class Webservice {
  Future<List<Product>> fetchProducts() async {
    var url = Uri.parse("https://fakestoreapi.com/products/");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }
}
