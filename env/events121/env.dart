class Config {
  static const String PACKAGE_NAME = 'com.events121.app';
  static const String APP_URL = 'app.events121.com';
  static const String APP_NAME = 'Events121';
  static const String APP_VERSION = '1.0.0+1';

  static const String API_SECRET = '';
  static const String SENTRY_DNS = '';
  static const String MICROSOFT_CLIENT_ID = '';

  static const bool DEBUG_EVENTS = false;
  static const bool DEBUG_REQUESTS = false;
  static const bool DEMO_MODE = false;
  static const String AZURE_MAPS_API_KEY = '';

  static String autoMessageAdminProfileId =
      'GpmhB1oo2hdhq5gus8u6GSCVQDx1'; // Gaia account

  static const String TEST_EMAIL = 'demo@gmail.com';
  static const String TEST_PASSWORD = 'Password0';
  static const String TEST_URL = 'https://demo.flutterboilerplate.com';
  static const String TEST_SECRET = '';


  static const String EVENTBRITE_API_KEY = 'FRNN5MGJPKFV27LKFKLN';
  // use this command with EVENTBRITE_API_KEY for getting the EVENTBRITE_ORGANIZATION_ID
  // curl -H "Authorization: Bearer FRNN5MGJPKFV27LKFKLN" https://www.eventbriteapi.com/v3/users/me/organizations/
  static const String EVENTBRITE_ORGANIZATION_ID = '2983717820874';

  static const String Gemini_API_KEY = '';
  static const String API_KEY = 'AIzaSyDJIBvc62uZ7OX2WeyF9zs4NYVejqz5RNg';
  static const String AUTH_DOMAIN = 'events121-6151e.firebaseapp.com';
  static const String PROJECT_ID = 'events121-6151e';
  static const String STORAGE_BUCKET = 'events121-6151e.firebasestorage.app';
  static const String MESSAGING_SENDER_ID = '884203756670';
  static const String APP_ID = '1:884203756670:web:776eebb1b894c745140c2f';
  static const String MEASUREMENT_ID = 'G-JTK2FVPNMD';
  static const String GOOGLE_CLOUD_OAUTH_CLIENT_ID = '884203756670-i93jsmiai7gbuetu3f7a43gcisv8i0g9.apps.googleusercontent.com';
  static const String VAPID_KEY =
      '';
       // Stripe Configuration
  static const String STRIPE_PUBLISHABLE_KEY = 'pk_test_51SORA1IPMSTLVcCTyaqU57MmFGTifiGysXg9ZztiksSgZvnjb1CYMR0tJJZbZUTw8yxABgP8f6UbD1qvtRWGcPut00TBk3hQwU';

  // New Payment Cloud Functions
  static const String CF_CREATE_STRIPE_CUSTOMER = 'https://createstripecustomer-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_CREATE_STRIPE_CONNECT_ACCOUNT = 'https://createstripeconnectaccount-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_CREATE_PAYMENT_METHOD = 'https://createpaymentmethod-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_GET_PAYMENT_METHODS = 'https://getpaymentmethods-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_UPDATE_PAYMENT_METHOD = 'https://updatepaymentmethod-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_DELETE_PAYMENT_METHOD = 'https://deletepaymentmethod-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_SET_DEFAULT_PAYMENT_METHOD = 'https://setdefaultpaymentmethod-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_TOGGLE_PAYMENT_METHOD = 'https://setdefaultpaymentmethod-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_PROCESS_ONE_TIME_PAYMENT = 'https://processonetimepayment-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_SUBSCRIBE = 'https://subscribe-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_UNSUBSCRIBE = 'https://unsubscribe-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_REFUND = 'https://refund-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CF_PAYMENT_WEBHOOKS = 'https://paymentwebhooks-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CLOUDFUNCTION_FILTERPROFILES =
      'https://filterprofiles-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CLOUDFUNCTION_DELETEUSER =
      'https://deleteuseraccount-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CLOUDFUNCTION_SENDEMAIL =
      'https://sendemail-events121-6i2r3ib7ca-uc.a.run.app';
  static const String CLOUDFUNCTION_UPDATEAPPVERSION =
      'https://updateappversion-6i2r3ib7ca-uc.a.run.app';
  static const String CLOUDFUNCTION_PROCESSPAYMENT =
      'https://processpayment-6i2r3ib7ca-uc.a.run.app';
  static const String CLOUDFUNCTION_GETPAYMENTSTATUS =
      'https://getpaymentstatus-6i2r3ib7ca-uc.a.run.app';

  static const String TICKET_TAILOR_API_KEY =
      'sk_10901_250766_7d16f6061ed93e5efcd8332d40953df8';

  static const String STRIPE_SECRET_KEY = 'sk_test_...'; 
  static const String STRIPE_TEST_SECRET_KEY = 'sk_test_51Rv0gGIVRY55KtDBcAZ0QOZXJFZX7Kn1WaeZmWpyEE8sfKIgXIYzXz1boqllPIJ2TTzk99qPJiIFePt8ZCR65ySZ00XnpgwNYO';
  static const String STRIPE_LIVE_SECRET_KEY = 'pk_test_51SORA1IPMSTLVcCTyaqU57MmFGTifiGysXg9ZztiksSgZvnjb1CYMR0tJJZbZUTw8yxABgP8f6UbD1qvtRWGcPut00TBk3hQwU';
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
  static const String APP_VERSION_UPDATE_URL = 'https://updateappversion-events121-6i2r3ib7ca-uc.a.run.appe';
  static const String APP_VERSION_RELEASE_NOTES =
      'Auto update via cloud function.';
  static const bool APP_VERSION_UPDATE_REQUIRED = false;
  static const bool APP_VERSION_MAINTENANCE_MODE = false;
  static const String APP_VERSION_MAINTENANCE_MESSAGE = '';
  static const String AZURE_CLIENT_BASE_URL = '';
  static const String AZURE_CLIENT_SAS_TOKEN = '';
}
