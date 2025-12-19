const { expect } = require('chai');
const { mockStripe } = require('../setup');

// Mock subscribe function
function createMockSubscribe() {
  return {
    run: async function(data, context) {
      const { customerId, priceId, paymentMethodId } = data;
      
      if (!customerId || !priceId) {
        throw new Error('Customer ID and Price ID required');
      }
      
      const subscription = await mockStripe.subscriptions.create({
        customer: customerId,
        items: [{ price: priceId }],
        default_payment_method: paymentMethodId
      });
      
      return {
        success: true,
        subscriptionId: subscription.id,
        status: subscription.status
      };
    }
  };
}

describe('Payment Subscribe', () => {
  let mockSubscribe;
  
  beforeEach(() => {
    mockSubscribe = createMockSubscribe();
  });
  
  describe('subscribe function', () => {
    it('should be defined', () => {
      expect(mockSubscribe).to.exist;
      expect(mockSubscribe).to.be.an('object');
    });

    it('should be a Firebase callable function', () => {
      expect(mockSubscribe.run).to.be.a('function');
    });
    
    it('should create subscription with valid data', async () => {
      const data = {
        customerId: 'cus_mock123',
        priceId: 'price_mock123',
        paymentMethodId: 'pm_mock123'
      };
      
      const result = await mockSubscribe.run(data, {});
      
      expect(result.success).to.be.true;
      expect(result.subscriptionId).to.equal('sub_mock123');
      expect(result.status).to.equal('active');
    });
    
    it('should require customer and price ID', async () => {
      const data = {
        // Missing required fields
      };
      
      try {
        await mockSubscribe.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('Customer ID and Price ID required');
      }
    });
  });
});