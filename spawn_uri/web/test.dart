import "dart:async";
import 'dart:isolate';

main() {
  port.receive((m, SendPort s) {
    print(m);
    new Timer(new Duration(seconds: 2), () {
      print("Hello world!");
      return s.call("child");
    });
  });
}