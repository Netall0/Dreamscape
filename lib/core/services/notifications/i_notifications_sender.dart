abstract interface class INotificationsSender {
  Future<void> showNotification(
    final int id,
    final String name,
    final String description,
  );
}
