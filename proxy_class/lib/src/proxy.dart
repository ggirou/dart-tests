part of proxy_class;

class Proxy {
  final InstanceHolder _holder;

  Proxy(this._holder);

  dynamic noSuchMethod(Invocation invocation) {
    var instance = _holder.instance;
    if(instance == null){
      // Exception ?
      return null;
    }

    InstanceMirror instanceMirror = reflect(instance);
    return instanceMirror.delegate(invocation);
  }
}

Symbol _invokableSetterSymbol(Symbol setterSymbol) {
  var name = MirrorSystem.getName(setterSymbol);
  return new Symbol(name.substring(0, name.length - 1));
}