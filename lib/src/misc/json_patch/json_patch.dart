/// JSON Patch operation base type.
///
/// Path is represented as a list of segments where each segment is either
/// a String (for Map key) or an int (for List index).
abstract class PatchOp {
  /// JSON path segments from the document root to the target location.
  final List<Object> path;

  const PatchOp(this.path);
}

/// Add operation.
///
/// For Map: sets the value at the key (same as replace if exists).
/// For List: inserts the value at the index (appends if index == length).
class AddOp extends PatchOp {
  final Object? value;
  const AddOp({required List<Object> path, this.value}) : super(path);
}

/// Replace operation.
///
/// For Map: sets the value at the key.
/// For List: sets the value at the index (expands with nulls if needed when
/// ensureIntermediate is enabled during apply).
class ReplaceOp extends PatchOp {
  final Object? value;
  const ReplaceOp({required List<Object> path, this.value}) : super(path);
}

/// Remove operation.
///
/// For Map: removes the key if exists.
/// For List: removes the element at index if exists.
class RemoveOp extends PatchOp {
  const RemoveOp({required List<Object> path}) : super(path);
}

/// Convenience factory for creating patch operations.
sealed class PatchOps {
  /// Add operation.
  static AddOp add({
    required List<Object> path,
    Object? value,
  }) =>
      AddOp(
        path: path,
        value: value,
      );

  /// Replace operation.
  static ReplaceOp replace({
    required List<Object> path,
    Object? value,
  }) =>
      ReplaceOp(
        path: path,
        value: value,
      );

  /// Remove operation.
  static RemoveOp remove({
    required List<Object> path,
  }) =>
      RemoveOp(
        path: path,
      );
}

/// A minimal JSON Patch (https://datatracker.ietf.org/doc/html/rfc6902) applier with support for add/replace/remove operations
/// and path-copy semantics.
///
/// - Path-copy: only nodes along the modified path are shallow-copied; all
///   other branches are shared with the original document to keep allocations
///   minimal.
/// - Ensure intermediate: when enabled, missing intermediate nodes (Map/List)
///   are created based on the next path segment type.
final class JsonPatchApplier {
  /// Applies a list of patch operations to a JSON-like document.
  ///
  /// The [base] document is not mutated. A new Map is returned; nodes that are
  /// not on modified paths are shared with [base].
  static Map<String, dynamic> apply(
    Map<String, dynamic> base,
    List<PatchOp> ops, {
    bool ensureIntermediate = true,
  }) {
    var result = base;
    for (final op in ops) {
      result = _applySingle(result, op, ensureIntermediate);
    }
    return result;
  }

  static Map<String, dynamic> _applySingle(
    Map<String, dynamic> base,
    PatchOp op,
    bool ensure,
  ) =>
      switch (op) {
        ReplaceOp() => _applyReplace(base, op, ensure),
        AddOp() => _applyAdd(base, op, ensure),
        RemoveOp() => _applyRemove(base, op, ensure),
        _ => base,
      };

  static Map<String, dynamic> _applyReplace(
    Map<String, dynamic> base,
    ReplaceOp op,
    bool ensure,
  ) {
    final updated = _replaceAtPath(base, op.path, op.value, ensure, 0);
    return updated is Map<String, dynamic> ? updated : base;
  }

  static Object? _replaceAtPath(
    Object? node,
    List<Object> path,
    Object? value,
    bool ensure,
    int depth,
  ) {
    if (depth == path.length) {
      // Terminal: return replacement value
      return value;
    }

    final segment = path[depth];
    if (segment is String) {
      final Map<String, dynamic> current = _asMap(node, ensure);
      final Map<String, dynamic> clone = {...current};
      final nextNode = current[segment];
      final replaced = _replaceAtPath(nextNode, path, value, ensure, depth + 1);
      clone[segment] = replaced;
      return clone;
    } else if (segment is int) {
      final List<dynamic> current = _asList(node, ensure);
      final List<dynamic> clone = List<dynamic>.of(current);
      _ensureListLen(clone, segment, ensure);
      final nextNode = segment < clone.length ? clone[segment] : null;
      final replaced = _replaceAtPath(nextNode, path, value, ensure, depth + 1);
      if (segment < clone.length) {
        clone[segment] = replaced;
      } else {
        // If ensure=false and index is out of range, keep original list
        // but since we already ensured length when ensure=true, this else
        // branch is effectively a no-op.
        clone.add(replaced);
      }
      return clone;
    } else {
      throw ArgumentError('Unsupported path segment: $segment');
    }
  }

