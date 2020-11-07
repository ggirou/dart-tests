// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library model;

import 'dart:html' show CompoundBinding;
import 'package:observe/observe.dart';
import 'package:polymer/polymer.dart';
import 'package:observe/observe.dart' as __observe;


final appModel = new AppModel._();

class AppModel extends ObservableBase {
  final ObservableList<Todo> todos = new ObservableList<Todo>();
  int __$doneCount;
  int get doneCount => __$doneCount;
  set doneCount(int value) {
    __$doneCount = notifyPropertyChange(const Symbol('doneCount'), __$doneCount, value);
  }
  
  int __$remaining;
  int get remaining => __$remaining;
  set remaining(int value) {
    __$remaining = notifyPropertyChange(const Symbol('remaining'), __$remaining, value);
  }
  
  List<Todo> __$visibleTodos;
  List<Todo> get visibleTodos => __$visibleTodos;
  set visibleTodos(List<Todo> value) {
    __$visibleTodos = notifyPropertyChange(const Symbol('visibleTodos'), __$visibleTodos, value);
  }
  
  bool __$hasTodos;
  bool get hasTodos => __$hasTodos;
  set hasTodos(bool value) {
    __$hasTodos = notifyPropertyChange(const Symbol('hasTodos'), __$hasTodos, value);
  }
  
  bool __$hasCompleteTodos;
  bool get hasCompleteTodos => __$hasCompleteTodos;
  set hasCompleteTodos(bool value) {
    __$hasCompleteTodos = notifyPropertyChange(const Symbol('hasCompleteTodos'), __$hasCompleteTodos, value);
  }
  

  bool _allChecked;

  AppModel._() {
    // TODO(jmesserly): need to make this easier.
    new ListPathObserver(todos, 'done').changes.listen(_updateTodoDone);
    windowLocation.changes.listen(_updateVisibleTodos);
    _updateTodoDone(null);
  }

  _updateTodoDone(_) {
    doneCount = todos.fold(0, (count, t) => count + (t.done ? 1 : 0));
    hasCompleteTodos = doneCount > 0;
    remaining = todos.length - doneCount;
    hasTodos = todos.length > 0;

    _allChecked = notifyPropertyChange(const Symbol('allChecked'),
        _allChecked, hasTodos && remaining == 0);

    _updateVisibleTodos(_);
  }

  _updateVisibleTodos(_) {
    bool filterDone = null;
    if (windowLocation.hash == '#/completed') {
      filterDone = true;
    } else if (windowLocation.hash == '#/active') {
      filterDone = false;
    }

    visibleTodos = todos.where(
        (t) => filterDone == null || t.done == filterDone)
        .toList(growable: false);
  }

  // TODO(jmesserly): the @observable here is temporary.
  bool get allChecked => _allChecked;
  set allChecked(bool value) {
    todos.forEach((t) { t.done = value; });
  }

  void clearDone() => todos.removeWhere((t) => t.done);

  getValueWorkaround(key) {
    if (key == const Symbol('doneCount')) return this.doneCount;
    if (key == const Symbol('remaining')) return this.remaining;
    if (key == const Symbol('visibleTodos')) return this.visibleTodos;
    if (key == const Symbol('hasTodos')) return this.hasTodos;
    if (key == const Symbol('hasCompleteTodos')) return this.hasCompleteTodos;
    if (key == const Symbol('allChecked')) return this.allChecked;
    return null;
  }
  
  setValueWorkaround(key, value) {
    if (key == const Symbol('doneCount')) { this.doneCount = value; return; }
    if (key == const Symbol('remaining')) { this.remaining = value; return; }
    if (key == const Symbol('visibleTodos')) { this.visibleTodos = value; return; }
    if (key == const Symbol('hasTodos')) { this.hasTodos = value; return; }
    if (key == const Symbol('hasCompleteTodos')) { this.hasCompleteTodos = value; return; }
    if (key == const Symbol('allChecked')) { this.allChecked = value; return; }
  }
  }

class Todo extends ObservableBase {
  String __$task;
  String get task => __$task;
  set task(String value) {
    __$task = notifyPropertyChange(const Symbol('task'), __$task, value);
  }
  
  bool __$done = false;
  bool get done => __$done;
  set done(bool value) {
    __$done = notifyPropertyChange(const Symbol('done'), __$done, value);
  }
  

  Todo(task) : __$task = task;

  String toString() => "$task ${done ? '(done)' : '(not done)'}";

  getValueWorkaround(key) {
    if (key == const Symbol('task')) return this.task;
    if (key == const Symbol('done')) return this.done;
    return null;
  }
  
  setValueWorkaround(key, value) {
    if (key == const Symbol('task')) { this.task = value; return; }
    if (key == const Symbol('done')) { this.done = value; return; }
  }
  }

//# sourceMappingURL=model.dart.map