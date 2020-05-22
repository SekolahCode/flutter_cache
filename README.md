# flutter_cache

A simple cache package for flutter. This package is a wrapper for shared preference and makes working with shared preference easier. Once it has been installed, you can do these things.

```dart
// create new cache.
Cache.remember('data', 'key'); 
Cache.write('data', 'key'); 

// add Cache lifetime on create
Cache.remember('data', 'key', 120); 
Cache.write('data', 'key', 120); 

// load Cache by key
Cache.load('key); // This will load the cache data.

// destroy single cache by key
Cache.destroy('key');

// destroy all cache
Cache.clear();

```
## Getting Started

### Installation

First include the package dependency in your project's `pubspec.yaml` file

```yaml
dependencies:
  flutter_cache: ^0.0.1
```

You can install the package via pub get:

```bash
flutter pub get
```

Then you can import it in your dart code like so

```dart
import 'package:flutter_cache/flutter_cache.dart';
```

### What Can this Package Do ?

1. Cache String, List<String>, List<Map> and Map for forever or for a limited time.
2. Load the cache you've cached.
3. Clear All Cache.
4. Clear Single Cache.

### Usage

#### Cache Fetch Data from API

If data already exist, then it will use the data in the cache. If it's not, It will fetch the data. You can also set Cache lifetime so your app would fetch again everytime the Cache dies.

```dart
await Cache.remember('string', () {
  return 'test' // or logic fetching data from api;
});

// or 

await Cache.remember('string', () => 'test')
```

#### Saved data for limited time

The data will be destroyed when it reached the time you set.

```dart
Cache.remember('data', 'key', 120); // saved for 2 mins or 120 seconds
Cache.write('data', 'key', 120);
```

#### Cache multipe datatype

You can cache multiple datatype. Supported datatype for now are String, Map, List<String> and List<Map>. When you use `cache.load()` to get back the data, it will return the data in the original datatype.

```dart
Cache.remember({ // multi depth map datatype.
  'name' : 'Ashraf Kamarudin',
  'depth2' : {
    'name' : 'depth2',
    'depth3' : {
      'name': 'depth3'
    } 
  }
}, 'key)

Cache.load('key'); // will return data in map datatype.
```
