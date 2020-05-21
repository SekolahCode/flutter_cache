import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_cache/flutter_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Can Cache by String', () async {
    /* Begin Setup Test */
    SharedPreferences.setMockInitialValues({});
    await Cache.remember('data', 'key');
    /* End Setup Test */

    SharedPreferences pref = await SharedPreferences.getInstance();
    expect(pref.getString('key'), 'data');
  });

  test('Can Cache by Map', () async {
    /* Begin Setup Test */
    SharedPreferences.setMockInitialValues({});
    Map data = {
      'name' : 'Ashraf Kamarudin',
      'job' : 'Programmer'
    };
    await Cache.remember(data, 'key');
    /* End Setup Test */

    SharedPreferences pref = await SharedPreferences.getInstance();
    expect(json.decode(pref.getString('key')), data);
  });

  test('Can Load by String', () async {
    /* Begin Setup Test */
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('key', 'data');
    /* End Setup Test */

    expect(await Cache.load('key'), 'data');
  });

  test('Can Load by Map', () async {
    /* Begin Setup Test */
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {
      'name' : 'Ashraf Kamarudin',
      'job' : 'Programmer'
    };
    pref.setString('key', json.encode(data));
    /* End Setup Test */

    /* Test */
    expect(await Cache.load('key'), data);
  });

   test('Will Retrieve Cache instead of Caching if Cache Exist', () async {
    /* Begin Setup Test */
    SharedPreferences.setMockInitialValues({});
    Map data = {
      'name' : 'Ashraf Kamarudin',
      'job' : 'Programmer'
    };
    await Cache.remember('data', 'key'); // for string
    await Cache.remember(data, 'map'); // for map
    /* End Setup Test */

    expect(await Cache.remember('data', 'key'), 'data'); // test for string
    expect(await Cache.remember(data, 'map'), data); // test for map
  });

}
