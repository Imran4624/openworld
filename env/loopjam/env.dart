class Config {
  static const String PACKAGE_NAME = 'com.loopjam.event';
  static const String APP_URL = 'loopjam.event';
  static const String APP_NAME = 'LoopJam Event';
  static const String APP_VERSION = '1.0.0+1';

  static const String API_SECRET = '';
  static const String SENTRY_DNS = '';
  static const String MICROSOFT_CLIENT_ID = '';

  static const bool DEBUG_EVENTS = true;
  static const bool DEBUG_REQUESTS = true;
  static const bool DEMO_MODE = false;
  static String autoMessageAdminProfileId = '';
  

  static const String STRIPE_TEST_SECRET_KEY = '';
  static const String STRIPE_LIVE_SECRET_KEY = 'pk_test_51SORA1IPMSTLVcCTyaqU57MmFGTifiGysXg9ZztiksSgZvnjb1CYMR0tJJZbZUTw8yxABgP8f6UbD1qvtRWGcPut00TBk3hQwU';
  static const String TEST_EMAIL = 'demo@flutterboilerplate.com';
  static const String TEST_PASSWORD = 'Password0';
  static const String TEST_URL = 'https://demo.loopjam.event';
  static const String TEST_SECRET = '';
  static const String AZURE_MAPS_API_KEY = '3ku1comgJOz9pvekJDfUKfX2SNd5U0AHX011kw931MRv9u1olqNgJQQJ99BEACYeBjFg9drfAAAgAZMP26zc';

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
  static const String CLOUDFUNCTION_PROCESSPAYMENT =
      'https://processpayment-neccbym74a-uc.a.run.app';
  static const String CLOUDFUNCTION_GETPAYMENTSTATUS =
      '';

  static const String EVENTBRITE_API_KEY = '';
  static const String EVENTBRITE_ORGANIZATION_ID = '';
  static const String Gemini_API_KEY = '';
  static const String API_KEY = 'AIzaSyCy0K4aQjlZuhVUEwpW5EaJ6i8eaAvGbNs';
  static const String AUTH_DOMAIN = 'loopjamevents.firebaseapp.com';
  static const String PROJECT_ID = 'loopjamevents';
  static const String STORAGE_BUCKET = 'loopjamevents.firebasestorage.app';
  static const String MESSAGING_SENDER_ID = '376148916664';
  static const String APP_ID = '1:376148916664:web:14ef0abc97959075acb74d';
  static const String MEASUREMENT_ID = 'G-VGZL35JXNJ';
  static const String GOOGLE_CLOUD_OAUTH_CLIENT_ID =
      '376148916664-osavijod5t5ub37nkfmloclubscmevio.apps.googleusercontent.com';

  static const String VAPID_KEY = '';
  static const String CLOUDFUNCTION_FILTERPROFILES = 'https://filterprofiles-neccbym74a-uc.a.run.app';
  static const String CLOUDFUNCTION_DELETEUSER = 'https://deleteuseraccount-neccbym74a-uc.a.run.app';
  static const String CLOUDFUNCTION_SENDEMAIL = 'https://sendemail-neccbym74a-uc.a.run.app';

  static const String TICKET_TAILOR_API_KEY = '';

  static const String STRIPE_SECRET_KEY = 'sk_test_...';
  static const String STRIPE_PUBLISHABLE_KEY = 'pk_test_51SORA1IPMSTLVcCTyaqU57MmFGTifiGysXg9ZztiksSgZvnjb1CYMR0tJJZbZUTw8yxABgP8f6UbD1qvtRWGcPut00TBk3hQwU';
  static const bool PAYMENT_ENABLED = false; 
  static const String PAYMENT_PROVIDER = 'stripe'; 
  static const String TEST_PAYMENT_METHOD = 'pm_card_amex'; 
  static const String PRODUCTION_PAYMENT_METHOD = 'pm_production_loopjam_default';

  static const String SMTP_HOST = 'mail.loopjam.app';
  static const String SMTP_PORT = '465';
  static const String SMTP_ENCRYPTION = 'STARTTLS';
  static const String SMTP_USERNAME = 'no-reply@loopjam.app';
  static const String SMTP_PASSWORD = '3Y8+maEt0ntc';
  static const String SMTP_FROM_EMAIL = 'no-reply@loopjam.app';
  // App Version Configuration
  static const String APP_VERSION_MINIMUM = '1.0.0';
  static const String APP_VERSION_UPDATE_URL = 'https://updateappversion-neccbym74a-uc.a.run.app';
  static const String APP_VERSION_RELEASE_NOTES =
      'Auto update via cloud function.';
  static const bool APP_VERSION_UPDATE_REQUIRED = false;
  static const bool APP_VERSION_MAINTENANCE_MODE = false;
  static const String APP_VERSION_MAINTENANCE_MESSAGE = '';
  static const String AZURE_CLIENT_BASE_URL = 'https://loopjam.blob.core.windows.net/loopjamweb';
  static const String AZURE_CLIENT_SAS_TOKEN = 'sp=racwdli&st=2025-06-08T11:41:04Z&se=2027-03-31T19:41:04Z&spr=https&sv=2024-11-04&sr=c&sig=XlWoMtTEfc4q1NAaL3lbpMI84%2BvY97JqIrumGookFx0%3D';
}
