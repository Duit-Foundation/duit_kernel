import '../index.dart';

/// The `FactorySet` class is a [Record] of factory functions that can be used to build custom components
typedef FactoryRecord<T extends DuitAttributes> = ({
  AttributesFactory<T> attributesFactory,
  ModelFactory<T> modelFactory,
  BuildFactory<T> buildFactory,
});