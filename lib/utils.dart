// Shared preferences to store user data
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snack_food/network.dart';

enum Gender { male, female }

enum HealthStatus { high, medium, low }

class UserData {
  final DateTime dob;
  final int height;
  final int weight;
  final Gender gender;
  final bool pregnant;
  final bool lactating;
  final bool diabetic;
  final bool hyperTension;

  const UserData({
    required this.dob,
    required this.height,
    required this.weight,
    required this.gender,
    required this.pregnant,
    required this.lactating,
    required this.diabetic,
    required this.hyperTension,
  });

  // get age
  int get age {
    final currentDate = DateTime.now();
    final birthDate = dob;
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // get bmi
  double get bmi {
    return (weight / ((height * height * 2.54 * 2.54) / 10000));
  }

  bool get obese {
    return bmi >= 30;
  }

  HealthStatus healthCheck(Product product) {
    var params = [];

    if (obese) {
      params.add(product.obese);
    }
    if (diabetic) {
      params.add(product.diabetic);
    }
    if (hyperTension) {
      params.add(product.hypertention);
    }

    if (age <= 6) {
      params.add(product.school0);
    } else if (age <= 9) {
      params.add(product.school1);
    } else {
      if (gender == Gender.female) {
        if (age <= 12) {
          params.add(product.adolescents0f);
        } else if (age <= 15) {
          params.add(product.adolescents1f);
        } else if (age <= 18) {
          params.add(product.adolescents2f);
        } else if (age <= 60) {
          params.add(product.adultf);
        } else {
          params.add(product.oldf);
        }

        if (pregnant) {
          params.add(product.pregnant);
        }
        if (lactating) {
          params.add(product.lactating);
        }
      } else {
        if (age <= 12) {
          params.add(product.adolescents0m);
        } else if (age <= 15) {
          params.add(product.adolescents1m);
        } else if (age <= 18) {
          params.add(product.adolescents2m);
        } else if (age <= 60) {
          params.add(product.adultm);
        } else {
          params.add(product.oldm);
        }
      }
    }

    if (params.contains("h")) {
      return HealthStatus.high;
    } else if (params.contains("m")) {
      return HealthStatus.medium;
    }

    return HealthStatus.low;
  }
}

class UserPreferences {
  static const _keyDobDay = 'dobDay';
  static const _keyDobMonth = 'dobMonth';
  static const _keyDobYear = 'dobYear';
  static const _keyHeight = 'height';
  static const _keyWeight = 'weight';
  static const _keyUserGender = 'gender';
  static const _keyUserPregnant = 'pregnant';
  static const _keyUserLactating = 'lactating';
  static const _keyUserDiabetic = 'diabetic';
  static const _keyUserHyperTension = 'hyperTension';

  static const _keyHasUser = 'hasUser';

  static Future hasUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyHasUser);
  }

  static Future setUser(
    UserData userData,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDobDay, userData.dob.day);
    await prefs.setInt(_keyDobMonth, userData.dob.month);
    await prefs.setInt(_keyDobYear, userData.dob.year);
    await prefs.setInt(_keyHeight, userData.height);
    await prefs.setInt(_keyWeight, userData.weight);
    await prefs.setString(
        _keyUserGender, userData.gender == Gender.male ? "male" : "female");
    await prefs.setBool(_keyUserPregnant, userData.pregnant);
    await prefs.setBool(_keyUserLactating, userData.lactating);
    await prefs.setBool(_keyUserDiabetic, userData.diabetic);
    await prefs.setBool(_keyUserHyperTension, userData.hyperTension);
    await prefs.setBool(_keyHasUser, true);
  }

  static getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int dobDay = prefs.getInt(_keyDobDay) ?? 0;
    int dobMonth = prefs.getInt(_keyDobMonth) ?? 0;
    int dobYear = prefs.getInt(_keyDobYear) ?? 0;
    int height = prefs.getInt(_keyHeight) ?? 0;
    int weight = prefs.getInt(_keyWeight) ?? 0;
    String gender = prefs.getString(_keyUserGender) ?? '';
    bool pregnant = prefs.getBool(_keyUserPregnant) ?? false;
    bool lactating = prefs.getBool(_keyUserLactating) ?? false;
    bool diabetic = prefs.getBool(_keyUserDiabetic) ?? false;
    bool hyperTension = prefs.getBool(_keyUserHyperTension) ?? false;
    return UserData(
      dob: DateTime(dobYear, dobMonth, dobDay),
      height: height,
      weight: weight,
      gender: gender == "female" ? Gender.female : Gender.male,
      pregnant: pregnant,
      lactating: lactating,
      diabetic: diabetic,
      hyperTension: hyperTension,
    );
  }
}
