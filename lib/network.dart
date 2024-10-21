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
    print("Product not found");
    rethrow;
  } catch (e) {
    throw Failed();
  }
}

class Product {
  // {
  //   "code": "8901719119118",
  //   "name": "Parle-G",
  //   "image": "https://www.parleproducts.com/Uploads/prdsmallimage/100prodsmall_parle-g.png",
  //   "nutritions": {
  //     "quantity": "100g",
  //     "nutrients": {
  //       "Carbohydrates": "78.2g",
  //       "Protein": "6.5g",
  //       "Fat": "12.5g",
  //       "Energy": "451KCal"
  //     }
  //   },
  //   "positive": [
  //     "Trans fat free",
  //     "Cholesterol free"
  //   ],
  //   "negative": [
  //     "High calorie content (>250KCal/100g)",
  //     "High sugar content (3g/100g)",
  //     "High fat content (>4.2g/100g)"
  //   ],
  //   "category": {
  //     "school-0": "l",
  //     "school-1": "m",
  //     "adolescents-0-m": "m",
  //     "adolescents-0-f": "m",
  //     "adolescents-1-m": "m",
  //     "adolescents-1-f": "m",
  //     "adolescents-2-m": "m",
  //     "adolescents-2-f": "m",
  //     "adult-m": "m",
  //     "adult-f": "m",
  //     "old-m": "m",
  //     "old-f": "m",
  //     "pregnant": "m",
  //     "lactating": "m",
  //     "obese": "h",
  //     "diabetic": "h",
  //     "hypertention": "h"
  //   }
  // }
  final String code;
  final String name;
  final String image;
  final Nutritions nutritions;
  final List<String> positive;
  final List<String> negative;

  final String school0;
  final String school1;
  final String adolescents0m;
  final String adolescents0f;
  final String adolescents1m;
  final String adolescents1f;
  final String adolescents2m;
  final String adolescents2f;
  final String adultm;
  final String adultf;
  final String oldm;
  final String oldf;
  final String pregnant;
  final String lactating;
  final String obese;
  final String diabetic;
  final String hypertention;

  const Product(
      {required this.code,
      required this.name,
      required this.image,
      required this.nutritions,
      required this.positive,
      required this.negative,
      required this.school0,
      required this.school1,
      required this.adolescents0m,
      required this.adolescents0f,
      required this.adolescents1m,
      required this.adolescents1f,
      required this.adolescents2m,
      required this.adolescents2f,
      required this.adultm,
      required this.adultf,
      required this.oldm,
      required this.oldf,
      required this.pregnant,
      required this.lactating,
      required this.obese,
      required this.diabetic,
      required this.hypertention});

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      String code = json["code"];
      String name = json["name"];
      String image = json["image"];
      Nutritions nutritions = Nutritions.fromJson(json["nutritions"]);
      List<String> positive = List<String>.from(json["positive"]);
      List<String> negative = List<String>.from(json["negative"]);
      String school0 = json["category"]["school-0"];
      String school1 = json["category"]["school-1"];
      String adolescents0m = json["category"]["adolescents-0-m"];
      String adolescents0f = json["category"]["adolescents-0-f"];
      String adolescents1m = json["category"]["adolescents-1-m"];
      String adolescents1f = json["category"]["adolescents-1-f"];
      String adolescents2m = json["category"]["adolescents-2-m"];
      String adolescents2f = json["category"]["adolescents-2-f"];
      String adultm = json["category"]["adult-m"];
      String adultf = json["category"]["adult-f"];
      String oldm = json["category"]["old-m"];
      String oldf = json["category"]["old-f"];
      String pregnant = json["category"]["pregnant"];
      String lactating = json["category"]["lactating"];
      String obese = json["category"]["obese"];
      String diabetic = json["category"]["diabetic"];
      String hypertention = json["category"]["hypertention"];

