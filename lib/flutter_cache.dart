library flutter_cache;

import 'dart:convert';
import 'package:flutter_cache/ShouldCache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {

  String key;
  String content;
  String type;
  int expiredAt;

  setContent (var data) {
    this.content = Parse.cacheContent(data);
  }

  setKey (String key) {
    this.key = key;
  }

  setExpiredAt () {
    this.expiredAt = Cache._currentTimeInSeconds();
  }

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
  static Future overwrite (var data, String key, [int expiredAt]) async {

    Cache cache = new Cache();

    cache.setKey(key);
    cache.setContent(data);
    cache.setExpiredAt();
    cache._save(cache);

    // if (data is List) { // return list
    //   return Cache.load(key, true);
    // }

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

  void _save (Cache cache) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(cache.key, cache.content);
  }
}

class Parse {

  static cacheContent (var data) {
    /* @type String */
    if (data is String) return data;

    /* @type Map */
    if (data is Map) return json.encode(data);

    /* @type List<String> */
    if (data is List<String>) {
      List<String> list = data.map((i) => i.toString()).toList();
      return list;
    }

    /* @type List<Map> */
    if (data is List<Map>) {
      List<String> list = data.map((i) => json.encode(i)).toList();
      return list;
    }

    /* @type List<Map> */
    if (data is ShouldCache) return json.encode(data.toMap());

    /* @type List<ShouldCache> */
    if (data is List<ShouldCache>) {
      List<String> list = data.map((i) => json.encode(i.toMap())).toList();
      return list;
    }
  }
}