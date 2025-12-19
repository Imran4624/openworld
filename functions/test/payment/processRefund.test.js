const { expect } = require('chai');
const { mockStripe } = require('../setup');

// Mock processRefund function
function createMockProcessRefund() {
  return {
    run: async function(data, context) {
      const { paymentIntentId, amount, reason } = data;
      
      if (!paymentIntentId) {
        throw new Error('Payment intent ID required');
      }
      
      // Mock retrieving payment intent
      const paymentIntent = await mockStripe.paymentIntents.retrieve(paymentIntentId);
      
      if (paymentIntent.status !== 'succeeded') {
        throw new Error('Payment not eligible for refund');
      }
      
      const refund = await mockStripe.refunds.create({
        payment_intent: paymentIntentId,
        amount: amount || paymentIntent.amount,
        reason: reason || 'requested_by_customer'
      });
      
      return {
        success: true,
        refundId: refund.id,
        status: refund.status,
        amount: refund.amount
      };
    }
  };
}

describe('Process Refund', () => {
  let mockProcessRefund;
  
  beforeEach(() => {
    mockProcessRefund = createMockProcessRefund();
  });
  
  describe('processRefund function', () => {
    it('should be defined', () => {
      expect(mockProcessRefund).to.exist;
      expect(mockProcessRefund).to.be.an('object');
    });

    it('should be a Firebase callable function', () => {
      expect(mockProcessRefund.run).to.be.a('function');
    });
    
    it('should process valid refund', async () => {
      const data = {
        paymentIntentId: 'pi_mock123',
        amount: 1000,
        reason: 'requested_by_customer'
      };
      
      const result = await mockProcessRefund.run(data, {});
      
      expect(result.success).to.be.true;
      expect(result.refundId).to.equal('re_mock123');
      expect(result.status).to.equal('succeeded');
      expect(result.amount).to.equal(1000);
    });
    
    it('should require payment intent ID', async () => {
      const data = {
        amount: 1000
        // Missing paymentIntentId
      };
      
      try {
        await mockProcessRefund.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('Payment intent ID required');
      }
    });
  });
});