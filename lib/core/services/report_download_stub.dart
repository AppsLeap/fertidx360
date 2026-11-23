Future<bool> triggerReportDownload({
  required String fileName,
  required String content,
}) async {
  // Non-web fallback handled in UI (e.g., clipboard / file writer)
  return false;
}