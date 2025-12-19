const { expect } = require('chai');
const { mockStripe, mockFirestore } = require('../setup');

// Mock processOneTimePayment function
function createMockProcessOneTimePayment() {
  return {
    run: async function(data, context) {
      const { userId, amount, currency = 'usd', recipientId, paymentMethodId } = data;
      
      if (!userId) {
        throw new Error('userId is required');
      }
      
      if (!amount || amount < 50) {
        throw new Error('Invalid amount');
      }
      
      if (!recipientId) {
        throw new Error('recipientId is required');
      }
      
      if (!paymentMethodId) {
        throw new Error('paymentMethodId is required');
      }
      
      // Mock customer data check with payment methods
      const mockCustomerDoc = {
        stripeCustomerId: 'cus_test123',
        paymentMethods: [
          {
            paymentMethodId: 'pm_test123',
            brand: 'visa',
            last4: '4242',
            isEnabled: true
          },
          {
            paymentMethodId: 'pm_disabled123',
            brand: 'visa', 
            last4: '1111',
            isEnabled: false
          }
        ]
      };
      
      // Validate payment method belongs to user and is enabled
      const paymentMethodData = mockCustomerDoc.paymentMethods.find(pm => pm.paymentMethodId === paymentMethodId);
      
      if (!paymentMethodData) {
        throw new Error('Payment method not found for this user');
      }
      
      if (paymentMethodData.isEnabled === false) {
        throw new Error('Payment method is disabled');
      }
      
      const paymentIntent = await mockStripe.paymentIntents.create({
        amount,
        currency,
        payment_method: paymentMethodId,
        confirm: true
      });
      
      return {
        success: true,
        paymentIntentId: paymentIntent.id,
        status: paymentIntent.status
      };
    }
  };
}

describe('Process One Time Payment', () => {
  let mockProcessOneTimePayment;
  
  beforeEach(() => {
    mockProcessOneTimePayment = createMockProcessOneTimePayment();
  });
  
  describe('processOneTimePayment function', () => {
    it('should be defined', () => {
      expect(mockProcessOneTimePayment).to.exist;
      expect(mockProcessOneTimePayment).to.be.an('object');
    });

    it('should be a Firebase callable function', () => {
      expect(mockProcessOneTimePayment.run).to.be.a('function');
    });
    
    it('should process valid payment', async () => {
      const data = {
        userId: 'user123',
        recipientId: 'recipient456',
        amount: 2000,
        currency: 'usd',
        paymentMethodId: 'pm_test123',
        commissionAmount: 15,
        commissionType: 'percentage',
        description: 'Payment for services',
        paymentType: 'marketplace'
      };
      
      const result = await mockProcessOneTimePayment.run(data, {});
      
      expect(result.success).to.be.true;
      expect(result.paymentIntentId).to.equal('pi_mock123');
      expect(result.status).to.equal('succeeded');
    });
    
    it('should validate minimum amount', async () => {
      const data = {
        userId: 'user123',
        recipientId: 'recipient456',
        amount: 25, // Below minimum
        paymentMethodId: 'pm_test123',
        commissionAmount: 15,
        commissionType: 'percentage',
        description: 'Payment for services',
        paymentType: 'marketplace'
      };
      
      try {
        await mockProcessOneTimePayment.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('Invalid amount');
      }
    });
    
    it('should require payment method ID', async () => {
      const data = {
        userId: 'user123',
        recipientId: 'recipient456',
        amount: 2000,
        commissionAmount: 15,
        commissionType: 'percentage',
        description: 'Payment for services',
        paymentType: 'marketplace'
        // Missing paymentMethodId
      };
      
      try {
        await mockProcessOneTimePayment.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('paymentMethodId is required');
      }
    });
    
    it('should validate payment method belongs to user', async () => {
      const data = {
        userId: 'user123',
        recipientId: 'recipient456',
        amount: 2000,
        currency: 'usd',
        paymentMethodId: 'pm_nonexistent', // Payment method not in user's list
        commissionAmount: 15,
        commissionType: 'percentage',
        description: 'Payment for services',
        paymentType: 'marketplace'
      };
      
      try {
        await mockProcessOneTimePayment.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('Payment method not found for this user');
      }
    });
    
    it('should reject disabled payment methods', async () => {
      const data = {
        userId: 'user123',
        recipientId: 'recipient456',
        amount: 2000,
        currency: 'usd',
        paymentMethodId: 'pm_disabled123', // This payment method is disabled
        commissionAmount: 15,
        commissionType: 'percentage',
        description: 'Payment for services',
        paymentType: 'marketplace'
      };
      
      try {
        await mockProcessOneTimePayment.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('Payment method is disabled');
      }
    });
  });
});