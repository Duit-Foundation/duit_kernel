import 'package:duit_kernel/src/driver_api/dependency.dart';
import 'package:duit_kernel/src/driver_api/http_meta.dart';
import 'package:duit_kernel/src/driver_api/script_def.dart';

/// The [ServerActionJsonView] class is a view over a JSON map representing an action.
///
/// The [ServerActionJsonView] class provides a convenient interface for accessing the properties of an
/// action represented as a JSON map. It's used to parse the JSON map into a concrete action object.
extension type ServerActionJsonView(Map<String, dynamic> json) {
  Iterable<ActionDependency> get dependsOn {
    final hasProperty = json.containsKey("dependsOn");
    if (hasProperty &&
        json["dependsOn"] is List &&
        json["dependsOn"].isNotEmpty) {
      return (json["dependsOn"] as List).map(
        (el) => ActionDependency.fromJson(el),
      );
    } else {
      return const [];
    }
  }

  String get eventName {
    final hasProperty = json.containsKey("event");
    if (hasProperty) {
      return json["event"];
    } else {
      return "";
    }
  }

  /// Parse helper for script model
  ///
  /// Use this method with !
  ScriptDefinition? get script {
    final hasProperty = json.containsKey("script");

    if (!hasProperty) {
      throw Exception(
          "An action with execution type 2 (script action) was created, but the script model is missing");
    } else {
      final scriptData = json["script"];

      if (scriptData == null ||
          scriptData is! Map<String, dynamic> ||
          scriptData.isEmpty) {
        throw Exception(
            "An action with execution type 2 (script action) was created, but the script model is missing");
      }
    }

    return ScriptDefinition.fromJson(json["script"]);
  }

  HttpActionMetainfo? get meta {
    final hasProperty = json.containsKey("meta");

    if (hasProperty) {
      return HttpActionMetainfo.fromJson(json["meta"]);
    } else {
      return null;
    }
  }

  int get executionType {
    final hasProperty = json.containsKey("executionType");
    if (hasProperty) {
      return json["executionType"];
    } else {
      return 0;
    }
  }
}
