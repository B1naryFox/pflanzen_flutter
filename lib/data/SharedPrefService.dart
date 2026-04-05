import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' show Future;

class SharedPrefService {
  static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    print('preferences initialised: ${_prefsInstance != null}');
    return _prefsInstance!;
  }

  static int? getSortIndex(){
    return _prefsInstance!.getInt('sorting');
  }

  static (int?, int?) getNotificationTime(){
    return (_prefsInstance!.getInt('hour'), _prefsInstance!.getInt('minute'));
  }

  static Future<bool> setSort(int index) async {
    var prefs = await _instance;
    return prefs?.setInt('sorting', index) ?? Future.value(false);
  }

  static Future<bool> setNotificationTime(int hour, int minute) async {
    var h = await setTime('hour', hour);
    var m = await setTime('minute', minute);
    return h && m;
  }

  static Future<bool> setTime(String key, int time) async{
    var prefs = await _instance;
    return prefs?.setInt(key, time) ?? Future.value((false));
  }

/* first try
  static final SharedPrefService _service = SharedPrefService._();

  // Constructors
  SharedPrefService._() {
    _initPref();
  }
  factory SharedPrefService() => _service;

  static SharedPreferences? _preferences;
  Sorting? _sortOpt;
  TimeOfDay? _notificationTime;

  Future<SharedPreferences> get preferences async {
    if (_preferences != null) return _preferences!;
    _preferences = await _initPref();
    return _preferences!;
  }

  Future<SharedPreferences> _initPref() async {
    print('init prefs');
    return await SharedPreferences.getInstance();
  }

  bool loadedPreferences(){
    preferences;
// Sorting prefs
    final savedSort = _preferences!.getString('sorting') ?? Sorting.NAME.title;

    final sort = Sorting.values.singleWhere((e) => e.title == savedSort);
    _sortOpt = sort;


// Notification prefs
    _notificationTime = TimeOfDay(hour: _preferences!.getInt('hour') ?? 8, minute: _preferences!.getInt('minute') ?? 0);
    print('Preferences loaded');
    print(sortOpt);
    return true;
  }

  void savePreferences() async {
    preferences;
    await _preferences!.setString('sorting', sortOpt.title);
    await _preferences!.setInt('hour', notificationTime.hour);
    await _preferences!.setInt('minute', notificationTime.minute);
    print('saved');
  }

  void setSortOpt(Sorting pickedSort){
    _sortOpt = pickedSort;
    savePreferences();
  }

  Sorting get sortOpt{
    return _sortOpt ?? Sorting.NAME;
  }

  void setNotificationTime(TimeOfDay pickedTime){
    _notificationTime = pickedTime;
    savePreferences();
  }

  TimeOfDay get notificationTime{
    return _notificationTime ?? TimeOfDay(hour: 8, minute: 0);
  }
*/
}

enum Sorting {
  NAME("Name"),
  GIESSDATUM("Gießdatum");

  final String title;
  const Sorting(this.title);
}