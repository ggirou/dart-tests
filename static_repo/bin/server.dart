import 'dart:io';
import 'dart:async';
import 'package:http_server/http_server.dart';

void main() {
  const port = 8080;
  const path = '../content';
  runZoned(() {
      HttpServer.bind(InternetAddress.ANY_IP_V4, port).then((server) {
        print("Risk is running on http://localhost:$port\nBase path: $path");

        var vDir = new VirtualDirectory(path)
            ..jailRoot = false
            ..allowDirectoryListing = true;
        vDir.directoryHandler = (Directory dir, HttpRequest request) {
          final indexUri = new Uri.file(dir.path).resolve('index.html');
          vDir.serveFile(new File(indexUri.toFilePath()), request);
        };

        server.listen((HttpRequest req) {
          print(req.uri);
          vDir.serveRequest(req);
        });
      });
    }, onError: (e) => print("An error occurred $e"));
}
