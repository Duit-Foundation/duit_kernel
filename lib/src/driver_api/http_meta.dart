/// Represents the metadata for an HTTP action.
///
/// The [HttpActionMetainfo] class contains information about the HTTP method to be used for the action.
final class HttpActionMetainfo {
  final String method;

  HttpActionMetainfo({required this.method});

  static HttpActionMetainfo fromJson(Map<String, dynamic> json) {
    return HttpActionMetainfo(
      method: json["method"] ?? "GET",
    );
  }
}
