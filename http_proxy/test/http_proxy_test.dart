import '../bin/http_proxy.dart' as Proxy;
import 'dart:async';
import 'dart:io';
import 'package:unittest/unittest.dart';

void main() {
  group('Proxy', () {
    HttpServer proxy;

    makeRequest(String url) => (new HttpClient()
        ..idleTimeout = const Duration(seconds: 1)
        ..findProxy = ((_) => "PROXY localhost:${proxy.port}")).getUrl(Uri.parse(url));

    setUp(() => Proxy.startProxyServer(InternetAddress.ANY_IP_V4, 0).then((s) => proxy = s));
    tearDown(() => proxy.close());

    test('should handle http request', () {
      return makeRequest("http://time.is/fr/UTC").then((HttpClientRequest req) {
        print("OK");
        return req;
      });
    });

    test('should handle http request', () {
      return makeRequest("https://www.google.com").then((HttpClientRequest req) {
        print("OK");
        return req;
      });
    });
  });
}
