class SwapClientRequest {
  const SwapClientRequest(
    this.method,
    this.path, {
    this.headers,
    this.body,
  });

  final String method;
  final String path;
  final Map<String, String>? headers;
  final dynamic body;
}