      return Product(
          code: code,
          name: name,
          image: image,
          nutritions: nutritions,
          positive: positive,
          negative: negative,
          school0: school0,
          school1: school1,
          adolescents0m: adolescents0m,
          adolescents0f: adolescents0f,
          adolescents1m: adolescents1m,
          adolescents1f: adolescents1f,
          adolescents2m: adolescents2m,
          adolescents2f: adolescents2f,
          adultm: adultm,
          adultf: adultf,
          oldm: oldm,
          oldf: oldf,
          pregnant: pregnant,
          lactating: lactating,
          obese: obese,
          diabetic: diabetic,
          hypertention: hypertention);
    } catch (e) {
      print(e);
      throw NotFound();
    }

    // return switch (json) {
    //   {
    //     "code": String code,
    //     "name": String name,
    //     "image": String image,
    //     "nutritions": Nutritions nutritions,
    //     "positive": List<String> positive,
    //     "negative": List<String> negative,
    //     "category": {
    //       "school-0": String school0,
    //       "school-1": String school1,
    //       "adolescents-0-m": String adolescents0m,
    //       "adolescents-0-f": String adolescents0f,
    //       "adolescents-1-m": String adolescents1m,
    //       "adolescents-1-f": String adolescents1f,
    //       "adolescents-2-m": String adolescents2m,
    //       "adolescents-2-f": String adolescents2f,
    //       "adult-m": String adultm,
    //       "adult-f": String adultf,
    //       "old-m": String oldm,
    //       "old-f": String oldf,
    //       "pregnant": String pregnant,
    //       "lactating": String lactating,
    //       "obese": String obese,
    //       "diabetic": String diabetic,
    //       "hypertention": String hypertention
    //     }
    //   } =>
    //     Product(
    //         code: code,
    //         name: name,
    //         image: image,
    //         nutritions: nutritions,
    //         positive: positive,
    //         negative: negative,
    //         school0: school0,
    //         school1: school1,
    //         adolescents0m: adolescents0m,
    //         adolescents0f: adolescents0f,
    //         adolescents1m: adolescents1m,
    //         adolescents1f: adolescents1f,
    //         adolescents2m: adolescents2m,
    //         adolescents2f: adolescents2f,
    //         adultm: adultm,
    //         adultf: adultf,
    //         oldm: oldm,
    //         oldf: oldf,
    //         pregnant: pregnant,
    //         lactating: lactating,
    //         obese: obese,
    //         diabetic: diabetic,
    //         hypertention: hypertention),
    //   _ => throw NotFound(),
    // };
  }

  factory Product.copy(Product product) {
    return Product(
        code: product.code,
        name: product.name,
        image: product.image,
        nutritions: product.nutritions,
        positive: product.positive,
        negative: product.negative,
        school0: product.school0,
        school1: product.school1,
        adolescents0m: product.adolescents0m,
        adolescents0f: product.adolescents0f,
        adolescents1m: product.adolescents1m,
        adolescents1f: product.adolescents1f,
        adolescents2m: product.adolescents2m,
        adolescents2f: product.adolescents2f,
        adultm: product.adultm,
        adultf: product.adultf,
        oldm: product.oldm,
        oldf: product.oldf,
        pregnant: product.pregnant,
        lactating: product.lactating,
        obese: product.obese,
        diabetic: product.diabetic,
        hypertention: product.hypertention);
  }
}

class Nutritions {
  final String quantity;
  final Map<String, String> nutrients;

  const Nutritions({required this.quantity, required this.nutrients});

  factory Nutritions.fromJson(Map<String, dynamic> json) {
    try {
      String quantity = json["quantity"];
      Map<String, String> nutrients =
          Map<String, String>.from(json["nutrients"]);

      return Nutritions(quantity: quantity, nutrients: nutrients);
    } catch (e) {
      print(e);
      throw NotFound();
    }
    // return switch (json) {
    //   {
    //     "quantity": String quantity,
    //     "nutrients": Map<String, String> nutrients
    //   } =>
    //     Nutritions(quantity: quantity, nutrients: nutrients),
    //   _ => throw NotFound(),
    // };
  }

  factory Nutritions.copy(Nutritions nutritions) {
    return Nutritions(
        quantity: nutritions.quantity, nutrients: nutritions.nutrients);
  }
}
