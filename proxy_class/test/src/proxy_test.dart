library proxy_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/matcher.dart' as m;

import 'package:proxy_class/proxy_class.dart';

main() {
  group('Proxy class', () {
    String stringValue = "value";
    var objectValue = new TestClass();
    TestClass instance;
    dynamic proxy;
    
    setUp(() {
      instance = new TestClass();
      proxy = new Proxy(new InstanceHolder.forInstance(instance));
    });
    
    test('gets field', () {
      expect(proxy.field, m.equals(instance.field));
    });

    test('sets string to field', () {
      proxy.field = stringValue;
      expect(instance.field, m.equals(stringValue));
    });
    
    test('sets object to field', () {
      proxy.field = objectValue;
      expect(instance.field, m.equals(objectValue));
    });
    
    test('sets null to field', () {
      proxy.field = null;
      expect(instance.field, m.isNull);
    });
    
    test('gets getter', () {
      expect(proxy.getter, m.equals(instance.getter));
    });

    test('sets string to setter=', () {
      proxy.setter = stringValue;
      expect(instance.setter, m.equals(stringValue));
    });

    test('sets object to setter=', () {
      proxy.setter = objectValue;
      expect(instance.setter, m.equals(objectValue));
    });
    
    test('sets null to setter=', () {
      proxy.setter = null;
      expect(instance.setter, m.isNull);
    });
    
    test('calls concat', () {
      expect(proxy.concat("aa", "bb", d: "dd"), m.equals("aabbdd"));
    });
    
    test('calls sum', () {
      expect(proxy.sum(3, 5, 7), m.equals(15));
    });
    
    test('calls operator []', () {
      expect(proxy["key"], m.equals(instance["key"]));
    });
    
    test('calls operator []=', () {
      proxy[stringValue] = objectValue;
      expect(instance[stringValue], m.equals(objectValue));
    });
  });
}

class TestClass {
  Map values = new Map.from({"key": "value"});
  var field = "field";
  
  get getter => "getter";
  get setter => field;
  set setter(value) => field = value;
  
  String concat(String a, String b, {String c: "", String d: ""}) => "$a$b$c$d";
  num sum(num a, num b, [num c = 0, num d = 0]) => a + b + c + d;
  operator [](key) => values[key]; 
  operator []=(key, value) => values[key] = value; 
}