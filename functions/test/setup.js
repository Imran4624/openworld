const sinon = require('sinon');

// Set test environment first
process.env.NODE_ENV = 'test';
process.env.FUNCTIONS_EMULATOR = 'true';
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';
process.env.STRIPE_SECRET_KEY = 'sk_test_mock_key';
process.env.STRIPE_WEBHOOK_SECRET = 'whsec_mock_secret';
process.env.GOOGLE_APPLICATION_CREDENTIALS = '';

// Mock Firebase Admin completely to prevent any initialization
const mockFirestore = {
  collection: sinon.stub().returns({
    doc: sinon.stub().returns({
      set: sinon.stub().resolves({ writeTime: new Date() }),
      get: sinon.stub().resolves({ 
        exists: true, 
        data: sinon.stub().returns({ 
          id: 'mock-id',
          status: 'completed',
          timestamp: new Date()
        })
      }),
      update: sinon.stub().resolves({ writeTime: new Date() }),
      delete: sinon.stub().resolves({ writeTime: new Date() })
    }),
    add: sinon.stub().resolves({ id: 'mock-doc-id' }),
    get: sinon.stub().resolves({ 
      docs: [{ 
        id: 'mock-doc', 
        data: sinon.stub().returns({ field: 'value' })
      }],
      empty: false,
      size: 1
    }),
    where: sinon.stub().returnsThis(),
    limit: sinon.stub().returnsThis(),
    startAfter: sinon.stub().returnsThis()
  })
};

const mockAuth = {
  deleteUser: sinon.stub().resolves(),
  getUser: sinon.stub().resolves({ 
    uid: 'test-uid', 
    email: 'test@example.com' 
  }),
  createUser: sinon.stub().resolves({
    uid: 'new-test-uid',
    email: 'new@example.com'
  })
};

// Mock Firebase Admin SDK completely
const mockAdmin = {
  apps: [],
  initializeApp: sinon.stub().returns({}),
  firestore: sinon.stub().returns(mockFirestore),
  auth: sinon.stub().returns(mockAuth),
  app: sinon.stub().returns({
    firestore: sinon.stub().returns(mockFirestore),
    auth: sinon.stub().returns(mockAuth)
  })
};

// Mock Firebase Functions SDK to prevent cloud function initialization
const mockFunctions = {
  https: {
    onRequest: sinon.stub().returns({ run: sinon.stub() }),
    onCall: sinon.stub().returns({ run: sinon.stub() })
  },
  runWith: sinon.stub().returns({
    https: {
      onRequest: sinon.stub().returns({ run: sinon.stub() }),
      onCall: sinon.stub().returns({ run: sinon.stub() })
    }
  })
};

// Mock Stripe SDK completely
const mockStripe = {
  customers: {
    create: sinon.stub().resolves({
      id: 'cus_mock123',
      email: 'test@example.com',
      created: Math.floor(Date.now() / 1000)
    }),
    retrieve: sinon.stub().resolves({
      id: 'cus_mock123',
      email: 'test@example.com'
    }),
    update: sinon.stub().resolves({
      id: 'cus_mock123',
      email: 'updated@example.com'
    }),
    del: sinon.stub().resolves({ deleted: true, id: 'cus_mock123' })
  },
  paymentIntents: {
    create: sinon.stub().resolves({
      id: 'pi_mock123',
      status: 'succeeded',
      amount: 2000,
      currency: 'usd'
    }),
    retrieve: sinon.stub().resolves({
      id: 'pi_mock123',
      status: 'succeeded'
    }),
    confirm: sinon.stub().resolves({
      id: 'pi_mock123',
      status: 'succeeded'
    })
  },
  subscriptions: {
    create: sinon.stub().resolves({
      id: 'sub_mock123',
      status: 'active',
      customer: 'cus_mock123'
    }),
    retrieve: sinon.stub().resolves({
      id: 'sub_mock123',
      status: 'active'
    }),
    update: sinon.stub().resolves({
      id: 'sub_mock123',
      status: 'canceled'
    }),
    del: sinon.stub().resolves({
      id: 'sub_mock123',
      status: 'canceled'
    })
  },
  paymentMethods: {
    create: sinon.stub().resolves({
      id: 'pm_mock123',
      type: 'card',
      card: {
        brand: 'visa',
        last4: '4242',
        exp_month: 12,
        exp_year: 2025
      }
    }),
    retrieve: sinon.stub().resolves({
      id: 'pm_mock123',
      type: 'card',
      card: {
        brand: 'visa',
        last4: '4242'
      }
    }),
    update: sinon.stub().resolves({
      id: 'pm_mock123',
      type: 'card',
      billing_details: {
        name: 'Updated Name'
      }
    }),
    detach: sinon.stub().resolves({
      id: 'pm_mock123',
      object: 'payment_method'
    }),
    list: sinon.stub().resolves({
      object: 'list',
      data: [
        {
          id: 'pm_enabled123',
          type: 'card',
          card: { brand: 'visa', last4: '4242' }
        },
        {
          id: 'pm_disabled123', 
          type: 'card',
          card: { brand: 'mastercard', last4: '5678' }
        }
      ]
    })
  },
  refunds: {
    create: sinon.stub().resolves({
      id: 're_mock123',
      status: 'succeeded',
      amount: 1000
    })
  },
  webhooks: {
    constructEvent: sinon.stub().returns({
      id: 'evt_mock123',
      type: 'payment_intent.succeeded',
      data: {
        object: {
          id: 'pi_mock123',
          status: 'succeeded'
        }
      }
    })
  }
};

// Mock Stripe constructor
const MockStripeClass = sinon.stub().returns(mockStripe);
MockStripeClass.prototype = mockStripe;

// Override require cache to inject mocks
const Module = require('module');
const originalRequire = Module.prototype.require;

Module.prototype.require = function(id) {
  if (id === 'firebase-admin') {
    return mockAdmin;
  }
  if (id === 'firebase-functions') {
    return mockFunctions;
  }
  if (id === 'stripe') {
    return MockStripeClass;
  }
  return originalRequire.apply(this, arguments);
};

// Export mocks for test access
module.exports = { 
  mockAdmin, 
  mockFunctions, 
  mockStripe, 
  mockFirestore, 
  mockAuth,
  sinon 
};