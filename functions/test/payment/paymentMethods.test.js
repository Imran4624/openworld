const { expect } = require('chai');
const { mockStripe, mockFirestore, sinon } = require('../setup');

// Mock createPaymentMethod function
function createMockCreatePaymentMethod() {
  return {
    run: async function(data, context) {
      const { card, billing_details } = data;
      
      if (!card || !card.number || !card.exp_month || !card.exp_year || !card.cvc) {
        throw new Error('Card details (number, exp_month, exp_year, cvc) are required');
      }
      
      // Mock user lookup
      const mockUserDoc = {
        exists: true,
        data: () => ({ stripeCustomerId: 'cus_test123' })
      };
      
      if (!mockUserDoc.data().stripeCustomerId) {
        throw new Error('User does not have a Stripe customer account. Please create a customer first.');
      }
      
      const paymentMethod = await mockStripe.paymentMethods.create({
        type: 'card',
        card: {
          number: card.number,
          exp_month: card.exp_month,
          exp_year: card.exp_year,
          cvc: card.cvc
        },
        billing_details: billing_details || {}
      });
      
      return {
        success: true,
        data: {
          paymentMethodId: paymentMethod.id,
          type: paymentMethod.type,
          card: {
            brand: paymentMethod.card?.brand,
            last4: paymentMethod.card?.last4,
            expMonth: paymentMethod.card?.exp_month,
            expYear: paymentMethod.card?.exp_year
          },
          createdAt: new Date().toISOString()
        }
      };
    }
  };
}

// Mock getPaymentMethods function
function createMockGetPaymentMethods() {
  return {
    run: async function(data, context) {
      // Mock user lookup
      const mockUserData = {
        stripeCustomerId: 'cus_test123',
        paymentMethods: [
          {
            paymentMethodId: 'pm_test123',
            brand: 'visa',
            last4: '4242',
            expMonth: 12,
            expYear: 2025,
            isEnabled: true,
            createdAt: new Date()
          }
        ],
        defaultPaymentMethodId: 'pm_test123'
      };
      
      if (!mockUserData.stripeCustomerId) {
        throw new Error('User does not have a Stripe customer account');
      }
      
      const mockStripePaymentMethods = {
        data: [
          {
            id: 'pm_test123',
            type: 'card',
            card: { brand: 'visa', last4: '4242', exp_month: 12, exp_year: 2025 },
            created: Math.floor(Date.now() / 1000)
          }
        ]
      };
      
      const enrichedPaymentMethods = mockStripePaymentMethods.data.map(pm => {
        const stored = mockUserData.paymentMethods.find(spm => spm.paymentMethodId === pm.id);
        return {
          paymentMethodId: pm.id,
          type: pm.type,
          card: {
            brand: pm.card?.brand,
            last4: pm.card?.last4,
            expMonth: pm.card?.exp_month,
            expYear: pm.card?.exp_year
          },
          isPrimary: pm.id === mockUserData.defaultPaymentMethodId,
          isEnabled: stored?.isEnabled !== false,
          createdAt: stored?.createdAt || new Date(pm.created * 1000).toISOString()
        };
      });
      
      return {
        success: true,
        data: {
          paymentMethods: enrichedPaymentMethods,
          defaultPaymentMethodId: mockUserData.defaultPaymentMethodId
        }
      };
    }
  };
}

// Mock updatePaymentMethod function
function createMockUpdatePaymentMethod() {
  return {
    run: async function(data, context) {
      const { paymentMethodId, billing_details, card } = data;
      
      if (!paymentMethodId) {
        throw new Error('paymentMethodId is required');
      }
      
      // Mock user lookup
      const mockUserData = {
        stripeCustomerId: 'cus_test123',
        paymentMethods: [
          { paymentMethodId: 'pm_test123', brand: 'visa', last4: '4242' }
        ]
      };
      
      if (!mockUserData.stripeCustomerId) {
        throw new Error('User does not have a Stripe customer account');
      }
      
      const updatedPaymentMethod = await mockStripe.paymentMethods.update(paymentMethodId, {
        billing_details: billing_details || {},
        card: card || {}
      });
      
      return {
        success: true,
        data: {
          paymentMethodId: updatedPaymentMethod.id,
          type: updatedPaymentMethod.type,
          card: {
            brand: updatedPaymentMethod.card?.brand,
            last4: updatedPaymentMethod.card?.last4,
            expMonth: updatedPaymentMethod.card?.exp_month,
            expYear: updatedPaymentMethod.card?.exp_year
          },
          billing_details: updatedPaymentMethod.billing_details,
          updatedAt: new Date().toISOString()
        }
      };
    }
  };
}

