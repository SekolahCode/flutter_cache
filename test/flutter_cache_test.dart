import 'dart:convert';
import 'package:flutter_cache/flutter_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // test('Can Cache by String', () async {
  //   /* Begin Setup Test */
  //   SharedPreferences.setMockInitialValues({});
  //   await Cache.remember('data', 'key');
  //   /* End Setup Test */

  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   expect(pref.getString('key'), 'data');
  // });

  // test('Can Cache by Map', () async {
  //   /* Begin Setup Test */
  //   SharedPreferences.setMockInitialValues({});
  //   Map data = {
  //     'name' : 'Ashraf Kamarudin',
  //     'job' : 'Programmer'
  //   };
  //   await Cache.remember(data, 'key');
  //   /* End Setup Test */

  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   expect(json.decode(pref.getString('key')), data);
  // });

  // test('Can Cache by List', () async {
  //   /* Begin Setup Test */
  //   SharedPreferences.setMockInitialValues({});
  //   List<String> listString = [
  //     'Ashraf',
  //     'Kamarudin'
  //   ];
  //   List<Map> listMap = [
  //     {
  //       'name': 'Ashraf'
  //     },
  //     {
  //       'name': 'Kamarudin'
  //     }
  //   ];
  //   await Cache.remember(listString, 'string');
  //   await Cache.remember(listMap, 'map');
  //   /* End Setup Test */
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   List<String> cachedListMapInString = pref.getStringList('map');
  //   List cachedListMapInMap = cachedListMapInString.map((i)=> json.decode(i)).toList();

  //   expect(pref.getStringList('string'), listString);
  //   expect(cachedListMapInMap, listMap);
  // });

  // test('Can Load by String', () async {
  //   /* Begin Setup Test */
  //   SharedPreferences.setMockInitialValues({});
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setString('key', 'data');
  //   /* End Setup Test */

  //   expect(await Cache.load('key'), 'data');
  // });

  // test('Can Load by Map', () async {
  //   /* Begin Setup Test */
  //   SharedPreferences.setMockInitialValues({});
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   Map data = {
  //     'name' : 'Ashraf Kamarudin',
  //     'job' : 'Programmer'
  //   };
  //   pref.setString('key', json.encode(data));
  //   /* End Setup Test */

  //   /* Test */
  //   expect(await Cache.load('key'), data);
  // });

  // test('Can Load by List', () async {
  //   /* Begin Setup Test */
  //   SharedPreferences.setMockInitialValues({});
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   List<String> listString = [
  //     'Ashraf',
  //     'Kamarudin'
  //   ];
  //   List<Map> listMap = [
  //     {
  //       'name': 'Ashraf'
  //     },
  //     {
  //       'name': 'Kamarudin'
  //     }
  //   ];
  //   await Cache.remember(listString, 'string');
  //   await Cache.remember(listMap, 'map');
  //   /* End Setup Test */

  //   List<String> cachedListMapInString = await Cache.load('map', true);
  //   List cachedListMapInMap = cachedListMapInString.map((i)=> json.decode(i)).toList();

  //   /* Test */
  //   expect(await Cache.load('string', true), listString);
  //   expect(cachedListMapInMap, listMap);
  // });

  //  test('Will Retrieve Cache instead of Caching if Cache Exist', () async {
  //   /* Begin Setup Test */
  //   SharedPreferences.setMockInitialValues({});
  //   Map data = {
  //     'name' : 'Ashraf Kamarudin',
  //     'job' : 'Programmer'
  //   };
  //   await Cache.remember('data', 'key'); // for string
  //   await Cache.remember(data, 'map'); // for map
  //   /* End Setup Test */

  //   expect(await Cache.remember('data', 'key'), 'data'); // test for string
  //   expect(await Cache.remember(data, 'map'), data); // test for map
  // });

  test('It Can Cache Multiple Type', () async {
    /* Begin Test Setup */
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    String string = 'data';
    Map map = {
      'data1' : 'Ashraf Kamarudin',
      'data2' : 'Programmer'
    };
    /* End Test Setup */

    print(string);

    expect(await Cache.write(string, 'string'), string);
    // expect(pref.getString('string'), string);

    expect(await Cache.write(map, 'map'), map);
    // expect(json.decode(pref.getString('map')), map);
  });
}
