sealed class OrdersEvents {}

/// Fetch the first page of orders (also used for pull-to-refresh).
class GetOrdersEvent extends OrdersEvents {}

/// Fetch the next page and append it to the current list.
class LoadMoreOrdersEvent extends OrdersEvents {}
