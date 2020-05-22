library flutter_cache;

import 'dart:convert';
import 'package:flutter_cache/ShouldCache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {

  String key;

  String contentKey;
  String content;

  String typeKey;
  String type;

  String expiredAtKey;
  int expiredAt;

  Cache (data, key) {
    Map parsedData = Parse.content(data);

    this.key = key;
    this.setContent(parsedData['content']);
    this.setType(parsedData['type']);
  }

  Cache.rebuild (key) {
    this.key = key;
  }

  setKey (String key) {
    this.key = key;
  }

  setContent (var data , [String contentKey]) {
    this.content = data;
    this.contentKey = contentKey ?? this._generateCompositeKey('content');
  }

  setType (String type , [String typeKey]) {
    this.type = type;
    this.typeKey = typeKey  ?? this._generateCompositeKey('type');
  }

  setExpiredAt () {
    this.expiredAt = Cache._currentTimeInSeconds();
  }

  String _generateCompositeKey(String keyType) {
    return keyType + Cache._currentTimeInSeconds().toString() + this.key;
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

    Cache cache = new Cache(data, key);
    cache.setExpiredAt();
    cache._save(cache);

    // if (data is List) { // return list
    //   return Cache.load(key, true);
    // }

    return Cache.load(key);
  }

  static Future load (String key, [bool list = false]) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map keys = json.decode(prefs.getString(key));

    Cache cache = new Cache.rebuild(key);
    cache.setContent(prefs.getString(keys['content']), keys['content']);
    cache.setType(prefs.getString(keys['type']), keys['type']);
    cache.setExpiredAt();

    return cache.type == 'String' 
      ? cache.content
      : jsonDecode(cache.content);
  }

  void _save (Cache cache) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> map = {
      'content' : cache.contentKey,
      'type'    : cache.typeKey
    };

    prefs.setString(cache.key, jsonEncode(map));
    prefs.setString(cache.contentKey, cache.content);
    prefs.setString(cache.typeKey, cache.type);
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

class Parse {

  static content (var data) {
    /* @type String */
    if (data is String) return {
      'content' : data,
      'type'    : 'String'
    };

    /* @type Map */
    if (data is Map) return {
      'content' : json.encode(data),
      'type'    : 'Map'
    };

    throw ('Unsupported Data Type');

    // /* @type List<String> */
    // if (data is List<String>) {
    //   List<String> list = data.map((i) => i.toString()).toList();
    //   return list;
    // }

    // /* @type List<Map> */
    // if (data is List<Map>) {
    //   List<String> list = data.map((i) => json.encode(i)).toList();
    //   return list;
    // }

    // /* @type List<Map> */
    // if (data is ShouldCache) return json.encode(data.toMap());

    // /* @type List<ShouldCache> */
    // if (data is List<ShouldCache>) {
    //   List<String> list = data.map((i) => json.encode(i.toMap())).toList();
    //   return list;
    // }
  }
}