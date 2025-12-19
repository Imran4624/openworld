class Config {
  static const String PACKAGE_NAME = 'com.zawajcards.app';
  static const String APP_URL = 'app.zawajcards.com';
  static const String APP_NAME = 'Zawaj Cards';
  static const String APP_VERSION = '1.0.0+1';

  static const String API_SECRET = '';
  static const String SENTRY_DNS = '';
  static const String MICROSOFT_CLIENT_ID = '';

  static const bool DEBUG_EVENTS = false;
  static const bool DEBUG_REQUESTS = false;
  static const bool DEMO_MODE = false;
  static const String AZURE_MAPS_API_KEY = '';
  static String autoMessageAdminProfileId = '';
  static const String EVENTBRITE_API_KEY = '';
  static const String EVENTBRITE_ORGANIZATION_ID = '';
  static const String STRIPE_TEST_SECRET_KEY = '';
  static const String STRIPE_LIVE_SECRET_KEY = '';

  static const String TEST_EMAIL = 'demo@flutterboilerplate.com';
  static const String TEST_PASSWORD = 'Password0';
  static const String TEST_URL = 'https://demo.flutterboilerplate.com';
  static const String TEST_SECRET = '';
  static const String GOOGLE_CLOUD_OAUTH_CLIENT_ID = '';
  static const String CLOUDFUNCTION_PROCESSPAYMENT =
      '';
  static const String CLOUDFUNCTION_GETPAYMENTSTATUS =
      '';

  // New Payment Cloud Functions
  static const String CF_CREATE_STRIPE_CUSTOMER = '';
  static const String CF_CREATE_STRIPE_CONNECT_ACCOUNT = '';
  static const String CF_CREATE_PAYMENT_METHOD = '';
  static const String CF_GET_PAYMENT_METHODS = '';
  static const String CF_UPDATE_PAYMENT_METHOD = '';
  static const String CF_DELETE_PAYMENT_METHOD = '';
  static const String CF_SET_DEFAULT_PAYMENT_METHOD = '';
  static const String CF_TOGGLE_PAYMENT_METHOD = '';
  static const String CF_PROCESS_ONE_TIME_PAYMENT = '';
  static const String CF_SUBSCRIBE = '';
  static const String CF_UNSUBSCRIBE = '';
  static const String CF_REFUND = '';
  static const String CF_PAYMENT_WEBHOOKS = '';


  static const String STRIPE_SECRET_KEY = 'sk_test_...';
  static const String STRIPE_PUBLISHABLE_KEY = 'pk_test_...';
  static const bool PAYMENT_ENABLED = false; 
  static const String PAYMENT_PROVIDER = 'stripe'; 
  static const String TEST_PAYMENT_METHOD = 'pm_card_visa'; 
  static const String PRODUCTION_PAYMENT_METHOD = 'pm_production_opw_default';

  static const String Gemini_API_KEY = '';
  static const String API_KEY = 'AIzaSyD9dr4XwswRDM-XsyTU35y_RmYimyNnHK0';
  static const String AUTH_DOMAIN = 'boilerpalte-dating-demo.firebaseapp.com';
  static const String PROJECT_ID = 'boilerpalte-dating-demo';
  static const String STORAGE_BUCKET =
      'boilerpalte-dating-demo.firebasestorage.app';
  static const String MESSAGING_SENDER_ID = '659432408711';
  static const String APP_ID = '1:659432408711:web:c81e661132210f97be1a22';
  static const String MEASUREMENT_ID = 'G-1TPFYEE0X5';

  static const String CLOUDFUNCTION_FILTERPROFILES =
      'https://filterprofiles-pvujajrlua-uc.a.run.app';
  static const String CLOUDFUNCTION_DELETEUSER = '';

  // App Version Configuration
  static const String APP_VERSION_MINIMUM = '1.0.0';
  static const String APP_VERSION_UPDATE_URL = 'https://example.com/update';
  static const String APP_VERSION_RELEASE_NOTES =
      'Auto update via cloud function.';
  static const bool APP_VERSION_UPDATE_REQUIRED = false;
  static const bool APP_VERSION_MAINTENANCE_MODE = false;
  static const String APP_VERSION_MAINTENANCE_MESSAGE = '';
  static const String AZURE_CLIENT_BASE_URL = '';
  static const String AZURE_CLIENT_SAS_TOKEN = '';
}
