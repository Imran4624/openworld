class Config {
  static const String PACKAGE_NAME = 'com.cocktailsandconversation.app';
  static const String APP_URL = 'app.cocktailsandconversation.com';
  static const String APP_NAME = 'Cocktails And Conversation';
  static const String APP_VERSION = '1.0.18+28';

  static const String API_SECRET = '';
  static const String SENTRY_DNS = '';
  static const String MICROSOFT_CLIENT_ID = '';

  static const bool DEBUG_EVENTS = false;
  static const bool DEBUG_REQUESTS = false;
  static const bool DEMO_MODE = false;
  static const String AZURE_MAPS_API_KEY = '';

  static String autoMessageAdminProfileId =
      'GpmhB1oo2hdhq5gus8u6GSCVQDx1'; // Gaia account

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
  static const String STRIPE_TEST_SECRET_KEY = '';
  static const String STRIPE_LIVE_SECRET_KEY = '';
  static const String TEST_EMAIL = 'demo@gmail.com';
  static const String TEST_PASSWORD = 'Password0';
  static const String TEST_URL = 'https://demo.flutterboilerplate.com';
  static const String TEST_SECRET = '';
  static const String EVENTBRITE_API_KEY = '';
  static const String EVENTBRITE_ORGANIZATION_ID = '';

  static const String Gemini_API_KEY = '';
  static const String API_KEY = 'AIzaSyD-Y-l7sCO0qT7ZJ-FW0RrHUU0kIt_PvCo';
  static const String AUTH_DOMAIN = 'cocktails-d9e40.firebaseapp.com';
  static const String PROJECT_ID = 'cocktails-d9e40';
  static const String STORAGE_BUCKET = 'cocktails-d9e40.firebasestorage.app';
  static const String MESSAGING_SENDER_ID = '460489660874';
  static const String APP_ID = '1:460489660874:web:f7bfcb6835a614f1445733';
  static const String MEASUREMENT_ID = 'G-90JP8YEBJ9';
  static const String GOOGLE_CLOUD_OAUTH_CLIENT_ID = '';
  static const String VAPID_KEY =
      'BGLzUsABl0NTSKAEylR8YUeNUPYPUj78bue4ensWgHiy2Flud5HTYrt44bWBCi49zKQdmjNx9vp82VxaWD2onO';
  static const String CLOUDFUNCTION_FILTERPROFILES =
      'https://filterprofiles-irjoscn7ja-uc.a.run.app';
  static const String CLOUDFUNCTION_DELETEUSER =
      'https://deleteuseraccount-irjoscn7ja-uc.a.run.app';
  static const String CLOUDFUNCTION_SENDEMAIL =
      'https://sendemail-irjoscn7ja-uc.a.run.app';
  static const String CLOUDFUNCTION_UPDATEAPPVERSION =
      'https://updateappversion-irjoscn7ja-uc.a.run.app';
  static const String CLOUDFUNCTION_PROCESSPAYMENT =
      '';
  static const String CLOUDFUNCTION_GETPAYMENTSTATUS =
      '';

  static const String TICKET_TAILOR_API_KEY =
      'sk_7018_142674_1f85b8722e7f82efaeedf303ce791920';

  static const String STRIPE_SECRET_KEY = 'sk_test_...'; 
  static const String STRIPE_PUBLISHABLE_KEY = 'pk_test_...';
  static const bool PAYMENT_ENABLED = false; 
  static const String PAYMENT_PROVIDER = 'stripe'; 
  static const String TEST_PAYMENT_METHOD = 'pm_card_mastercard'; 
  static const String PRODUCTION_PAYMENT_METHOD = 'pm_production_cac_default';

  static const String SMTP_HOST = 'smtp.office365.com';
  static const String SMTP_PORT = '587';
  static const String SMTP_ENCRYPTION = 'STARTTLS';
  static const String SMTP_USERNAME = 'Gaia@cocktailsandconversation.co.uk';
  static const String SMTP_PASSWORD = 'Kaikai10.';
  static const String SMTP_FROM_EMAIL = 'Gaia@cocktailsandconversation.co.uk';

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
