library flutter_cache;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache/Parse.dart';

class Cache {

  String key;

  /* Cache Content*/
  String contentKey;
  var content;

  /* Cache Content's Type*/
  String typeKey;
  String type;

  /* Cache Expiry*/
  int expiredAfter;

  /*
  * Cache Class Constructors Section
  */
  Cache (key, data) {
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

  setExpiredAfter (int expiredAfter) {
    this.expiredAfter = expiredAfter + Cache._currentTimeInSeconds();
  }

  /*
  * This function will return cached data if exist, 
  * If not exist, will create new cached data.
  * 
  * @return Cache.content
  */
  static Future remember (String key, var data, [int expiredAt]) async {
    if (await Cache.load(key) == null) {

      if (data is Function) {
        data = data();
      }
      
      return Cache.write(key, data, expiredAt);
    }

    return Cache.load(key);
  }

  /*
  * This will overwrite data if exist and create new if not.
  *
  * @return Cache.content
  */
  static Future write (String key, var data, [int expiredAfter]) async {

    Cache cache = new Cache(key, data);
    if (expiredAfter != null) cache.setExpiredAfter(expiredAfter);

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

    // Guard
    if (prefs.getString(key) == null) return null;
    if (Cache._isExpired(prefs.getInt(key + 'ExpiredAt'))) {
      Cache.destroy(key + 'ExpiredAt');
      Cache.destroy(key);

      return null;
    }
  
    Map keys    = jsonDecode(prefs.getString(key));
    Cache cache = new Cache.rebuild(key);

    if (prefs.getString(keys['type']) == 'String') cache.setContent(prefs.getString(keys['content']), keys['content']);
    if (prefs.getString(keys['type']) == 'Map') cache.setContent(jsonDecode(prefs.getString(keys['content'])), keys['content']);
    if (prefs.getString(keys['type']) == 'List<String>') cache.setContent(prefs.getStringList(keys['content']), keys['content']);
    if (prefs.getString(keys['type']) == 'List<Map>') {
      List list = (prefs.getStringList(keys['content'])).map((i) => jsonDecode(i)).toList();
      cache.setContent(list, keys['content']);
    }

    cache.setType(prefs.getString(keys['type']), keys['type']);

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
    if (cache.expiredAfter != null) prefs.setInt(key + 'ExpiredAt', cache.expiredAfter);

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
  * All functions should be private.
  */
  String _generateCompositeKey(String keyType) {
    return keyType + Cache._currentTimeInSeconds().toString() + this.key;
  }

  static int _currentTimeInSeconds() { // private
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  static bool _isExpired(int cacheExpiryInfo) {
    if (cacheExpiryInfo != null && cacheExpiryInfo < Cache._currentTimeInSeconds()) {
      return true;
    }

    return false;
  }
}