  static Map<String, dynamic> _applyAdd(
    Map<String, dynamic> base,
    AddOp op,
    bool ensure,
  ) {
    final updated = _addAtPath(base, op.path, op.value, ensure, 0);
    return updated is Map<String, dynamic> ? updated : base;
  }

  static Object? _addAtPath(
    Object? node,
    List<Object> path,
    Object? value,
    bool ensure,
    int depth,
  ) {
    final segment = path[depth];
    final isLast = depth == path.length - 1;

    if (segment is String) {
      final Map<String, dynamic> current = _asMap(node, ensure);
      final Map<String, dynamic> clone = {...current};
      if (isLast) {
        clone[segment] = value;
        return clone;
      }
      final nextNode = current[segment];
      final next = _addAtPath(nextNode, path, value, ensure, depth + 1);
      clone[segment] = next;
      return clone;
    } else if (segment is int) {
      final List<dynamic> current = _asList(node, ensure);
      final List<dynamic> clone = List<dynamic>.of(current);
      if (isLast) {
        // insert semantics: if index within [0, length], insert; if index
        // greater than length and ensure=true, expand with nulls and append.
        if (segment <= clone.length) {
          clone.insert(segment, value);
        } else if (ensure) {
          while (clone.length < segment) {
            clone.add(null);
          }
          // insert at tail (same as add)
          clone.add(value);
        } // else: no-op when ensure=false and index>length
        return clone;
      }
      _ensureListLen(clone, segment, ensure);
      final nextNode = segment < clone.length ? clone[segment] : null;
      final next = _addAtPath(nextNode, path, value, ensure, depth + 1);
      if (segment < clone.length) {
        clone[segment] = next;
      } else {
        // ensure=false and index>length -> no-op; but for consistency, append
        clone.add(next);
      }
      return clone;
    } else {
      throw ArgumentError('Unsupported path segment: $segment');
    }
  }

  static Map<String, dynamic> _applyRemove(
    Map<String, dynamic> base,
    RemoveOp op,
    bool ensure,
  ) {
    final updated = _removeAtPath(base, op.path, /*ensure=*/ false, 0);
    return updated is Map<String, dynamic> ? updated : base;
  }

  static Object? _removeAtPath(
    Object? node,
    List<Object> path,
    bool ensure,
    int depth,
  ) {
    if (node == null) return node; // nothing to remove

    final segment = path[depth];
    final isLast = depth == path.length - 1;

    if (segment is String) {
      if (node is! Map) return node; // type mismatch -> no-op
      final Map<String, dynamic> current = _asMap(node, false);
      final Map<String, dynamic> clone = {...current};
      if (isLast) {
        clone.remove(segment);
        return clone;
      }
      final nextNode = current[segment];
      final next = _removeAtPath(nextNode, path, false, depth + 1);
      // If child changed by identity, set; else keep as is
      if (!identical(nextNode, next)) {
        clone[segment] = next;
      }
      return clone;
    } else if (segment is int) {
      if (node is! List) return node; // type mismatch -> no-op
      final List<dynamic> current = List<dynamic>.of(node);
      if (isLast) {
        if (segment >= 0 && segment < current.length) {
          current.removeAt(segment);
        }
        return current;
      }
      if (segment < 0 || segment >= current.length) {
        return current; // out of range -> no-op
      }
      final nextNode = current[segment];
      final next = _removeAtPath(nextNode, path, false, depth + 1);
      if (!identical(nextNode, next)) {
        current[segment] = next;
      }
      return current;
    } else {
      throw ArgumentError('Unsupported path segment: $segment');
    }
  }

  static Map<String, dynamic> _asMap(Object? node, bool ensure) {
    if (node is Map<String, dynamic>) return node;
    if (node is Map) return node.cast<String, dynamic>();
    if (ensure) return <String, dynamic>{};
    return <String, dynamic>{};
  }

  static List<dynamic> _asList(Object? node, bool ensure) {
    if (node is List) return List<dynamic>.of(node);
    if (ensure) return <dynamic>[];
    return <dynamic>[];
  }

  static void _ensureListLen(List<dynamic> list, int index, bool ensure) {
    if (!ensure) return;
    if (index < 0) return;
    while (list.length <= index) {
      list.add(null);
    }
  }
}
