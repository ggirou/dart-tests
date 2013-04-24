import 'dart:isolate';

String test = "aW1wb3J0ICJkYXJ0OmFzeW5jIjsNCmltcG9ydCAnZGFydDppc29sYXRlJzsNCg0KbWFpbigpIHsNCiAgcG9ydC5yZWNlaXZlKChtLCBTZW5kUG9ydCBzKSB7DQogICAgcHJpbnQobSk7DQogICAgbmV3IFRpbWVyKG5ldyBEdXJhdGlvbihzZWNvbmRzOiAyKSwgKCkgew0KICAgICAgcHJpbnQoIkhlbGxvIHdvcmxkISIpOw0KICAgICAgcmV0dXJuIHMuY2FsbCgiY2hpbGQiKTsNCiAgICB9KTsNCiAgfSk7DQp9";

void main() {
  print("Start");
  SendPort sendPort = spawnUri("data:text/plain;base64,$test");
//  SendPort sendPort = spawnUri("test.dart");
  
  var receive = new ReceivePort();
  receive.receive((m, s) {
    print(m);
    return receive.close();
  });
  sendPort.send("main", receive.toSendPort());
  print("End");
}
