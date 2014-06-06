import 'dart:async';
import 'dart:io';

void main() {
  runZoned(startHttpServer, onError: handleError);
  runZoned(startSocketServer, onError: handleError);
}

void handleError(error, stacktrace) => print("$error - $stacktrace");

String findProxy(Uri url) => "DIRECT";

void startHttpServer() {
  HttpServer.bind("0.0.0.0", 8080).then((HttpServer server) {
    print("Proxy started: http://${server.address.host}:${server.port}");
    server.listen(onHttpRequest);
  });
}

void onHttpRequest(HttpRequest request) {
  var response = request.response;

  print("${request.method} - ${request.uri}");
  
  new HttpClient()
      ..findProxy = findProxy
      ..badCertificateCallback = ((cert, host, port) => true)
      ..openUrl(request.method, request.uri).then((HttpClientRequest req) {
        pipeHeaders(request.headers, req.headers);
        return request.pipe(req);
      }).then((HttpClientResponse resp) {
        response.statusCode = resp.statusCode;
        //pipeHeaders(resp.headers, response.headers);
        return resp.pipe(response);
      }).then((_) => print("--> ${request.method} - $request.uri"));
}

void pipeHeaders(HttpHeaders from, HttpHeaders to) => from.forEach((String key, List<String> values) => values.forEach((value) => to.add(key, value)));

void startSocketServer() {
  ServerSocket.bind("0.0.0.0", 8083).then((ServerSocket server) {
    print("Proxy started: http://${server.address.host}:${server.port}");
    server.listen(onSocketRequest);
  });
}

void onSocketRequest(Socket socket) {

}
