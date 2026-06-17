class AppStrings {
  AppStrings._();

  // API Failures
  static const String connectionError = "Failed to connect to the server";
  static const String connectionTimeout = "Failed to connect to the server";
  static const String cancelled = "The request to the server was cancelled";
  static const String unknownError =
      "An unexpected error occurred while connecting to the server, please try again later!";
  static const String serverError = "Server error, please try again later!";
  static const String receiveTimeout =
      "Failed to connect to the server while receiving data";
  static const String sendTimeout =
      "Failed to connect to the server while sending data";
  static const String unexpectedError = "An unexpected error occurred";
  static const String badCertificate = "Invalid certificate from the server";
  static const String expiredToken = "Session expired, please log in again";

  // Custom Widgets
  static const String loadingAccessibilityLabel = "Loading...";
  static const String retryButton = "Retry...";
  static const String invalidCode = "Invalid code";
  static const String occasion = "Occasion";
  static const String occasionSubTitle =
      "Bloom with our exquisite best sellers";
  static const String enterUserName = "Enter first name";
  static const String codeNotReceived = "Didn't receive the code?";
  static const String resendCodeIn = "Resend in {}";
  static const String resend = "Resend";
  static const String noProductsFound = "No products found";
  static const String enterEmail = "Enter you email";
  static const String password = "Password";
  static const String phoneNumber = "Phone Number";
  static const String enterPhoneNumber = "01012345678";
  static const String search = "Search";

  // Date Time
  static const String amLong = "AM";
  static const String pmLong = "PM";
  static const String ago = "ago";
  static const String seconds = "seconds";
  static const String passwordHint = "Password is required";
  static const String second = "second";
  static const String twoSeconds = "two seconds";
  static const String hourLabel = "hour";
  static const String hour = "hour";
  static const String twoHours = "two hours";
  static const String hours = "hours";
  static const String day = "day";
  static const String twoDays = "two days";
  static const String days = "days";
  static const String week = "week";
  static const String twoWeeks = "two weeks";
  static const String weeks = "weeks";
  static const String months = "months";
  static const String month = "month";
  static const String year = "year";
  static const String twoYears = "two years";
  static const String years = "years";
  static const String minutes = "minutes";
  static const String twoMinutes = "two minutes";
  static const String minute = "minute";
  static const String amShort = "AM";
  static const String pmShort = "PM";
  static const String justNow = "just now";
  static const String remaining = "remaining";

  // Global
  static const String currencyIQD = "IQD";
  static const String ok = "OK";
  static const String confirm = "Confirm";
  static const String cancel = "Cancel";
  static const String close = "Close";
  static const String yes = "Yes";
  static const String no = "No";
  static const String error = "Error";
  static const String success = "Success";
  static const String warning = "Warning";
  static const String info = "Info";
  static const String submit = "Submit";
  static const String loading = "Loading...";
  static const String product = "Product";
  static const String oneProduct = "One product";
  static const String twoProducts = "Two products";
  static const String products = "Products";
  static const String noInternet = "No internet connection!";
  static const String changeImage = "Change image";
  static const String removeImage = "Remove image";
  static const String addImage = "Add image";
  static const String camera = "Camera";
  static const String gallery = "Gallery";
  static const String save = "Save";
  static const String version = "Version";
  static const String appName = "Flowers";
  static const String appSlogan = "The most beautiful flowers to your doorstep";
  static const String tryAgain = "Try again";
  static const String appTitle = "Flowery";

  // Validations
  static const String emailRequired = "Email is required";
  static const String email = "email";
  static const String emailInvalid = "Please enter a valid email address";
  static const String usernameRequired = "Username is required";
  static const String firstNameRequired = "First name is required";
  static const String lastNameRequired = "Last name is required";
  static const String passwordRequired = "Password is required";
  static const String confirmPasswordRequired = "Confirm password is required";
  static const String confirmPasswordMismatch =
      "Confirm password does not match";
  static const String phoneRequired = "Phone number is required";
  static const String pinRequired = "Verification code is required";

  // Login
  static const String loginTitle = "Login";
  static const String loginSubtitle = "Welcome back! Please login to continue";
  static const String rememberMe = "Remember me";
  static const String forgotPassword = "Forgot password?";
  static const String loginButton = "Login";
  static const String continueAsGuest = "Continue as guest";
  static const String noAccount = "Don't have an account? ";
  static const String signUp = "Sign up";
  static const String loginSuccessfully = "Login successfully";
  static const String loginError = "Invalid Phone Number or Password";

  // Register
  static const String registerTitle = "Sign up";
  static const String genderLabel = "Gender";
  static const String maleLabel = "Male";
  static const String femaleLabel = "Female";
  static const String termsConditionsPart1 =
      "By creating an account, you agree to our ";
  static const String termsConditionsPart2 = "Terms & Conditions";

  // Product Details
  static const String inStock = "In stock";
  static const String description = "Description";
  static const String bouquetInclude = "Bouquet include";
  static const String addToCart = "Add to cart";

  // Cart
  static const String cartTitle = "Cart";
  static const String checkout = "Checkout";
  static const String emptyCart = "Your cart is empty";
  static const String itemAddedSuccess = "Item added successfully to your cart";

  // Checkout
  static const String deliveryTime = "Delivery Time";
  static const String deliveryFee = "Delivery Fee";
  static const String totalPrice = "Total";
  static const String placeOrder = "Place Order";
  static const String paymentMethod = "Payment method";
  static const String cash = "Cash";
  static const String creditCard = "Credit Card";

  // Profile & Address
  static const String myOrders = "My orders";
  static const String savedAddresses = "Saved addresses";
  static const String logout = "Logout";
  static const String editProfile = "Edit profile";
  static const String addNewAddress = "Add New Address";
  static const String notification = "Notification";
  static const String language = "Language";
  static const String english = "English";
  static const String arabic = "العربية";
  static const String aboutUs = "About us";
  static const String termsConditions = "Terms & conditions";

  // Remaining values from provided dart source
  static const String setPassword1ConditionError =
      "Add at least one lowercase letter to make it stronger";
  static const String setPassword2ConditionError =
      "Add at least one uppercase letter to make it stronger";
  static const String setPassword3ConditionError =
      "Add at least one number to make it stronger";
  static const String setPassword4ConditionError =
      "Add a special character to make it more secure";
  static const String setPassword5ConditionError =
      "Password should be between 6 and 30 characters";
  static const String confirmPassword = "Please confirm your password";
  static const String confirmPasswordInvalid =
      "Passwords don't match, please try again";
  static const String phoneInvalid = "Please enter a valid phone number";
  static const String nameRequired = "Please enter your name";
  static const String pinInvalid = "Please enter a valid PIN";
  static const String profileImage = "Please add a profile image";
  static const String usernameInvalid =
      "Username can only contain letters, numbers, dots and underscores";
  static const String username = "Username";
  static const String egyptianPhoneInvalid =
      "Phone must start with 01 and be 11 digits";
  static const String didntReceiveCode = "Didn't receive code?";
  static const String resendIn = "Resend in";
  static const String requestCancelled = "Request cancelled";
  static const String apiServerError = "Server error";
  static const String sessionExpired = "Session expired, please login again";
  static const String somethingWentWrong =
      "Something went wrong, please try again";

  static const String token = "token";
  static const String user = "user";

  // Home
  static const String categories = "Categories";
  static const String bestSeller = "Best seller";
  static const String viewAll = "View All";
  static const String deliverTo = "Deliver to";
  static const String egp = "EGP";

  // Category Names
  static const String flowers = "Flowers";
  static const String gift = "Gift";
  static const String card = "Card";
  static const String jewellery = "Jewellery";

  // Occasion Names
  static const String wedding = "Wedding";
  static const String birthday = "Birthday";
  static const String graduation = "Graduation";

  // Dummy Product Names
  static const String sunnyProduct = "Sunny";
  static const String redRosesProduct = "Red roses";
  static const String springVaseProduct = "Spring vase";

  // Navigation
  static const String cart = "Cart";
  static const String profile = "Profile";
  static const String home = "Home";
}
