import 'dart:async';
import 'duit_kernel.dart';

class GrpcTransport extends Transport {
  GrpcTransport(
    super.url, {
    required GrpcTransportOptions transportOptions,
  });

  @override
  Future<Map<String, dynamic>?> connect() async {
    return {};
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  FutureOr<Map<String, dynamic>?> execute(
      ServerAction action, Map<String, dynamic> payload) {
    // TODO: implement execute
    throw UnimplementedError();
  }
}

final class GrpcTransportOptions implements TransportOptions {
  @override
  String? baseUrl;

  @override
  Map<String, String> defaultHeaders = {};

  @override
  String type = "gRPC";

  GrpcTransportOptions({
    this.baseUrl,
  });
}

extension GrpcTransportExtension on UIDriver {
  void applyGrpcExtension() {
    transport = GrpcTransport(
      source,
      transportOptions: transportOptions as GrpcTransportOptions,
    );
  }
}
