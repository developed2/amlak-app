import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property.dart';
import '../data/sample_data.dart';

class AppState extends ChangeNotifier {
  List<Property> _custom = [];
  final Set<String> _favorites = {};

  String searchQuery = '';
  String selectedCity = 'همه';
  DealType? selectedDeal;
  PropertyType? selectedType;
  int? minArea;
  int? maxPrice;

  bool _loaded = false;
  bool get loaded => _loaded;

  List<Property> get all => [..._custom, ...sampleProperties];

  Set<String> get favorites => _favorites;

  List<Property> get filtered {
    final q = searchQuery.trim();
    return all.where((p) {
      if (selectedCity != 'همه' && p.city != selectedCity) return false;
      if (selectedDeal != null && p.deal != selectedDeal) return false;
      if (selectedType != null && p.type != selectedType) return false;
      if (minArea != null && p.area < minArea!) return false;
      if (maxPrice != null && p.price > maxPrice!) return false;
      if (q.isNotEmpty) {
        final hay = '${p.title} ${p.city} ${p.address} ${p.description}';
        if (!hay.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  List<Property> get favoriteItems =>
      all.where((p) => _favorites.contains(p.id)).toList();

  bool isFav(String id) => _favorites.contains(id);

  Future<void> load() async {
    if (_loaded) return;
    try {
      final sp = await SharedPreferences.getInstance();
      final rawCustom = sp.getString('custom_props');
      if (rawCustom != null && rawCustom.isNotEmpty) {
        _custom = Property.decodeList(rawCustom);
      }
      final favs = sp.getStringList('favs') ?? [];
      _favorites.addAll(favs);
    } catch (_) {
      // اگر خطا داد، با داده نمونه ادامه بده
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveCustom() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('custom_props', Property.encodeList(_custom));
  }

  Future<void> _saveFavs() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList('favs', _favorites.toList());
  }

  Future<void> addProperty(Property p) async {
    _custom.insert(0, p);
    notifyListeners();
    await _saveCustom();
  }

  Future<void> removeProperty(String id) async {
    _custom.removeWhere((e) => e.id == id);
    _favorites.remove(id);
    notifyListeners();
    await _saveCustom();
    await _saveFavs();
  }

  Future<void> toggleFav(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
    await _saveFavs();
  }

  void setSearch(String v) {
    searchQuery = v;
    notifyListeners();
  }

  void setCity(String v) {
    selectedCity = v;
    notifyListeners();
  }

  void setFilters({DealType? deal, PropertyType? type, int? minAreaP, int? maxPriceP}) {
    selectedDeal = deal;
    selectedType = type;
    minArea = minAreaP;
    maxPrice = maxPriceP;
    notifyListeners();
  }

  void clearFilters() {
    selectedDeal = null;
    selectedType = null;
    minArea = null;
    maxPrice = null;
    selectedCity = 'همه';
    searchQuery = '';
    notifyListeners();
  }

  Property? byId(String id) {
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
