import 'package:duit_kernel/src/driver_api/parser.dart';

/// The [ServerEvent] class represents an event that was sent by the server.
///
/// The concrete event types are defined in sub-classes of [ServerEvent].
///
/// The [ServerEvent] class provides a static [parse] method for parsing a JSON map
/// into a concrete event object.
base class ServerEvent {
  static late final Parser<ServerEvent> _eventParser;

  static set eventParser(Parser<ServerEvent> value) {
    _eventParser = value;
  }

  final String type;

  ServerEvent({
    required this.type,
  });

  static ServerEvent parseEvent(Map<String, dynamic> json) {
    return _eventParser.parse(json);
  }
}
