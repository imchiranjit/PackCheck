import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class NotFound extends Error {}

class Failed extends Error {}

Future<Product> fetchProduct(String code) async {
  try {
    final response = await http.get(
        Uri.parse(
            'https://api.jsonbin.io/v3/b/66a099c8ad19ca34f88c030f?meta=false'),
        headers: {"X-JSON-Path": '\$[?(@.code=="$code")]'});
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List<dynamic>;
      if (jsonData.isEmpty) {
        throw NotFound();
      }
      return Product.fromJson(jsonData[0] as Map<String, dynamic>);
    } else {
      throw Failed();
    }
  } on NotFound {
    rethrow;
  } catch (e) {
    throw Failed();
  }
}

class Product {
  final String code;
  final String name;
  final String image;
  final String nutritions;
  final String child;
  final String young;
  final String adult;
  final String pregnant;
  final String lactating;
  final String old;
  final String obese;
  final String diabetic;
  final String hypertention;

  const Product({
    required this.code,
    required this.name,
    required this.image,
    required this.nutritions,
    required this.child,
    required this.young,
    required this.adult,
    required this.pregnant,
    required this.lactating,
    required this.old,
    required this.obese,
    required this.diabetic,
    required this.hypertention,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "code": String code,
        "name": String name,
        "image": String image,
        "nutritions": String nutritions,
        "category": {
          "child": String child,
          "young": String young,
          "adult": String adult,
          "pregnant": String pregnant,
          "lactating women": String lactating,
          "old": String old,
          "obese": String obese,
          "diabetic": String diabetic,
          "hypertention": String hypertention
        }
      } =>
        Product(
            code: code,
            name: name,
            image: image,
            nutritions: nutritions,
            child: child,
            young: young,
            adult: adult,
            pregnant: pregnant,
            lactating: lactating,
            old: old,
            obese: obese,
            diabetic: diabetic,
            hypertention: hypertention),
      _ => throw NotFound(),
    };
  }

  factory Product.copy(Product product) {
    return Product(
        code: product.code,
        name: product.name,
        image: product.image,
        nutritions: product.nutritions,
        child: product.child,
        young: product.young,
        adult: product.adult,
        pregnant: product.pregnant,
        lactating: product.lactating,
        old: product.old,
        obese: product.obese,
        diabetic: product.diabetic,
        hypertention: product.hypertention);
  }
}
