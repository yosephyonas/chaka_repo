import 'package:hive/hive.dart';
import '../model/country_model.dart';

class FavoritesService {
  static const String boxName = 'favoritesBox';

  static Future<void> addToFavorites(Country country) async {
    var box = await Hive.openBox(boxName);
    box.put(country.name, country.toJson()); 
  }

  static Future<List<Country>> getFavorites() async {
    var box = await Hive.openBox(boxName);
    return box.values.map((json) => Country.fromJson(json)).toList();
  }
}
