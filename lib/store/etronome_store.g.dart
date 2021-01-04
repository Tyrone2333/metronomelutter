// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etronome_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MetronomeStore on _MetronomeStore, Store {
  final _$soundTypeAtom = Atom(name: '_MetronomeStore.soundType');

  @override
  int get soundType {
    _$soundTypeAtom.reportRead();
    return super.soundType;
  }

  @override
  set soundType(int value) {
    _$soundTypeAtom.reportWrite(value, super.soundType, () {
      super.soundType = value;
    });
  }

  final _$beatAtom = Atom(name: '_MetronomeStore.beat');

  @override
  int get beat {
    _$beatAtom.reportRead();
    return super.beat;
  }

  @override
  set beat(int value) {
    _$beatAtom.reportWrite(value, super.beat, () {
      super.beat = value;
    });
  }

  final _$noteAtom = Atom(name: '_MetronomeStore.note');

  @override
  int get note {
    _$noteAtom.reportRead();
    return super.note;
  }

  @override
  set note(int value) {
    _$noteAtom.reportWrite(value, super.note, () {
      super.note = value;
    });
  }

  final _$_MetronomeStoreActionController =
      ActionController(name: '_MetronomeStore');

  @override
  void setSoundType(dynamic payload) {
    final _$actionInfo = _$_MetronomeStoreActionController.startAction(
        name: '_MetronomeStore.setSoundType');
    try {
      return super.setSoundType(payload);
    } finally {
      _$_MetronomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBeat(dynamic payload) {
    final _$actionInfo = _$_MetronomeStoreActionController.startAction(
        name: '_MetronomeStore.setBeat');
    try {
      return super.setBeat(payload);
    } finally {
      _$_MetronomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
soundType: ${soundType},
beat: ${beat},
note: ${note}
    ''';
  }
}
