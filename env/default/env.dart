class Config {
  static const String PACKAGE_NAME = 'com.test.app';
  static const String APP_URL = 'app.test.com';
  static const String APP_NAME = 'Test app';
  static const String APP_VERSION = '1.0.0+1';

  static const String API_SECRET = '';
  static const String SENTRY_DNS = '';
  static const String MICROSOFT_CLIENT_ID = '';

  static const bool DEBUG_EVENTS = true;
  static const bool DEBUG_REQUESTS = false;
  static const bool DEMO_MODE = false;
  static const String AZURE_MAPS_API_KEY = '';
  static String autoMessageAdminProfileId = '';

  static const String EVENTBRITE_API_KEY = '';
  static const String EVENTBRITE_ORGANIZATION_ID = '';
  static const String TEST_EMAIL = 'demo@yopmail.com';
  static const String TEST_PASSWORD = '123456';
  static const String TEST_URL = 'https://demo.flutterboilerplate.com';
  static const String TEST_SECRET = '';

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
  static const String Gemini_API_KEY = '';
  static const String API_KEY = 'Ao';
  static const String AUTH_DOMAIN = 'co.firebaseapp.com';
  static const String PROJECT_ID = 'cock';
  static const String STORAGE_BUCKET = 'cockt.firebasestorage.app';
  static const String MESSAGING_SENDER_ID = '4609660874';
  static const String APP_ID = '1:460f1445733';
  static const String MEASUREMENT_ID = 'G-BJ9';
  static const String GOOGLE_CLOUD_OAUTH_CLIENT_ID =
      '';
  static const String VAPID_KEY = '';
  static const String CLOUDFUNCTION_FILTERPROFILES =
      '';
  static const String CLOUDFUNCTION_DELETEUSER =
      '';
  static const String CLOUDFUNCTION_SENDEMAIL = '';

  static const String TICKET_TAILOR_API_KEY =
      '';

  static const String SMTP_HOST = '';
  static const String SMTP_PORT = '';
  static const String SMTP_ENCRYPTION = '';
  static const String SMTP_USERNAME = '';
  static const String SMTP_PASSWORD = '';
  static const String SMTP_FROM_EMAIL = '';

  static const String STRIPE_SECRET_KEY = 'sk_test_...';
  static const String STRIPE_PUBLISHABLE_KEY = 'pk_test_...';
  static const bool PAYMENT_ENABLED = false; 
  static const String PAYMENT_PROVIDER = 'stripe'; 
  static const String TEST_PAYMENT_METHOD = 'pm_card_visa'; 
  static const String PRODUCTION_PAYMENT_METHOD = 'pm_production_opw_default';
  static const String STRIPE_TEST_SECRET_KEY = '';
  static const String STRIPE_LIVE_SECRET_KEY = '';
  static const String CLOUDFUNCTION_PROCESSPAYMENT =
      '';
  static const String CLOUDFUNCTION_GETPAYMENTSTATUS =
      '';


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