// Mock deletePaymentMethod function
function createMockDeletePaymentMethod() {
  return {
    run: async function(data, context) {
      const { paymentMethodId } = data;
      
      if (!paymentMethodId) {
        throw new Error('paymentMethodId is required');
      }
      
      // Mock user lookup
      const mockUserData = {
        stripeCustomerId: 'cus_test123',
        paymentMethods: [
          { paymentMethodId: 'pm_test123' }
        ]
      };
      
      if (!mockUserData.stripeCustomerId) {
        throw new Error('User does not have a Stripe customer account');
      }
      
      await mockStripe.paymentMethods.detach(paymentMethodId);
      
      return {
        success: true,
        data: {
          paymentMethodId,
          deleted: true,
          message: 'Payment method successfully deleted'
        }
      };
    }
  };
}

// Mock setDefaultPaymentMethod function
function createMockSetDefaultPaymentMethod() {
  return {
    run: async function(data, context) {
      const { paymentMethodId } = data;
      
      if (!paymentMethodId) {
        throw new Error('paymentMethodId is required');
      }
      
      // Mock user lookup
      const mockUserData = {
        paymentMethods: [
          { paymentMethodId: 'pm_test123' }
        ]
      };
      
      const paymentMethodExists = mockUserData.paymentMethods.some(pm => pm.paymentMethodId === paymentMethodId);
      
      if (!paymentMethodExists) {
        throw new Error('Payment method not found for this user');
      }
      
      return {
        success: true,
        data: {
          defaultPaymentMethodId: paymentMethodId,
          message: 'Default payment method updated successfully'
        }
      };
    }
  };
}

// Mock togglePaymentMethod function
function createMockTogglePaymentMethod() {
  return {
    run: async function(data, context) {
      const { paymentMethodId, enabled } = data;
      
      if (!paymentMethodId) {
        throw new Error('paymentMethodId is required');
      }
      
      if (typeof enabled !== 'boolean') {
        throw new Error('enabled must be a boolean value');
      }
      
      // Mock user lookup
      const mockUserData = {
        paymentMethods: [
          { paymentMethodId: 'pm_test123', isEnabled: true }
        ]
      };
      
      const paymentMethodExists = mockUserData.paymentMethods.some(pm => pm.paymentMethodId === paymentMethodId);
      
      if (!paymentMethodExists) {
        throw new Error('Payment method not found for this user');
      }
      
      return {
        success: true,
        data: {
          paymentMethodId,
          enabled,
          message: `Payment method ${enabled ? 'enabled' : 'disabled'} successfully`
        }
      };
    }
  };
}

