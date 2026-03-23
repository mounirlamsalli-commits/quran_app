import 'dart:convert';
import 'dart:io';

/// Minimal NDJSON logger for DEBUG MODE.
///
/// Writes to `debug-032021.log` in the workspace root.
class DebugLogger {
  static const String sessionId = '032021';
  // IMPORTANT: write to the workspace root path so Flutter runs from any CWD.
  static const String logPath = 'C:\\Users\\Dev\\Desktop\\ByClaude\\quran_app_structure\\quran_app\\debug-032021.log';
  static const String serverEndpoint =
      'http://127.0.0.1:7590/ingest/709af694-5c24-41a4-89df-d1cc729630eb';

  static void log({
    required String runId,
    required String hypothesisId,
    required String location,
    required String message,
    Map<String, dynamic>? data,
  }) {
    try {
      final payload = <String, dynamic>{
        'sessionId': sessionId,
        'runId': runId,
        'hypothesisId': hypothesisId,
        'location': location,
        'message': message,
        'data': data ?? const {},
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
      };

      final line = JsonEncoder().convert(payload);
      // 1) Best-effort local file log (for desktop runs).
      try {
        File(logPath).writeAsStringSync('$line\n', mode: FileMode.append);
      } catch (_) {
        // Ignore local FS issues (mobile/web sandbox).
      }

      // 2) Best-effort HTTP log (for sandboxes where FS writes are blocked).
      try {
        final uri = Uri.parse(serverEndpoint);
        final client = HttpClient();
        client
            .postUrl(uri)
            .then((req) async {
          req.headers.set('Content-Type', 'application/json');
          req.headers.set('X-Debug-Session-Id', sessionId);
          req.add(utf8.encode(jsonEncode(payload)));
          await req.close();
        }).catchError((_) {}).whenComplete(() => client.close());
      } catch (_) {
        // Ignore HTTP issues.
      }
    } catch (_) {
      // Never crash the app because logging failed.
    }
  }
}

