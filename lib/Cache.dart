import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache/Parse.dart';

class Cache {
  late String key;

  /* Cache Content*/
  String? contentKey;
  var content;

  /* Cache Content's Type*/
  String? typeKey;
  String? type;

  /* Cache Expiry*/
  int? expiredAfter;

  /*
  * Cache Class Constructors Section
  */
  Cache(key, data) {
    Map parsedData = Parse.content(data);

    this.key = key;
    this.setContent(parsedData['content']);
    this.setType(parsedData['type']);
  }

  Cache.rebuild(key) {
    this.key = key;
  }

  /*
  * Cache Class Setters & Getters
  */
  setKey(String key) {
    this.key = key;
  }

  setContent(var data, [String? contentKey]) {
    this.content = data;
    this.contentKey = contentKey ?? this.generateCompositeKey('content');
  }

  setType(String? type, [String? typeKey]) {
    this.type = type;
    this.typeKey = typeKey ?? this.generateCompositeKey('type');
  }

  setExpiredAfter(int expiredAfter) {
    this.expiredAfter = expiredAfter + Cache.currentTimeInSeconds();
  }

  /*
  * Saved cached contents into Shared Preference
  *
  * @return void
  */
  void save(Cache cache) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // set Original Cache key to cache content's key and cache type's key
    prefs.setString(cache.key,
        jsonEncode({'content': cache.contentKey, 'type': cache.typeKey}));

    if (cache.content is String)
      prefs.setString(cache.contentKey!, cache.content);

    if (cache.content is List)
      prefs.setStringList(cache.contentKey!, cache.content);

    if (cache.expiredAfter != null)
      prefs.setInt(key + 'ExpiredAt', cache.expiredAfter!);

    prefs.setString(cache.typeKey!, cache.type!);
  }

  /*
  * Cache Class Helper Function Section
  *
  * This is where all custom functions used by this class reside.
  * All functions should be private.
  */
  String generateCompositeKey(String keyType) {
    return keyType + Cache.currentTimeInSeconds().toString() + this.key;
  }

  static int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  static bool isExpired(int? cacheExpiryInfo) {
    if (cacheExpiryInfo != null &&
        cacheExpiryInfo < Cache.currentTimeInSeconds()) {
      return true;
    }

    return false;
  }
}
