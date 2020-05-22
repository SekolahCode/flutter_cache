import 'package:flutter_cache/flutter_cache.dart';

void main() async {

  // create new cache.
  Cache.remember('key', 'data'); 
  Cache.write('key', 'data'); 

  // add Cache lifetime on create
  Cache.remember('key', 'data', 120); 
  Cache.write('key', 'data', 120); 

  // load Cache by key
  Cache.load('key'); // This will load the cache data.

  // destroy single cache by key
  Cache.destroy('key');

  // destroy all cache
  Cache.clear();

  await Cache.remember('key', () {
    return 'test'; // or logic fetching data from api;
  });

  // or 

  await Cache.remember('key', () => 'test');

  Cache.remember('key', 'data', 120); // saved for 2 mins or 120 seconds
  Cache.write('key', 'data', 120);

  // multi depth map datatype.
  Cache.remember('key', { 
    'name' : 'Ashraf Kamarudin',
    'depth2' : {
      'name' : 'depth2',
      'depth3' : {
        'name': 'depth3'
      } 
    }
  });

  Cache.load('key'); // will return data in map datatype.
}