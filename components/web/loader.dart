import 'dart:async';
import 'package:polymer/polymer.dart';

@CustomTag('x-loader')
class Loader extends PolymerElement {
  @published Future future;

  @published String data = "Hello";

  @published bool loading = false;

  Loader.created() : super.created() {
  }
}

