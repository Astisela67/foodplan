import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/recipe.dart';
import '../util/date_util.dart';

class ShoppingItem {
  final String key;
  final String name;
  final String qty;
  final String category;
  final bool purchased;
  final bool manual;
  final double amount;

  const ShoppingItem({
    required this.key,
    required this.name,
    required this.qty,
    required this.category,
    required this.purchased,
    required this.manual,
    required this.amount,
  });
}

class _Agg {
  final String name;
  final String unit;
  final String category;
  double amount;
  _Agg(this.name, this.amount, this.unit, this.category);
}

/// State utama aplikasi: akun, profil, rencana menu, daftar belanja.
/// Semua data disimpan lokal (SharedPreferences) per pengguna.
class AppState extends ChangeNotifier {
  AppState(this._prefs) {
    _load();
  }

  static Future<AppState> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AppState(prefs);
  }

  final SharedPreferences _prefs;
  Map<String, dynamic> _users = {};
  String? _currentUser;
  Map<String, dynamic> _data = _defaultData();
  DateTime selectedPlanDate = dateOnly(DateTime.now());

  static Map<String, dynamic> _defaultData() => <String, dynamic>{
        'age': null,
        'weight': null,
        'height': null,
        'goal': 'Hidup Sehat',
        'vegOnly': false,
        'targets': <String, dynamic>{'cal': 2000, 'pro': 100, 'carb': 250, 'fat': 70},
        'plan': <String, dynamic>{},
        'manual': <dynamic>[],
        'purchased': <dynamic>[],
        'bought': <String, dynamic>{},
      };

  // ------------------------------------------------------------ storage
  void _load() {
    final raw = _prefs.getString('users');
    if (raw != null) {
      _users = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    }
    final cu = _prefs.getString('currentUser');
    if (cu != null && _users.containsKey(cu)) {
      _currentUser = cu;
      _loadData(cu);
    }
    // Tanpa login: otomatis pakai satu pengguna lokal di perangkat ini.
    if (_currentUser == null) {
      final u = _users.isNotEmpty ? _users.keys.first : 'pengguna';
      _users.putIfAbsent(u, () => {'name': '', 'hash': ''});
      _prefs.setString('users', jsonEncode(_users));
      _prefs.setString('currentUser', u);
      _currentUser = u;
      _loadData(u);
    }
  }

  void _loadData(String u) {
    final raw = _prefs.getString('data_$u');
    final d = _defaultData();
    if (raw != null) {
      d.addAll(Map<String, dynamic>.from(jsonDecode(raw) as Map));
    }
    _data = d;
  }

  void _saveData() {
    if (_currentUser == null) return;
    _prefs.setString('data_$_currentUser', jsonEncode(_data));
  }

  void _commit() {
    notifyListeners();
    _saveData();
  }

  // --------------------------------------------------------------- akun
  bool get isLoggedIn => _currentUser != null;
  String get username => _currentUser ?? '';
  String get name => (_users[_currentUser]?['name'] as String?) ?? '';

  String _hash(String u, String p) => sha256.convert(utf8.encode('$u:$p')).toString();

  Future<String?> register(String name, String username, String password) async {
    final u = username.trim().toLowerCase();
    if (_users.containsKey(u)) return 'Username sudah dipakai';
    _users[u] = {'name': name.trim(), 'hash': _hash(u, password)};
    await _prefs.setString('users', jsonEncode(_users));
    _currentUser = u;
    _data = _defaultData();
    selectedPlanDate = dateOnly(DateTime.now());
    await _prefs.setString('currentUser', u);
    _saveData();
    notifyListeners();
    return null;
  }

  Future<String?> login(String username, String password) async {
    final u = username.trim().toLowerCase();
    final user = _users[u];
    if (user == null || user['hash'] != _hash(u, password)) {
      return 'Username atau kata sandi salah';
    }
    _currentUser = u;
    _loadData(u);
    selectedPlanDate = dateOnly(DateTime.now());
    await _prefs.setString('currentUser', u);
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    _currentUser = null;
    _data = _defaultData();
    await _prefs.remove('currentUser');
    notifyListeners();
  }

  Future<String?> changePassword(String oldPw, String newPw) async {
    final u = _currentUser;
    if (u == null) return 'Belum masuk';
    if (_users[u]['hash'] != _hash(u, oldPw)) return 'Kata sandi lama salah';
    _users[u]['hash'] = _hash(u, newPw);
    await _prefs.setString('users', jsonEncode(_users));
    return null;
  }

  // ------------------------------------------------------------- profil
  int? get age => (_data['age'] as num?)?.toInt();
  int? get weight => (_data['weight'] as num?)?.toInt();
  int? get height => (_data['height'] as num?)?.toInt();
  String get goal => (_data['goal'] as String?) ?? 'Hidup Sehat';
  bool get vegOnly => _data['vegOnly'] == true;

  void updateProfile(String name, int? age, int? weight, int? height, String goal) {
    if (_currentUser != null) {
      _users[_currentUser]['name'] = name.trim();
      _prefs.setString('users', jsonEncode(_users));
    }
    _data['age'] = age;
    _data['weight'] = weight;
    _data['height'] = height;
    _data['goal'] = goal;
    _commit();
  }

  void setVegOnly(bool v) {
    _data['vegOnly'] = v;
    _commit();
  }

  // ------------------------------------------------------------ target
  int target(String k) => ((_data['targets'] as Map)[k] as num).toInt();

  void setTargets(int cal, int pro, int carb, int fat) {
    _data['targets'] = <String, dynamic>{'cal': cal, 'pro': pro, 'carb': carb, 'fat': fat};
    _commit();
  }

  // ------------------------------------------------------- rencana menu
  Map<String, dynamic> get _plan => _data['plan'] as Map<String, dynamic>;

  void selectPlanDate(DateTime d) {
    selectedPlanDate = dateOnly(d);
    notifyListeners();
  }

  Recipe? mealAt(DateTime d, String type) {
    final day = _plan[dateKey(d)] as Map?;
    final id = day?[type] as String?;
    return id == null ? null : recipeById(id);
  }

  bool hasPlan(DateTime d) => (_plan[dateKey(d)] as Map?)?.isNotEmpty ?? false;

  void setMeal(DateTime d, String type, Recipe r) {
    final k = dateKey(d);
    final day = Map<String, dynamic>.from((_plan[k] as Map?) ?? {});
    day[type] = r.id;
    _plan[k] = day;
    _afterPlanChange();
  }

  void removeMeal(DateTime d, String type) {
    final k = dateKey(d);
    final day = Map<String, dynamic>.from((_plan[k] as Map?) ?? {});
    day.remove(type);
    if (day.isEmpty) {
      _plan.remove(k);
    } else {
      _plan[k] = day;
    }
    _afterPlanChange();
  }

  void clearPlan() {
    _data['plan'] = <String, dynamic>{};
    _afterPlanChange();
  }

  Map<String, int> nutritionFor(DateTime d) {
    int cal = 0, pro = 0, carb = 0, fat = 0;
    for (final t in mealTypes) {
      final r = mealAt(d, t);
      if (r != null) {
        cal += r.calories;
        pro += r.protein;
        carb += r.carbs;
        fat += r.fat;
      }
    }
    return {'cal': cal, 'pro': pro, 'carb': carb, 'fat': fat};
  }

  List<DateTime> get historyDates {
    final today = dateOnly(DateTime.now());
    final list = _plan.keys.map(parseKey).where((d) => !d.isAfter(today)).toList();
    list.sort((a, b) => b.compareTo(a));
    return list;
  }

  // ----------------------------------------------------- daftar belanja
  List get _manualList => _data['manual'] as List;
  List get _purchasedList => _data['purchased'] as List;
  Map<String, dynamic> get _bought => _data['bought'] as Map<String, dynamic>;

  Map<String, _Agg> _aggregate() {
    final today = dateOnly(DateTime.now());
    final agg = <String, _Agg>{};
    _plan.forEach((k, v) {
      if (parseKey(k).isBefore(today)) return;
      (v as Map).forEach((type, id) {
        final r = recipeById(id as String);
        if (r == null) return;
        for (final ing in r.ingredients) {
          final key = '${ing.name}|${ing.unit}';
          final e = agg[key];
          if (e == null) {
            agg[key] = _Agg(ing.name, ing.amount, ing.unit, ing.category);
          } else {
            e.amount += ing.amount;
          }
        }
      });
    });
    return agg;
  }

  List<ShoppingItem> get shoppingItems {
    final items = <ShoppingItem>[];
    final purchased = _purchasedList.toSet();
    _aggregate().forEach((key, a) {
      final remaining = a.amount - ((_bought[key] as num?)?.toDouble() ?? 0);
      if (remaining <= 0.0001) return;
      items.add(ShoppingItem(
        key: key,
        name: a.name,
        qty: formatQty(remaining, a.unit),
        category: a.category,
        purchased: purchased.contains(key),
        manual: false,
        amount: remaining,
      ));
    });
    for (final m in _manualList) {
      final mm = m as Map;
      items.add(ShoppingItem(
        key: mm['id'] as String,
        name: mm['name'] as String,
        qty: mm['qty'] as String,
        category: mm['category'] as String,
        purchased: mm['purchased'] == true,
        manual: true,
        amount: 0,
      ));
    }
    items.sort((a, b) {
      final c = shoppingCategories.indexOf(a.category).compareTo(shoppingCategories.indexOf(b.category));
      return c != 0 ? c : a.name.compareTo(b.name);
    });
    return items;
  }

  void togglePurchased(ShoppingItem item, bool value) {
    if (item.manual) {
      for (final m in _manualList) {
        final mm = m as Map;
        if (mm['id'] == item.key) mm['purchased'] = value;
      }
    } else {
      _purchasedList.remove(item.key);
      if (value) _purchasedList.add(item.key);
    }
    _commit();
  }

  void addManual(String name, String qty, String category) {
    _manualList.add(<String, dynamic>{
      'id': 'm${DateTime.now().microsecondsSinceEpoch}',
      'name': name,
      'qty': qty,
      'category': category,
      'purchased': false,
    });
    _commit();
  }

  void deleteManual(String id) {
    _manualList.removeWhere((m) => (m as Map)['id'] == id);
    _commit();
  }

  /// Checkout: bahan yang sudah dibeli dianggap sudah dimiliki dan
  /// disembunyikan dari daftar. Mengembalikan jumlah bahan yang di-checkout.
  int checkout() {
    final items = shoppingItems.where((i) => i.purchased).toList();
    for (final i in items) {
      if (i.manual) {
        _manualList.removeWhere((m) => (m as Map)['id'] == i.key);
      } else {
        _bought[i.key] = ((_bought[i.key] as num?)?.toDouble() ?? 0) + i.amount;
        _purchasedList.remove(i.key);
      }
    }
    _commit();
    return items.length;
  }

  void _afterPlanChange() {
    final keys = _aggregate().keys.toSet();
    _bought.removeWhere((k, _) => !keys.contains(k));
    _purchasedList.removeWhere((k) => !keys.contains(k));
    _commit();
  }
}
