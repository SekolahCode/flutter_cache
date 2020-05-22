import 'dart:convert';

class Parse {

  static content (var data) {
    /* @type String */
    if (data is String) return {
      'content' : data,
      'type'    : 'String'
    };

    /* @type Map */
    if (data is Map) return {
      'content' : jsonEncode(data),
      'type'    : 'Map'
    };

    /* @type List<String> */
    if (data is List<String>) {
      return {
        'content' : data,
        'type'    : 'List<String>'
      };
    }

    /* @type List<Map> */
    if (data is List<Map>) {
      List<String> list = data.map((i) => jsonEncode(i)).toList();
      return {
        'content' : list,
        'type'    : 'List<Map>'
      };
    }

    throw ('Unsupported Data Type');
  }
}