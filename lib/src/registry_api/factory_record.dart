import 'package:duit_kernel/duit_kernel.dart';

/// The [FactoryRecord] is a [Record] of factory functions that can be used to build custom components
typedef FactoryRecord = ({
  AttributesFactory attributesFactory,
  ModelFactory modelFactory,
  BuildFactory buildFactory,
});
