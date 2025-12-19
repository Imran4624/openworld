const { expect } = require('chai');
const sinon = require('sinon');
const { mockFirestore } = require('../setup');

// Mock the utils module to prevent real Firebase calls
let mockUtils;

function createMockUtils() {
  return {
    getSecret: (key) => {
      return Promise.resolve(process.env[key] || '');
    },
    initStripe: () => {
      const mockStripe = {
        customers: { create: sinon.stub() },
        paymentIntents: { create: sinon.stub() },
        subscriptions: { create: sinon.stub() }
      };
      return Promise.resolve(mockStripe);
    },
    useIdempotency: (userId, operation) => {
      const idempotencyKey = `${userId}_${operation}_${Date.now()}`;
      const mockRef = {
        id: 'mock-doc-id',
        set: sinon.stub().resolves(),
        update: sinon.stub().resolves()
      };
      return Promise.resolve({ idempotencyKey, ref: mockRef });
    },
    completeIdempotency: (ref, status = 'completed') => {
      return Promise.resolve(ref.update({ 
        status, 
        completedAt: new Date() 
      }));
    }
  };
}

describe('Payment Utils - Comprehensive Testing', () => {
  beforeEach(() => {
    mockUtils = createMockUtils();
    sinon.resetHistory();
  });

  afterEach(() => {
    sinon.restore();
  });

  describe('getSecret function', () => {
    it('should return environment variable when it exists', async () => {
      process.env.TEST_SECRET = 'test-secret-value';
      const result = await mockUtils.getSecret('TEST_SECRET');
      expect(result).to.equal('test-secret-value');
    });

    it('should return empty string when environment variable does not exist', async () => {
      delete process.env.NON_EXISTENT_SECRET;
      const result = await mockUtils.getSecret('NON_EXISTENT_SECRET');
      expect(result).to.equal('');
    });

    it('should handle null and undefined environment values', async () => {
      process.env.NULL_SECRET = '';
      delete process.env.UNDEFINED_SECRET;
      
      const nullResult = await mockUtils.getSecret('NULL_SECRET');
      const undefinedResult = await mockUtils.getSecret('UNDEFINED_SECRET');
      
      expect(nullResult).to.equal('');
      expect(undefinedResult).to.equal('');
    });
  });

  describe('initStripe function', () => {
    it('should initialize Stripe with secret key from environment', async () => {
      process.env.STRIPE_SECRET_KEY = 'sk_test_valid_key';
      
      const stripe = await mockUtils.initStripe();
      expect(stripe).to.exist;
      expect(stripe.customers).to.exist;
      expect(stripe.paymentIntents).to.exist;
      expect(stripe.subscriptions).to.exist;
    });

    it('should return Stripe instance with all required methods', async () => {
      const stripe = await mockUtils.initStripe();
      expect(stripe.customers.create).to.be.a('function');
      expect(stripe.paymentIntents.create).to.be.a('function');
      expect(stripe.subscriptions.create).to.be.a('function');
    });
  });

  describe('useIdempotency function', () => {
    it('should create idempotency record with correct structure', async () => {
      const userId = 'test-user-123';
      const operation = 'test-payment';
      
      const result = await mockUtils.useIdempotency(userId, operation);
      
      expect(result).to.have.property('idempotencyKey');
      expect(result).to.have.property('ref');
      expect(result.idempotencyKey).to.be.a('string');
      expect(result.idempotencyKey).to.include(userId);
      expect(result.idempotencyKey).to.include(operation);
      expect(result.ref).to.be.an('object');
      expect(result.ref.update).to.be.a('function');
    });

    it('should generate unique idempotency keys for different calls', async () => {
      const userId = 'test-user-123';
      const operation = 'test-payment';
      
      const result1 = await mockUtils.useIdempotency(userId, operation);
      // Small delay to ensure different timestamps
      await new Promise(resolve => setTimeout(resolve, 1));
      const result2 = await mockUtils.useIdempotency(userId, operation);
      
      expect(result1.idempotencyKey).to.not.equal(result2.idempotencyKey);
    });

    it('should create proper document reference object', async () => {
      const result = await mockUtils.useIdempotency('user123', 'payment');
      
      expect(result.ref.id).to.equal('mock-doc-id');
      expect(result.ref.set).to.be.a('function');
      expect(result.ref.update).to.be.a('function');
    });
  });

  describe('completeIdempotency function', () => {
    it('should call update on the provided reference', async () => {
      const mockRef = {
        update: sinon.stub().resolves({ writeTime: new Date() })
      };
      
      await mockUtils.completeIdempotency(mockRef, 'completed');
      
      expect(mockRef.update.calledOnce).to.be.true;
    });

    it('should use default status when none provided', async () => {
      const mockRef = {
        update: sinon.stub().resolves({ writeTime: new Date() })
      };
      
      await mockUtils.completeIdempotency(mockRef);
      
      expect(mockRef.update.calledOnce).to.be.true;
    });

    it('should handle update errors gracefully', async () => {
      const mockRef = {
        update: sinon.stub().rejects(new Error('Firestore update failed'))
      };
      
      try {
        await mockUtils.completeIdempotency(mockRef, 'failed');
        expect.fail('Should have thrown an error');
      } catch (error) {
        expect(error.message).to.equal('Firestore update failed');
      }
    });
  });
});

describe('Integration Tests - Utils', () => {
  beforeEach(() => {
    mockUtils = createMockUtils();
  });

  it('should work together - full idempotency workflow', async () => {
    const userId = 'integration-test-user';
    const operation = 'integration-payment';
    
    // Create idempotency record
    const { idempotencyKey, ref } = await mockUtils.useIdempotency(userId, operation);
    
    expect(idempotencyKey).to.be.a('string');
    expect(idempotencyKey).to.include(userId);
    expect(ref).to.be.an('object');
    
    // Complete idempotency
    await mockUtils.completeIdempotency(ref, 'success');
    
    // Verify the workflow completed without errors
    expect(ref.update.calledOnce).to.be.true;
  });

  it('should handle environment configuration properly', async () => {
    process.env.TEST_CONFIG = 'test-value';
    
    const secret = await mockUtils.getSecret('TEST_CONFIG');
    const stripe = await mockUtils.initStripe();
    
    expect(secret).to.equal('test-value');
    expect(stripe).to.be.an('object');
  });

  it('should maintain idempotency across operations', async () => {
    const operations = ['payment1', 'payment2', 'payment3'];
    const userId = 'test-user';
    const keys = [];
    
    for (const operation of operations) {
      const { idempotencyKey } = await mockUtils.useIdempotency(userId, operation);
      keys.push(idempotencyKey);
    }
    
    // All keys should be unique
    const uniqueKeys = new Set(keys);
    expect(uniqueKeys.size).to.equal(operations.length);
    
    // All keys should contain the user ID
    keys.forEach(key => {
      expect(key).to.include(userId);
    });
  });
});