abstract class EndPoints {
  static const String baseUrl = "https://flower.elevateegy.com/api/v1";
  static const String imagesUrl = "https://flower.elevateegy.com/uploads/";
  static const String loginDriver = "/drivers/signin";

  static const String login = "/drivers/signin";
  static const String register = "/drivers/signup";
  static const String forgetPasswordEndpoint = "/drivers/forgotPassword";
  static const String verifyResetEndpoint = "/drivers/verifyResetCode";
  static const String resetPasswordEndpoint = "/drivers/resetPassword";
  static const String login = "/auth/signin";
  static const String register = "/auth/signup";
  static const String forgetPasswordEndpoint = "/auth/forgotPassword";
  static const String verifyResetEndpoint = "/auth/verifyResetCode";
  static const String resetPasswordEndpoint = "/auth/resetPassword";
  static const String productsEndpoint = "/products";
  static const String bestSellersEndpoint = "/best-seller";
  static const String allCategories = "/categories";
  static const String allProducts = "/products";
  static const String homeEndpoint = "/home";
  static const String getAllOccasions = "/occasions";
  static const String getAllProducts = "/products";
  static const String logout = "/drivers/logout";
  static const String logoutDriver = "/drivers/logout";

  static const String profileData = "/drivers/profile-data";
  static const String profileData = "/auth/profile-data";
  static const String ordersPage = "/orders/pending-orders";
  static const String driverPendingOrders = "/orders/pending-orders";
  static const String driverMyOrders = "/orders/driver-orders";
  static const String driverActiveOrder = "/orders/active";
  static const String startOrder = "/orders/start";
  static const String updateOrderState = "/orders/state";

  //! CART
  static const String cartEndPoint = "/cart";

  static const String getUserProfile = "/drivers/profile-data";
  static const String editUserProfile = "/drivers/editProfilee";
  static const String updateProfilePhoto = "/drivers/upload-photo";

  //! CHECKOUT
  static const String creditCheckOut =
      "/orders/checkout?url=http://localhost:3000";
  static const String cashCheckOut = "/orders";
  static const String userAddresses = "/addresses";
  static const String addressEndPoint = "/addresses";
  static const String changePassword = "/drivers/change-password";
  static const String aboutApp = "/about-app";
  static const String vehiclesEndpoint = "/vehicles";
  static const String applyDriverEndpoint = "/drivers/apply";

  ///drivers
  static const String uploadPhoto = "/drivers/upload-photo";
  static const String driverResetPasswrod = "/drivers/resetPassword";
}
