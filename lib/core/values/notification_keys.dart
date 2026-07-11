/// Localization keys sent inside notification payloads instead of pre-translated
/// text. The receiving app translates the key with its own locale, so we never
/// resolve the recipient's language at send time.
abstract class NotificationKeys {
  static const String orderUpdateTitle = 'notifications.order_update_title';
  static const String orderAccepted = 'notifications.order_accepted';
  static const String orderPicked = 'notifications.order_picked';
  static const String orderArrived = 'notifications.order_arrived';
  static const String orderDelivered = 'notifications.order_delivered';
  static const String orderCompleted = 'notifications.order_completed';
  static const String orderCancelled = 'notifications.order_cancelled';
  static const String orderUpdate = 'notifications.order_update';
  static const String deliveredByCustomerTitle =
      'notifications.delivered_by_customer_title';
  static const String deliveredByCustomer =
      'notifications.delivered_by_customer';
}
