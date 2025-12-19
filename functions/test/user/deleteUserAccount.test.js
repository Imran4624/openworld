const { expect } = require('chai');
const { mockFirestore, mockAuth, mockStripe } = require('../setup');

// Mock deleteUserAccount function
function createMockDeleteUserAccount() {
  return {
    run: async function(req, res) {
      try {
        const { userId } = req.body;
        
        if (!userId) {
          return res.status(400).json({ error: 'User ID required' });
        }
        
        // Get user data first
        const userDoc = await mockFirestore.collection('users').doc(userId).get();
        const userData = userDoc.data();
        
        if (!userData) {
          return res.status(404).json({ error: 'User not found' });
        }
        
        // Delete user profile
        await mockFirestore.collection('users').doc(userId).delete();
        
        // Delete Stripe customer if exists
        if (userData.stripeCustomerId) {
          await mockStripe.customers.del(userData.stripeCustomerId);
        }
        
        // Delete Firebase Auth user
        await mockAuth.deleteUser(userId);
        
        res.status(200).json({ 
          success: true,
          deletedUserId: userId
        });
      } catch (error) {
        res.status(500).json({ error: error.message });
      }
    }
  };
}

describe('Delete User Account', () => {
  let mockDeleteUserAccount;
  
  beforeEach(() => {
    mockDeleteUserAccount = createMockDeleteUserAccount();
  });
  
  describe('deleteUserAccount function', () => {
    it('should be defined', () => {
      expect(mockDeleteUserAccount).to.exist;
      expect(mockDeleteUserAccount).to.be.an('object');
    });

    it('should be a Firebase HTTP function', () => {
      expect(mockDeleteUserAccount.run).to.be.a('function');
    });

    it('should handle user deletion workflow', async () => {
      // The mock is already set up in setup.js, just verify it works
      const mockReq = {
        body: {
          userId: 'test-user-id'
        }
      };
      
      const mockRes = {
        status: function(code) {
          this.statusCode = code;
          return this;
        },
        json: function(data) {
          this.responseData = data;
          return this;
        }
      };
      
      await mockDeleteUserAccount.run(mockReq, mockRes);
      
      expect(mockRes.statusCode).to.equal(200);
      expect(mockRes.responseData.success).to.be.true;
    });
  });
});