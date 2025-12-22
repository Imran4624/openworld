class Config {
  static const String PACKAGE_NAME = 'getopenworld.com';
  static const String APP_URL = 'getopenworld.com';
  static const String APP_NAME = 'Openworld';
  static const String APP_VERSION = '1.0.0+0';

  static const String API_SECRET = '';
  static const String SENTRY_DNS = '';
  static const String MICROSOFT_CLIENT_ID = '';

  static const bool DEBUG_EVENTS = true;
  static const bool DEBUG_REQUESTS = false;
  static const bool DEMO_MODE = false;
  static const String AZURE_MAPS_API_KEY =
      '3ku1comgJOz9pvekJDfUKfX2SNd5U0AHX011kw931MRv9u1olqNgJQQJ99BEACYeBjFg9drfAAAgAZMP26zc';
  static String autoMessageAdminProfileId = '';

  static const String TEST_EMAIL = 'demo@yopmail.com';
  static const String TEST_PASSWORD = '123456';
  static const String TEST_URL = 'https://demo.flutterboilerplate.com';
  static const String TEST_SECRET = '';
  static const String EVENTBRITE_API_KEY = '';
  static const String EVENTBRITE_ORGANIZATION_ID = '';

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
  static const String Gemini_API_KEY = 'AIzaSyAWPtjV1AXhoVQ5hR7aEK1KnJ7FBT6qWOk';
  static const String API_KEY = 'AIzaSyCLJVijFd0KYft9SDB-Tt-DK-a3IgiYdVI';
  static const String AUTH_DOMAIN = 'openworld-app.firebaseapp.com';
  static const String PROJECT_ID = 'openworld-app';
  static const String STORAGE_BUCKET = 'openworld-app.firebasestorage.app';
  static const String MESSAGING_SENDER_ID = '531251110143';
  static const String APP_ID = '1:531251110143:web:bd1820ae2abc236536acca';
  static const String MEASUREMENT_ID = 'G-6QW5WR5CMR';
  static const String GOOGLE_CLOUD_OAUTH_CLIENT_ID =
      '531251110143-utvp7i7f1r2lqjcb27hg5fpu22sl7kne.apps.googleusercontent.com';
  static const String VAPID_KEY = '';
  static const String CLOUDFUNCTION_FILTERPROFILES =
      'https://filterprofiles-a2h24aioca-uc.a.run.app';
  static const String CLOUDFUNCTION_DELETEUSER =
      'https://deleteuseraccount-a2h24aioca-uc.a.run.app';
  static const String CLOUDFUNCTION_SENDEMAIL =
      'https://sendemail-a2h24aioca-uc.a.run.app';

  static const String TICKET_TAILOR_API_KEY = '';

  static const String STRIPE_SECRET_KEY = 'sk_test_51SORA1IPMSTLVcCTgI1vf3kpp2jMhyuo2H6tB1RWXzp4s4SbZnuRDcsudwNKp9IkXh0tytu8CAnZ5bIQ9A6s94fp00Eka7RONR';
  static const String STRIPE_PUBLISHABLE_KEY = 'pk_live_51Rv0gGIVRY55KtDBjyS3i0ic80zQX5jzUn3U2Y3GEOhOh97jLx811quNrXD4A42G501NL6kApQuEpAuWLY43LVKw008jsAcf2Y';
  static const bool PAYMENT_ENABLED = false; 
  static const String PAYMENT_PROVIDER = 'stripe'; 
  static const String TEST_PAYMENT_METHOD = 'pm_card_visa'; 
  static const String PRODUCTION_PAYMENT_METHOD = 'pm_production_opw_default';
  static const String STRIPE_TEST_SECRET_KEY = 'sk_test_51SORA1IPMSTLVcCTgI1vf3kpp2jMhyuo2H6tB1RWXzp4s4SbZnuRDcsudwNKp9IkXh0tytu8CAnZ5bIQ9A6s94fp00Eka7RONR';
  static const String STRIPE_LIVE_SECRET_KEY = 'pk_live_51Rv0gGIVRY55KtDBjyS3i0ic80zQX5jzUn3U2Y3GEOhOh97jLx811quNrXD4A42G501NL6kApQuEpAuWLY43LVKw008jsAcf2Y';

  static const String SMTP_HOST = 'smtp.office365.com';
  static const String SMTP_PORT = '587';
  static const String SMTP_ENCRYPTION = 'STARTTLS';
  static const String SMTP_USERNAME = 'support@test.co.uk';
  static const String SMTP_PASSWORD = 'test!';
  static const String SMTP_FROM_EMAIL = 'support@test.co.uk';
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
