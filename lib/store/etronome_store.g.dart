// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etronome_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MetronomeStore on _MetronomeStore, Store {
  late final _$bpmAtom = Atom(name: '_MetronomeStore.bpm', context: context);

  @override
  int get bpm {
    _$bpmAtom.reportRead();
    return super.bpm;
  }

  @override
  set bpm(int value) {
    _$bpmAtom.reportWrite(value, super.bpm, () {
      super.bpm = value;
    });
  }

  late final _$soundTypeAtom = Atom(
    name: '_MetronomeStore.soundType',
    context: context,
  );

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

  late final _$beatAtom = Atom(name: '_MetronomeStore.beat', context: context);

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

  late final _$noteAtom = Atom(name: '_MetronomeStore.note', context: context);

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

  late final _$_MetronomeStoreActionController = ActionController(
    name: '_MetronomeStore',
    context: context,
  );

  @override
  void setSoundType(int payload) {
    final _$actionInfo = _$_MetronomeStoreActionController.startAction(
      name: '_MetronomeStore.setSoundType',
    );
    try {
      return super.setSoundType(payload);
    } finally {
      _$_MetronomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBeat(int payload) {
    final _$actionInfo = _$_MetronomeStoreActionController.startAction(
      name: '_MetronomeStore.setBeat',
    );
    try {
      return super.setBeat(payload);
    } finally {
      _$_MetronomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBpm(int payload) {
    final _$actionInfo = _$_MetronomeStoreActionController.startAction(
      name: '_MetronomeStore.setBpm',
    );
    try {
      return super.setBpm(payload);
    } finally {
      _$_MetronomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void noteIncrease() {
    final _$actionInfo = _$_MetronomeStoreActionController.startAction(
      name: '_MetronomeStore.noteIncrease',
    );
    try {
      return super.noteIncrease();
    } finally {
      _$_MetronomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void noteDecrease() {
    final _$actionInfo = _$_MetronomeStoreActionController.startAction(
      name: '_MetronomeStore.noteDecrease',
    );
    try {
      return super.noteDecrease();
    } finally {
      _$_MetronomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
bpm: ${bpm},
soundType: ${soundType},
beat: ${beat},
note: ${note}
    ''';
  }
}