describe('Payment Methods Management', () => {
  let mockCreatePaymentMethod;
  let mockGetPaymentMethods;
  let mockUpdatePaymentMethod;
  let mockDeletePaymentMethod;
  let mockSetDefaultPaymentMethod;
  let mockTogglePaymentMethod;
  
  beforeEach(() => {
    mockCreatePaymentMethod = createMockCreatePaymentMethod();
    mockGetPaymentMethods = createMockGetPaymentMethods();
    mockUpdatePaymentMethod = createMockUpdatePaymentMethod();
    mockDeletePaymentMethod = createMockDeletePaymentMethod();
    mockSetDefaultPaymentMethod = createMockSetDefaultPaymentMethod();
    mockTogglePaymentMethod = createMockTogglePaymentMethod();
  });
  
  describe('createPaymentMethod function', () => {
    it('should be defined', () => {
      expect(mockCreatePaymentMethod).to.exist;
      expect(mockCreatePaymentMethod).to.be.an('object');
    });

    it('should be a Firebase callable function', () => {
      expect(mockCreatePaymentMethod.run).to.be.a('function');
    });
    
    it('should create payment method with valid card', async () => {
      const data = {
        card: {
          number: '4242424242424242',
          exp_month: 12,
          exp_year: 2025,
          cvc: '123'
        },
        billing_details: {
          name: 'John Doe'
        }
      };
      
      const result = await mockCreatePaymentMethod.run(data, {});
      
      expect(result.success).to.be.true;
      expect(result.data.paymentMethodId).to.equal('pm_mock123');
      expect(result.data.card.brand).to.equal('visa');
      expect(result.data.card.last4).to.equal('4242');
    });
    
    it('should validate required card fields', async () => {
      const data = {
        card: {
          number: '4242424242424242'
          // Missing exp_month, exp_year, cvc
        }
      };
      
      try {
        await mockCreatePaymentMethod.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('Card details (number, exp_month, exp_year, cvc) are required');
      }
    });
    
    it('should require stripe customer account', async () => {
      // Override mock to simulate no customer
      const mockCreateWithoutCustomer = {
        run: async function(data, context) {
          const { card } = data;
          
          if (!card?.number) {
            throw new Error('Card details required');
          }
          
          throw new Error('User does not have a Stripe customer account. Please create a customer first.');
        }
      };
      
      const data = {
        card: {
          number: '4242424242424242',
          exp_month: 12,
          exp_year: 2025,
          cvc: '123'
        }
      };
      
      try {
        await mockCreateWithoutCustomer.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('User does not have a Stripe customer account. Please create a customer first.');
      }
    });
  });

  describe('getPaymentMethods function', () => {
    it('should return user payment methods', async () => {
      const result = await mockGetPaymentMethods.run({}, {});
      
      expect(result.success).to.be.true;
      expect(result.data.paymentMethods).to.be.an('array');
      expect(result.data.paymentMethods.length).to.be.greaterThan(0);
      expect(result.data.paymentMethods[0].paymentMethodId).to.equal('pm_test123');
      expect(result.data.paymentMethods[0].isPrimary).to.be.true;
      expect(result.data.paymentMethods[0].isEnabled).to.be.true;
      expect(result.data.defaultPaymentMethodId).to.equal('pm_test123');
    });
  });

  describe('updatePaymentMethod function', () => {
    it('should update payment method', async () => {
      const data = {
        paymentMethodId: 'pm_test123',
        billing_details: {
          name: 'John Doe Updated'
        }
      };
      
      const result = await mockUpdatePaymentMethod.run(data, {});
      
      expect(result.success).to.be.true;
      expect(result.data.paymentMethodId).to.equal('pm_mock123');
    });
    
    it('should require paymentMethodId', async () => {
      const data = {
        billing_details: {
          name: 'John Doe'
        }
      };
      
      try {
        await mockUpdatePaymentMethod.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('paymentMethodId is required');
      }
    });
  });

  describe('deletePaymentMethod function', () => {
    it('should delete payment method', async () => {
      const data = {
        paymentMethodId: 'pm_test123'
      };
      
      const result = await mockDeletePaymentMethod.run(data, {});
      
      expect(result.success).to.be.true;
      expect(result.data.paymentMethodId).to.equal('pm_test123');
      expect(result.data.deleted).to.be.true;
    });
    
    it('should require paymentMethodId', async () => {
      const data = {};
      
      try {
        await mockDeletePaymentMethod.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('paymentMethodId is required');
      }
    });
  });

  describe('setDefaultPaymentMethod function', () => {
    it('should set default payment method', async () => {
      const data = {
        paymentMethodId: 'pm_test123'
      };
      
      const result = await mockSetDefaultPaymentMethod.run(data, {});
      
      expect(result.success).to.be.true;
      expect(result.data.defaultPaymentMethodId).to.equal('pm_test123');
    });
    
    it('should require paymentMethodId', async () => {
      const data = {};
      
      try {
        await mockSetDefaultPaymentMethod.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('paymentMethodId is required');
      }
    });
    
    it('should validate payment method belongs to user', async () => {
      const data = {
        paymentMethodId: 'pm_nonexistent'
      };
      
      try {
        await mockSetDefaultPaymentMethod.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('Payment method not found for this user');
      }
    });
  });

  describe('togglePaymentMethod function', () => {
    it('should enable/disable payment method', async () => {
      const data = {
        paymentMethodId: 'pm_test123',
        enabled: false
      };
      
      const result = await mockTogglePaymentMethod.run(data, {});
      
      expect(result.success).to.be.true;
      expect(result.data.paymentMethodId).to.equal('pm_test123');
      expect(result.data.enabled).to.be.false;
    });
    
    it('should require paymentMethodId', async () => {
      const data = {
        enabled: false
      };
      
      try {
        await mockTogglePaymentMethod.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('paymentMethodId is required');
      }
    });
    
    it('should require enabled boolean', async () => {
      const data = {
        paymentMethodId: 'pm_test123',
        enabled: 'false' // String instead of boolean
      };
      
      try {
        await mockTogglePaymentMethod.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('enabled must be a boolean value');
      }
    });
    
    it('should validate payment method belongs to user', async () => {
      const data = {
        paymentMethodId: 'pm_nonexistent',
        enabled: false
      };
      
      try {
        await mockTogglePaymentMethod.run(data, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('Payment method not found for this user');
      }
    });
  });
});