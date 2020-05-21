library flutter_cache;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {

  /*
  * This function will return cached data if exist, null if created
  */
  static Future remember (var data, String key, [int expiredAt]) async {
    try {
      var cacheData;
      data is List
        ? cacheData = await Cache.load(key, true)
        : cacheData = await Cache.load(key);

        if (cacheData == null) {
          throw('No Cache Data'); // throw to create new cache
        } else {
          return cacheData;
        }
    } catch (e) {
      expiredAt == null 
        ?  Cache.overwrite(data, key)
        :  Cache.overwrite(data, key, expiredAt);
    }
  }

  /*
  * This is where the date is saved in Shared Preference
  */
  static Future<void> overwrite (var data, String key, [int expiredAt]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /* @type String */
    if (data is String) prefs.setString(key, data);

    /* @type Map */
    if (data is Map) prefs.setString(key, json.encode(data));

    /* @type List<String> */
    if (data is List<String>) {
      List<String> list = data.map((i) => i.toString()).toList();
      prefs.setStringList(key, list);
    }

    /* @type List<Map> */
    if (data is List<Map>) {
      List<String> list = data.map((i) => json.encode(i)).toList();
      prefs.setStringList(key, list);
    }

    if (expiredAt != null) prefs.setString(key + 'ExpiredAt', (Cache._currentTimeInSeconds() + expiredAt).toString());

    if (data is List) { // return list
      return Cache.load(key, true);
    }

    return Cache.load(key);
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
