import 'dart:convert';

/// Minimal NDJSON logger for DEBUG MODE.
class DebugLogger {
  static const String sessionId = '032021';

  static void log({
    required String runId,
    required String hypothesisId,
    required String location,
    required String message,
    Map<String, dynamic>? data,
  }) {
    // Log to console only
    final payload = <String, dynamic>{
      'sessionId': sessionId,
      'runId': runId,
      'hypothesisId': hypothesisId,
      'location': location,
      'message': message,
      'data': data ?? const {},
      'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
    };
    // ignore: avoid_print
    print('[DEBUG] ${JsonEncoder().convert(payload)}');
  }
}
