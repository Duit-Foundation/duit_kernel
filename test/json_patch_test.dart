import "package:flutter_test/flutter_test.dart";
import "package:duit_kernel/duit_kernel.dart";

void main() {
  group("JsonPatchApplier - replace", () {
    test("replace in map", () {
      final base = {
        "a": {"b": 1},
      };
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.replace(path: ["a", "b"], value: 2),
        ],
      );
      expect((result["a"] as Map)["b"], 2);
      expect((base["a"]! as Map)["b"], 1, reason: "base must be unchanged");
    });

    test("replace with ensure creates intermediate maps", () {
      final base = <String, dynamic>{};
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.replace(path: ["a", "b"], value: 1),
        ],
        ensureIntermediate: true,
      );
      expect(result, {
        "a": {"b": 1},
      });
      expect(base.isEmpty, isTrue);
    });

    test("replace in list index in-range", () {
      final base = {
        "l": [0, 1],
      };
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.replace(path: ["l", 1], value: 9),
        ],
      );
      expect(result["l"], [0, 9]);
      expect(base["l"], [0, 1]);
    });

    test("replace in list index out-of-range with ensure", () {
      final base = {"l": []};
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.replace(path: ["l", 3], value: "x"),
        ],
        ensureIntermediate: true,
      );
      expect(result["l"], [null, null, null, "x"]);
    });
  });

  group("JsonPatchApplier - add", () {
    test("add to map (terminal)", () {
      final base = {"a": <String, dynamic>{}};
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.add(path: ["a", "k"], value: 5),
        ],
      );
      expect(result["a"]["k"], 5);
      expect((base["a"] as Map?)?.containsKey("k"), isFalse);
    });

    test("add to list insert in middle", () {
      final base = {
        "l": [1, 2, 3],
      };
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.add(path: ["l", 1], value: "x"),
        ],
      );
      expect(result["l"], [1, "x", 2, 3]);
      expect(base["l"], [1, 2, 3]);
    });

    test("add to list append at tail", () {
      final base = {
        "l": [1, 2],
      };
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.add(path: ["l", 2], value: "x"),
        ],
      );
      expect(result["l"], [1, 2, "x"]);
    });

    test("add to list index>length with ensure", () {
      final base = {"l": []};
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.add(path: ["l", 3], value: "x"),
        ],
        ensureIntermediate: true,
      );
      expect(result["l"], [null, null, null, "x"]);
    });
  });

  group("JsonPatchApplier - remove", () {
    test("remove from map", () {
      final base = {
        "a": {"k": 1},
      };
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.remove(path: ["a", "k"]),
        ],
      );
      expect(result["a"], {});
      expect(base["a"], {"k": 1});
    });

    test("remove from list in-range", () {
      final base = {
        "l": [10, 20, 30],
      };
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.remove(path: ["l", 1]),
        ],
      );
      expect(result["l"], [10, 30]);
      expect(base["l"], [10, 20, 30]);
    });

    test("remove from list out-of-range is no-op", () {
      final base = {
        "l": [10],
      };
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.remove(path: ["l", 5]),
        ],
      );
      expect(result["l"], [10]);
    });

    test("remove from wrong type is no-op", () {
      final base = {"x": 42};
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.remove(path: ["x", "y"]),
        ],
      );
      expect(result["x"], 42);
    });
  });

  group("JsonPatchApplier - immutability & path-copy", () {
    test("base remains unchanged and unaffected branches are identical", () {
      final child = {"b": 1};
      final base = {
        "a": child,
        "c": {"d": 2},
      };
      final result = JsonPatchApplier.apply(
        base,
        [
          PatchOps.replace(path: ["a", "b"], value: 10),
        ],
      );
      expect(base["a"]?["b"], 1);
      expect(result["a"]["b"], 10);
      // Branch 'c' should be identical by reference (path-copy only along 'a')
      expect(identical(base["c"], result["c"]), isTrue);
    });
  });
}
