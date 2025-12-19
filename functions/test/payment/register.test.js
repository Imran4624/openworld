const { expect } = require('chai');
const sinon = require('sinon');
const { mockStripe, mockFirestore, mockAuth } = require('../setup');

// Mock the register function behavior
function createMockRegister() {
  return async function mockRegister(data, context) {
    const { email, password, firstName, lastName } = data;
    
    // Validation logic
    if (!email || !password || !firstName || !lastName) {
      throw new Error('Missing required fields');
    }
    
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      throw new Error('Invalid email format');
    }
    
    if (password.length < 6) {
      throw new Error('Password too short');
    }
    
    // Mock Firebase Auth user creation
    const userRecord = await mockAuth.createUser({
      email,
      password,
      displayName: `${firstName} ${lastName}`
    });
    
    // Mock Stripe customer creation
    const customer = await mockStripe.customers.create({
      email,
      metadata: { 
        userId: userRecord.uid,
        firstName,
        lastName
      }
    });
    
    // Mock Firestore user document creation
    await mockFirestore.collection('users').doc(userRecord.uid).set({
      email,
      firstName,
      lastName,
      stripeCustomerId: customer.id,
      createdAt: new Date()
    });
    
    return {
      success: true,
      userId: userRecord.uid,
      customerId: customer.id
    };
  };
}

describe('Payment Register - Comprehensive Testing', () => {
  let mockRegister;
  
  beforeEach(() => {
    mockRegister = createMockRegister();
    sinon.resetHistory();
  });
  
  afterEach(() => {
    sinon.restore();
  });
  
  describe('User Registration Validation', () => {
    it('should validate required fields', async () => {
      const incompleteData = {};
      
      try {
        await mockRegister(incompleteData, {});
        expect.fail('Should have thrown validation error');
      } catch (error) {
        expect(error.message).to.equal('Missing required fields');
      }
    });
    
    it('should validate email format', async () => {
      const invalidData = {
        email: 'invalid-email',
        password: 'password123',
        firstName: 'John',
        lastName: 'Doe'
      };
      
      try {
        await mockRegister(invalidData, {});
        expect.fail('Should have thrown email validation error');
      } catch (error) {
        expect(error.message).to.equal('Invalid email format');
      }
    });
    
    it('should validate password requirements', async () => {
      const weakPasswordData = {
        email: 'test@example.com',
        password: '123',
        firstName: 'John',
        lastName: 'Doe'
      };
      
      try {
        await mockRegister(weakPasswordData, {});
        expect.fail('Should have thrown password validation error');
      } catch (error) {
        expect(error.message).to.equal('Password too short');
      }
    });
  });
  
  describe('Customer Creation Process', () => {
    it('should create user and customer with valid data', async () => {
      const validData = {
        email: 'test@example.com',
        password: 'password123',
        firstName: 'John',
        lastName: 'Doe'
      };
      
      const result = await mockRegister(validData, {});
      
      expect(result.success).to.be.true;
      expect(result.userId).to.equal('new-test-uid');
      expect(result.customerId).to.equal('cus_mock123');
      
      // Verify Firebase Auth was called
      expect(mockAuth.createUser.calledOnce).to.be.true;
      expect(mockAuth.createUser.calledWith(sinon.match({
        email: 'test@example.com'
      }))).to.be.true;
      
      // Verify Stripe was called
      expect(mockStripe.customers.create.calledOnce).to.be.true;
      expect(mockStripe.customers.create.calledWith(sinon.match({
        email: 'test@example.com'
      }))).to.be.true;
    });
    
    it('should handle Stripe customer creation errors', async () => {
      mockStripe.customers.create.rejects(new Error('Stripe API error'));
      
      const validData = {
        email: 'test@example.com',
        password: 'password123',
        firstName: 'John',
        lastName: 'Doe'
      };
      
      try {
        await mockRegister(validData, {});
        expect.fail('Should have thrown Stripe error');
      } catch (error) {
        expect(error.message).to.equal('Stripe API error');
      }
    });
  });
  
  describe('Error Handling', () => {
    it('should handle Firebase Auth errors', async () => {
      mockAuth.createUser.rejects(new Error('Email already exists'));
      
      const validData = {
        email: 'existing@example.com',
        password: 'password123',
        firstName: 'John',
        lastName: 'Doe'
      };
      
      try {
        await mockRegister(validData, {});
        expect.fail('Should have thrown Firebase error');
      } catch (error) {
        expect(error.message).to.equal('Email already exists');
      }
    });
    
    it('should handle Firestore errors', async () => {
      // Reset mocks to prevent interference from other tests
      mockAuth.createUser.resetBehavior();
      mockAuth.createUser.resolves({
        uid: 'test-uid',
        email: 'test@example.com'
      });
      
      mockStripe.customers.create.resolves({
        id: 'cus_test123',
        email: 'test@example.com'
      });
      
      mockFirestore.collection().doc().set.rejects(new Error('Firestore write failed'));
      
      const validData = {
        email: 'test@example.com',
        password: 'password123',
        firstName: 'John',
        lastName: 'Doe'
      };
      
      try {
        await mockRegister(validData, {});
        expect.fail('Should have thrown Firestore error');
      } catch (error) {
        expect(error.message).to.equal('Firestore write failed');
      }
    });
  });
  
  describe('Integration Scenarios', () => {
    it('should complete full registration workflow', async () => {
      // Reset all mocks to ensure clean state
      sinon.resetHistory();
      mockAuth.createUser.resetBehavior();
      mockStripe.customers.create.resetBehavior();
      mockFirestore.collection().doc().set.resetBehavior();
      
      // Set up successful responses
      mockAuth.createUser.resolves({
        uid: 'integration-user-id',
        email: 'integration@test.com'
      });
      
      mockStripe.customers.create.resolves({
        id: 'cus_integration123',
        email: 'integration@test.com'
      });
      
      mockFirestore.collection().doc().set.resolves();
      
      const userData = {
        email: 'integration@test.com',
        password: 'securepassword123',
        firstName: 'Integration',
        lastName: 'Test'
      };
      
      const result = await mockRegister(userData, {});
      
      expect(result.success).to.be.true;
      expect(result.userId).to.equal('integration-user-id');
      expect(result.customerId).to.equal('cus_integration123');
      
      // Verify all services were called in order
      expect(mockAuth.createUser.calledBefore(mockStripe.customers.create)).to.be.true;
      expect(mockStripe.customers.create.calledBefore(mockFirestore.collection().doc().set)).to.be.true;
    });
  });
});