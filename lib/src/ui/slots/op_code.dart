enum SlotOpCode {
  add,
  insert,
  move,
  remove;

  factory SlotOpCode.fromJson(v) {
    final result = switch (v) {
      String() => _slotOpStringLookup[v]!,
      int() => _slotOpIntLookup[v]!,
      _ => null,
    };

    return result ?? (throw Exception("Invalid slot operation name: $v"));
  }
}

const _slotOpIntLookup = <int, SlotOpCode>{
  0: SlotOpCode.add,
  1: SlotOpCode.insert,
  2: SlotOpCode.move,
  3: SlotOpCode.remove,
};

const _slotOpStringLookup = <String, SlotOpCode>{
  "add": SlotOpCode.add,
  "insert": SlotOpCode.insert,
  "move": SlotOpCode.move,
  "remove": SlotOpCode.remove,
};
