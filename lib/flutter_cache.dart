library flutter_cache;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {

  static Future remember (var data, String key, [int expiredAt]) async {
    try {
      var x;
      data is List
        ? x = await Cache.load(key, true)
        : x = await Cache.load(key);

        if (x == null) {
          throw('Null');
        } else {
          return x;
        }
    } catch (e) {
      expiredAt == null 
        ?  Cache.overwrite(data, key)
        :  Cache.overwrite(data, key, expiredAt);
    }
  }

  static Future<void> overwrite (var data, String key, [int expiredAt]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (data is Map) prefs.setString(key, json.encode(data));
    if (data is List) {
      List<String> list = data.map((i) => json.encode(i.toMap())).toList();
      prefs.setStringList(key, list);
    }
    if (data is String) prefs.setString(key, data);

    if (expiredAt != null) prefs.setString(key + 'ExpiredAt', (Cache._currentTimeInSeconds() + expiredAt).toString());
  }

  static Future load (String key, [bool list = false]) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cacheData        = prefs.getString(key + 'ExpiredAt');

    if (cacheData != null) {
      int time = int.parse(cacheData);
      if (time < Cache._currentTimeInSeconds()) {
        prefs.remove(key + 'ExpiredAt');
        prefs.remove(key);
      }
    }

    if (list) {
      return prefs.getStringList(key);
    }

    try {
      return json.decode(prefs.getString(key));
    } catch (e) {
      return prefs.getString(key);
    }
  }

  static Future clear () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future destroy (String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static int _currentTimeInSeconds() { // private
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }
}
