part of proxy_class;

class Proxy {
  final InstanceHolder _holder;
  
  Proxy(this._holder);
  
  dynamic noSuchMethod(Invocation invocation) {
    var instance = _holder.instance;
    if(instance == null){
      // Exception ?
      return;
    }
    
    InstanceMirror instanceMirror = reflect(instance);
    if(invocation.isGetter) {
      return instanceMirror.getField(invocation.memberName).reflectee;
    } else if(invocation.isSetter) {
      return instanceMirror.setField(_invokableSetterSymbol(invocation.memberName), invocation.positionalArguments.first).reflectee;
    } else {
      // FIXME: named argument support is not implemented
      // return instanceMirror.invoke(invocation.memberName, invocation.positionalArguments, invocation.namedArguments).reflectee;
      return instanceMirror.invoke(invocation.memberName, invocation.positionalArguments).reflectee;
    }
  }
}

Symbol _invokableSetterSymbol(Symbol setterSymbol) {
  var name = MirrorSystem.getName(setterSymbol);
  return new Symbol(name.substring(0, name.length - 1));
}