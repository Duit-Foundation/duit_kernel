/// Canonical numeric codes for how a node participates in the Duit element tree.
///
/// Values are stable wire-level integers (0–4); prefer these names over raw literals.
sealed class ElementChildRelation {
  /// No structural child slots (leaf nodes in the tree sense).
  static const none = 0;

  /// Exactly one structural child.
  static const single = 1;

  /// Multiple structural children.
  static const multi = 2;

  /// Component slot (merged template / component content).
  static const component = 3;

  /// Fragment slot (registered fragment subtree).
  static const fragment = 4;
}
