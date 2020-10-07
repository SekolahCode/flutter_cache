import 'package:flutter_cache/flutter_cache.dart' as cache;

void main() async {
  // create new cache.
  cache.remember('key', 'data');
  cache.write('key', 'data');

  // add Cache lifetime on create
  cache.remember('key', 'data', 120);
  cache.write('key', 'data', 120);

  // load Cache by key
  // return `defaultValue` if key not exists
  cache.load('key', 'defaultValue');

  // destroy single cache by key
  cache.destroy('key');

  // destroy all cache
  cache.clear();

  await cache.remember('key', () {
    return 'test'; // or logic fetching data from api;
  });

  // or

  await cache.remember('key', () => 'test');

  cache.remember('key', 'data', 120); // saved for 2 mins or 120 seconds
  cache.write('key', 'data', 120);

  // multi depth map datatype.
  cache.remember('key', {
    'name': 'Ashraf Kamarudin',
    'depth2': {
      'name': 'depth2',
      'depth3': {'name': 'depth3'}
    }
  });

  cache.load('key'); // will return data in map datatype.
}
