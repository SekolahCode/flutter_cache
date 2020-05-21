# flutter_cache

A simple cache package for flutter. This package is actually a wrapper for SharedPreferences on Flutter.

## Getting Started

### What Can this Package Do ?

1. Cache String, List<String>, List<Map> and Map for forever or for a limited time.
2. Load the cache you've cached.
3. Clear All Cache.
4. Clear Single Cache.

### Usage
This package has multiple static methods.

```
// This will cached `data` by its key `key`
// The Data can be String, List<String>, List<Map> and Map Type.
Cache.remember('data', 'key'); 

// The third argument is optional. It's for limited time caching.
// This will cache the data for 120 sec, or 2 minutes.
Cache.remember('data', 'key', 120); 

You can also use it this way.

// What this will do is remember() will return `data` if it's still                                                          // available in cache. If it's not available, it will return nothing                                                           // and cache the data instead.
String data = await Cache.remember('data', 'key', 120); 

Cache.load('key) // This will load the cache data.
Cache.destroy('key')
Cache.clear()

```
