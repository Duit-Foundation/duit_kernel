import 'package:duit_kernel/src/driver_api/parser.dart';

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
