import 'dart:html';
import 'dart:isolate';

SendPort reverser;

void main() {
  reverser = spawnUri("test.dart");
}
