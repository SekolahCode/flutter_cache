library flutter_cache;

import 'dart:convert';
import 'package:flutter_cache/ShouldCache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {

  String key;

  /* Cache Content*/
  String contentKey;
  var content;

  /* Cache Content's Type*/
  String typeKey;
  String type;

  /* Cache Expiry*/
  String expiredAtKey;
  int expiredAt;

  /*
  * Cache Class Constructors Section
  */
  Cache (data, key) {
    Map parsedData = Parse.content(data);

    this.key = key;
    this.setContent(parsedData['content']);
    this.setType(parsedData['type']);
  }

  Cache.rebuild (key) {
    this.key = key;
  }

  /*
  * Cache Class Setters & Getters
  */  
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

  /*
  * This function will return cached data if exist, 
  * If not exist, will create new cached data.
  * 
  * @return Cache.content
  */
  static Future remember (var data, String key, [int expiredAt]) async {
    if (await Cache.load(key) == null) {
      return Cache.write(data, key, expiredAt);
    }

    return Cache.load(key);
  }

  /*
  * This will overwrite data if exist and create new if not.
  *
  * @return Cache.content
  */
  static Future write (var data, String key, [int expiredAt]) async {

    Cache cache = new Cache(data, key);
    cache.setExpiredAt();
    cache._save(cache);

    return Cache.load(key);
  }

  /*
  * load saved cached data.
  *
  * @return Cache.content
  */
  static Future load (String key, [bool list = false]) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(key) == null) return prefs.getString(key);
  
    Map keys    = jsonDecode(prefs.getString(key));
    Cache cache = new Cache.rebuild(key);

    if (prefs.getString(keys['type']) == 'String') cache.setContent(prefs.getString(keys['content']), keys['content']);
    if (prefs.getString(keys['type']) == 'Map') cache.setContent(jsonDecode(prefs.getString(keys['content'])), keys['content']);
    if (prefs.getString(keys['type']) == 'List<String>') cache.setContent(prefs.getStringList(keys['content']), keys['content']);

    // cache.setContent(prefs.getString(keys['content']), keys['content']);
    cache.setType(prefs.getString(keys['type']), keys['type']);
    cache.setExpiredAt();

    return cache.content;
  }

  /*
  * Saved cached contents into Shared Preference
  *
  * @return void
  */
  void _save (Cache cache) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> map = {
      'content' : cache.contentKey,
      'type'    : cache.typeKey
    };

    prefs.setString(cache.key, jsonEncode(map));

    if (cache.content is String) prefs.setString(cache.contentKey, cache.content);
    if (cache.content is List) prefs.setStringList(cache.contentKey, cache.content);

    prefs.setString(cache.typeKey, cache.type);
  }

  /*
  * will clear all shared preference data
  *
  * @return void
  */
  static Future clear () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  /*
  * unset single shared preference key
  *
  * @return void
  */
  static Future destroy (String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  /*
  * Cache Class Helper Function Section
  *
  * This is where all custom functions used by this class reside.
  */
  String _generateCompositeKey(String keyType) {
    return keyType + Cache._currentTimeInSeconds().toString() + this.key;
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

    /* @type List<String> */
    if (data is List<String>) {
      List<String> list = data.map((i) => i.toString()).toList();
      return {
        'content' : list,
        'type'    : 'List<String>'
      };
    }

    throw ('Unsupported Data Type');

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