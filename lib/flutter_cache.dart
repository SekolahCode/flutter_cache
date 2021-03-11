library flutter_cache;

import 'dart:convert';
import 'package:flutter_cache/Cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
* This function will return cached data if exist, 
* If not exist, will create new cached data.
* 
* @return Cache.content
*/
Future remember(String key, var data, [int? expiredAt]) async {
  if (await load(key) == null) {
    if (data is Function) {
      data = await data();
    }

    return write(key, data, expiredAt);
  }

  return load(key);
}

/*
* This will overwrite data if exist and create new if not.
*
* @return Cache.content
*/
Future write(String key, var data, [int? expiredAfter]) async {
  Cache cache = new Cache(key, data);
  if (expiredAfter != null) cache.setExpiredAfter(expiredAfter);

  cache.save(cache);

  return load(key);
}

/*
* load saved cached data.
*
* @return Cache.content
*/
Future load(String key, [var defaultValue = null, bool list = false]) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Guard
  if (prefs.getString(key) == null) return defaultValue;

  if (Cache.isExpired(prefs.getInt(key + 'ExpiredAt'))) {
    destroy(key);
    return null;
  }

  Map keys = jsonDecode(prefs.getString(key)!);
  Cache cache = new Cache.rebuild(key);
  String? cacheType = prefs.getString(keys['type']);
  var cacheContent;

  if (cacheType == 'String') cacheContent = prefs.getString(keys['content']);

  if (cacheType == 'Map')
    cacheContent = jsonDecode(prefs.getString(keys['content'])!);

  if (cacheType == 'List<String>')
    cacheContent = prefs.getStringList(keys['content']);

  if (cacheType == 'List<Map>')
    cacheContent = prefs.getStringList(keys['content'])!
        .map((i) => jsonDecode(i))
        .toList();

  cache.setContent(cacheContent, keys['content']);
  cache.setType(cacheType, keys['type']);

  return cache.content;
}

/*
* will clear all shared preference data
*
* @return void
*/
void clear() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

/*
* unset single shared preference key
*
* @return void
*/
void destroy(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map keys = jsonDecode(prefs.getString(key)!);

  // remove all cache trace
  prefs.remove(key);
  prefs.remove(keys['content']);
  prefs.remove(keys['type']);
  prefs.remove(key + 'ExpiredAt');
}
