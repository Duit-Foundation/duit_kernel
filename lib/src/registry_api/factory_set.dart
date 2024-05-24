import '../index.dart';

/// The [FactoryRecord] is a [Record] of factory functions that can be used to build custom components
typedef FactoryRecord = ({
  AttributesFactory attributesFactory,
  ModelFactory modelFactory,
  BuildFactory buildFactory,
});