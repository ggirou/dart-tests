library http_proxy.main;

import 'dart:async';
import 'dart:io';

void main() {
  runZoned(() => startProxyServer(InternetAddress.ANY_IP_V4, 8080), onError: handleError);
}

void handleError(error, stacktrace) => print("$error - $stacktrace");

String findProxy(Uri url) => "DIRECT";

Future<HttpServer> startProxyServer(address, int port) {
  return HttpServer.bind(address, port).then((HttpServer server) {
    print("Proxy started: http://${server.address.host}:${server.port}");
    server.listen(onHttpRequest);
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
        ..badCertificateCallback = ((cert, host, port) => true)
        ..openUrl(request.method, uri).then((HttpClientRequest req) {
          pipeHeaders(request.headers, req.headers);
          return request.pipe(req);
        }).then((HttpClientResponse resp) {
          request.response.statusCode = resp.statusCode;
          //pipeHeaders(resp.headers, response.headers);
          return resp.pipe(request.response);
        }).then((_) => print("<-- ${request.method} - $uri"));
  }
}

void pipeHeaders(HttpHeaders from, HttpHeaders to) => from.forEach((String key, List<String> values) => values.forEach((value) => to.add(key, value)));
