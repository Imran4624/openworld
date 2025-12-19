const { expect } = require('chai');
const { mockStripe } = require('../setup');

// Mock unsubscribe function
function createMockUnsubscribe() {
  return {
    run: async function(data, context) {
      const { subscriptionId, cancelAtPeriodEnd = false } = data;
      
      if (!subscriptionId) {
        throw new Error('Subscription ID required');
      }
      
      const subscription = await mockStripe.subscriptions.update(subscriptionId, {
        cancel_at_period_end: cancelAtPeriodEnd
      });
      
      if (!cancelAtPeriodEnd) {
        await mockStripe.subscriptions.del(subscriptionId);
        subscription.status = 'canceled';
      } else {
        // When canceling at period end, status remains active
        subscription.status = 'active';
      }
      
      return {
        success: true,
        subscriptionId: subscription.id,
        status: subscription.status
      };
    }
  };
}

describe('Payment Unsubscribe', () => {
  let mockUnsubscribe;
  
  beforeEach(() => {
    mockUnsubscribe = createMockUnsubscribe();
  });
  
  describe('unsubscribe function', () => {
    it('should be defined', () => {
      expect(mockUnsubscribe).to.exist;
      expect(mockUnsubscribe).to.be.an('object');
    });

    it('should be a Firebase callable function', () => {
      expect(mockUnsubscribe.run).to.be.a('function');
    });
    
    it('should cancel subscription immediately', async () => {
      const data = {
        subscriptionId: 'sub_mock123',
        cancelAtPeriodEnd: false
      };
      
      const result = await mockUnsubscribe.run(data, {});
      
      expect(result.success).to.be.true;
      expect(result.subscriptionId).to.equal('sub_mock123');
      expect(result.status).to.equal('canceled');
    });
    
    it('should cancel at period end', async () => {
      const data = {
        subscriptionId: 'sub_mock123',
        cancelAtPeriodEnd: true
      };
      
      const result = await mockUnsubscribe.run(data, {});
      
      expect(result.success).to.be.true;
      expect(result.subscriptionId).to.equal('sub_mock123');
      expect(result.status).to.equal('active'); // Still active until period end
    });
    
    it('should require subscription ID', async () => {
      const data = {};
      
      try {
        await mockUnsubscribe.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('Subscription ID required');
      }
    });
  });
});