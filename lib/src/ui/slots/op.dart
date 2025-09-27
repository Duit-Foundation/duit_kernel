import "package:duit_kernel/src/ui/slots/op_code.dart";

typedef RemoveOpReturnType = ({
  SlotOpCode code,
  int index,
});

typedef InsertOpReturnType = ({
  SlotOpCode code,
  int index,
  Map<String, dynamic> data,
});

typedef MoveOpReturnType = ({
  SlotOpCode code,
  int from,
  int to,
});

typedef AddOpReturnType = ({
  SlotOpCode code,
  Map<String, dynamic> data,
});

extension type SlotOp._(Map<String, dynamic> _json) {
  SlotOpCode get code {
    final code = _json["op"];
    if (code is SlotOpCode) {
      return code;
    }
    return _json["op"] = SlotOpCode.fromJson(code);
  }

  Map<String, dynamic> get data => _json["data"];
  int get to => _json["to"];
  int get from => _json["from"];
  int get index => _json["index"];

  AddOpReturnType addOp() {
    return (
      code: code,
      data: data,
    );
  }

  InsertOpReturnType insertOp() {
    return (
      code: code,
      index: index,
      data: data,
    );
  }

  MoveOpReturnType moveOp() {
    return (
      code: code,
      from: from,
      to: to,
    );
  }

  RemoveOpReturnType removeOp() {
    return (
      code: code,
      index: index,
    );
  }

  bool validate() {
    return switch (this) {
      {
        "op": String _,
        "data": Map<String, dynamic> _,
      } ||
      {
        "op": String _,
        "index": int _,
        "data": Map<String, dynamic> _,
      } ||
      {
        "op": String _,
        "from": int _,
        "to": int _,
      } ||
      {
        "op": String _,
        "index": int _,
      } =>
        true,
      _ => throw Exception("Invalid slot operation: $this"),
    };
  }

  factory SlotOp.fromJson(json) => SlotOp._(json)..validate();

  static List<SlotOp> fronList(List json) => json.map(SlotOp.fromJson).toList();
}
