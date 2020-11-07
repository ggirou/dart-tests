library http_proxy.main;

import 'dart:math';
import 'dart:async';
import 'dart:io';

const proxyName = "Dart-Light-Proxy/1.0";

void main() {
  runZoned(() => startProxyServer(InternetAddress.ANY_IP_V4, 8080), onError: handleError);
}

void handleError(error, stacktrace) => print("$error - $stacktrace");

String findProxy(Uri url) => "DIRECT";

Future<HttpServer> startProxyServer(address, int port) {
  return HttpServer.bind(address, port).then((HttpServer server) {
    print("Proxy started: http://${server.address.host}:${server.port}");
    server..idleTimeout = const Duration(seconds: 1)
        ..listen(onHttpRequest);
    return server;
  });
}

void onHttpRequest(HttpRequest request) {
  var uri = request.uri;

  print("--> ${request.method} - $uri");

  if (request.method == "CONNECT") {
    // Bug in uri parsing
    Socket.connect(uri.scheme, int.parse(uri.path)).then((Socket socket) {
      request.response
          ..reasonPhrase = "Connection established"
          ..headers.add("Proxy-agent", "Dart-Light-Proxy");

      request.response.detachSocket().then((detached) {
        socket.pipe(detached);
        detached.pipe(socket);
      });
    }, onError: (_) => request.response
        ..statusCode = HttpStatus.NOT_FOUND
        ..close());
  } else {
    new HttpClient()
        ..findProxy = findProxy
        ..userAgent = null
        ..idleTimeout = const Duration(seconds: 1)
        ..openUrl(request.method, uri).then((HttpClientRequest req) {
          print("~~> ${request.method} - $uri");

          pipeHeaders(request.headers, req.headers);
//          req..headers.add(HttpHeaders.VIA, "$proxyName localhost:8080");
//          req  ..persistentConnection = false;
          //..contentLength = request.contentLength;
          print(req.headers);
          // Special handling of Content-Length and Via.
          //          req.contentLength = max(request.contentLength, 0);
          //          List<String> via = request.headers[HttpHeaders.VIA];
          //          String viaPrefix = via == null ? "" : "${via[0]}, ";
          //          req.headers.add(HttpHeaders.VIA, "${viaPrefix}1.1 localhost:8080");
          request.pipe(req);
          return req.done;
        }).then((HttpClientResponse resp) {
          print("<~~ ${resp.statusCode} - $uri - ${resp.contentLength}");

          pipeHeaders(resp.headers, request.response.headers);
          request.response.statusCode = resp.statusCode;

          resp.pipe(request.response);
        });
  }
}

void pipeHeaders(HttpHeaders from, HttpHeaders to) => from.forEach((String key, List<String> values) {
  if (!const [HttpHeaders.CONTENT_ENCODING, HttpHeaders.CONTENT_LENGTH, "proxy-connection"].contains(key.toLowerCase())) {
    values.forEach((value) => to.add(key, value));
  }
});
