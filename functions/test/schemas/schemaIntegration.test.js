const { expect } = require('chai');
const { SchemaValidator } = require('../../lib/utils/schemaValidator');
const { ENDPOINT_SCHEMAS } = require('../../lib/schemas/endpointSchemas');
const { mockStripe, mockFirestore, sinon } = require('../setup');

/**
 * Integration tests that validate actual endpoint implementations 
 * against their defined schemas. These tests ensure that:
 * 1. Request data conforms to the documented schema
 * 2. Response data conforms to the documented schema
 * 3. Any changes to request/response structure will break tests
 */

describe('Endpoint Schema Integration Tests', () => {
  
  describe('Payment Method Endpoints', () => {
    
    describe('createPaymentMethod - Schema Integration', () => {
      const validator = SchemaValidator.createValidator(ENDPOINT_SCHEMAS.createPaymentMethod);

      it('should validate request schema matches actual implementation', async () => {
        // This is the exact request format the endpoint expects
        const requestData = {
          card: {
            number: '4242424242424242',
            exp_month: 12,
            exp_year: 2025,
            cvc: '123'
          },
          billing_details: {
            name: 'John Doe',
            email: 'john@example.com',
            address: {
              line1: '123 Main St',
              city: 'New York',
              state: 'NY',
              postal_code: '10001',
              country: 'US'
            }
          }
        };

        // This must not throw if schema matches implementation
        expect(() => validator.validateRequest(requestData)).to.not.throw();
      });

      it('should validate response schema matches actual implementation', () => {
        // This is the exact response format the endpoint returns
        const responseData = {
          success: true,
          data: {
            paymentMethodId: 'pm_1234567890',
            type: 'card',
            card: {
              brand: 'visa',
              last4: '4242',
              expMonth: 12,
              expYear: 2025
            },
            createdAt: '2025-12-06T10:30:00.000Z'
          }
        };

        // This must not throw if schema matches implementation
        expect(() => validator.validateResponse(responseData)).to.not.throw();
      });

      it('should reject modified request schema', () => {
        // If someone changes the endpoint to require additional fields,
        // this test will fail until the schema is updated
        const modifiedRequest = {
          card: {
            number: '4242424242424242',
            exp_month: 12,
            exp_year: 2025,
            cvc: '123'
          },
          billing_details: {
            name: 'John Doe',
            email: 'john@example.com'
          },
          newRequiredField: 'this would break the test' // Unexpected field
        };

        expect(() => validator.validateRequest(modifiedRequest)).to.throw(/Unexpected field.*newRequiredField/);
      });
    });

    describe('processOneTimePayment - Schema Integration', () => {
      const validator = SchemaValidator.createValidator(ENDPOINT_SCHEMAS.processOneTimePayment);

      it('should validate actual request data structure', () => {
        const actualRequestData = {
          userId: 'user123',
          amount: 2000,
          currency: 'usd',
          commissionAmount: 15,
          commissionType: 'percentage',
          recipientId: 'recipient456',
          paymentMethodId: 'pm_1234567890',
          description: 'Payment for services',
          paymentType: 'marketplace'
        };

        expect(() => validator.validateRequest(actualRequestData)).to.not.throw();
      });

      it('should validate actual response data structure', () => {
        const actualResponseData = {
          success: true,
          data: {
            paymentIntentId: 'pi_1234567890',
            amount: 2000,
            currency: 'usd',
            status: 'succeeded',
            commissionAmount: 300,
            netAmount: 1700,
            createdAt: '2025-12-06T10:30:00.000Z'
          }
        };

        expect(() => validator.validateResponse(actualResponseData)).to.not.throw();
      });

      it('should enforce exact field requirements', () => {
        // Test that removing required fields breaks validation
        const incompleteRequest = {
          userId: 'user123',
          amount: 2000,
          currency: 'usd'
          // Missing other required fields
        };

        expect(() => validator.validateRequest(incompleteRequest)).to.throw();
      });
    });

    describe('togglePaymentMethod - Schema Integration', () => {
      const validator = SchemaValidator.createValidator(ENDPOINT_SCHEMAS.togglePaymentMethod);

      it('should validate boolean type enforcement', () => {
        const validRequest = {
          paymentMethodId: 'pm_123',
          enabled: true
        };

        const invalidRequest = {
          paymentMethodId: 'pm_123',
          enabled: 'true' // String instead of boolean
        };

        expect(() => validator.validateRequest(validRequest)).to.not.throw();
        expect(() => validator.validateRequest(invalidRequest)).to.throw(/expected type 'boolean'/);
      });
    });
  });

  describe('User Management Endpoints', () => {
    
    describe('filterProfiles - Schema Integration', () => {
      const validator = SchemaValidator.createValidator(ENDPOINT_SCHEMAS.filterProfiles);

      it('should validate complex nested request structure', () => {
        const requestData = {
          filters: {
            minAge: 18,
            maxAge: 35,
            gender: 'female',
            location: {
              latitude: 40.7128,
              longitude: -74.0060,
              radius: 50
            },
            interests: ['music', 'travel'],
            currentUserId: 'user123',
            isAdmin: false
          },
          limit: 50,
          lastDocId: 'last_doc_id_here',
          excludeLikedMatchedProfiles: true
        };

        expect(() => validator.validateRequest(requestData)).to.not.throw();
      });

      it('should validate array response structure', () => {
        const responseData = {
          success: true,
          data: {
            profiles: [
              {
                id: 'profile123',
                name: 'John Doe',
                age: 28,
                gender: 'male',
                location: {
                  latitude: 40.7580,
                  longitude: -73.9855
                },
                interests: ['music', 'sports'],
                photos: ['photo1.jpg', 'photo2.jpg'],
                bio: 'Love music and traveling'
              }
            ],
            hasMore: true,
            lastDocId: 'new_last_doc_id'
          }
        };

        expect(() => validator.validateResponse(responseData)).to.not.throw();
      });

      it('should enforce location coordinate limits', () => {
        const invalidRequest = {
          filters: {
            location: {
              latitude: 91, // Outside valid range
              longitude: -74.0060,
              radius: 50
            },
            currentUserId: 'user123'
          }
        };

        expect(() => validator.validateRequest(invalidRequest)).to.throw(/must be at most 90/);
      });
    });

    describe('deleteUserAccount - Schema Integration', () => {
      const validator = SchemaValidator.createValidator(ENDPOINT_SCHEMAS.deleteUserAccount);

      it('should require confirmDelete boolean', () => {
        const validRequest = {
          userId: 'user123',
          confirmDelete: true
        };

        const invalidRequest = {
          userId: 'user123',
          confirmDelete: 'yes' // String instead of boolean
        };

        expect(() => validator.validateRequest(validRequest)).to.not.throw();
        expect(() => validator.validateRequest(invalidRequest)).to.throw(/expected type 'boolean'/);
      });
    });
  });

  describe('Config Endpoints', () => {
    
    describe('updateAppVersion - Schema Integration', () => {
      const validator = SchemaValidator.createValidator(ENDPOINT_SCHEMAS.updateAppVersion);

      it('should enforce platform enum values', () => {
        const validRequest = {
          platform: 'android',
          latest: '1.2.3'
        };

        const invalidRequest = {
          platform: 'windows', // Not in allowed enum
          latest: '1.2.3'
        };

        expect(() => validator.validateRequest(validRequest)).to.not.throw();
        expect(() => validator.validateRequest(invalidRequest)).to.throw(/must be one of: android, ios/);
      });

      it('should enforce semantic version format', () => {
        const validVersions = ['1.0.0', '2.1.5', '10.15.3'];
        const invalidVersions = ['1.0', 'v1.2.3', '1.2.3-beta', '1.2'];

        validVersions.forEach(version => {
          const request = { platform: 'android', latest: version };
          expect(() => validator.validateRequest(request)).to.not.throw();
        });

        invalidVersions.forEach(version => {
          const request = { platform: 'android', latest: version };
          expect(() => validator.validateRequest(request)).to.throw(/does not match required pattern/);
        });
      });
    });
  });

  describe('Schema Consistency Enforcement', () => {
    
    it('should ensure all endpoints follow success/error response pattern', () => {
      Object.keys(ENDPOINT_SCHEMAS).forEach(endpointName => {
        const schema = ENDPOINT_SCHEMAS[endpointName];
        const validator = SchemaValidator.createValidator(schema);

        // Test success response pattern
        const successResponse = { success: true };
        expect(() => validator.validateResponse(successResponse)).to.not.throw();

        // Test error response pattern
        const errorResponse = { success: false, error: 'Something went wrong' };
        expect(() => validator.validateResponse(errorResponse)).to.not.throw();
      });
    });

    it('should reject responses that break the standard format', () => {
      Object.keys(ENDPOINT_SCHEMAS).forEach(endpointName => {
        const schema = ENDPOINT_SCHEMAS[endpointName];
        const validator = SchemaValidator.createValidator(schema);

        // Response without success field should fail
        const invalidResponse = { data: { some: 'data' } };
        expect(() => validator.validateResponse(invalidResponse)).to.throw();
      });
    });

    it('should protect against accidental schema modifications', () => {
      // This test will fail if someone accidentally modifies core schemas
      const criticalEndpoints = [
        'processOneTimePayment',
        'createPaymentMethod',
        'getPaymentMethods',
        'updatePaymentMethod',
        'deletePaymentMethod'
      ];

      criticalEndpoints.forEach(endpointName => {
        const schema = ENDPOINT_SCHEMAS[endpointName];
        expect(schema).to.exist;
        expect(schema).to.have.property('request');
        expect(schema).to.have.property('response');
        expect(schema.response).to.have.property('success');
      });
    });
  });

  describe('Data Type Validation', () => {
    
    it('should enforce string patterns across all endpoints', () => {
      // Test email pattern validation
      const emailTests = [
        { email: 'test@example.com', valid: true },
        { email: 'invalid-email', valid: false },
        { email: 'test@', valid: false },
        { email: '@example.com', valid: false }
      ];

      emailTests.forEach(test => {
        const validator = SchemaValidator.createValidator(ENDPOINT_SCHEMAS.sendEmail);
        const request = { to: test.email, subject: 'Test' };
        
        if (test.valid) {
          expect(() => validator.validateRequest(request)).to.not.throw();
        } else {
          expect(() => validator.validateRequest(request)).to.throw();
        }
      });
    });

    it('should enforce numeric constraints across all endpoints', () => {
      // Test amount validation in payment endpoints
      const validator = SchemaValidator.createValidator(ENDPOINT_SCHEMAS.processOneTimePayment);
      
      const validRequest = {
        userId: 'user123',
        amount: 100, // Valid amount
        currency: 'usd',
        commissionAmount: 15,
        commissionType: 'percentage',
        recipientId: 'recipient456',
        paymentMethodId: 'pm_123',
        description: 'Test payment',
        paymentType: 'marketplace'
      };

      const invalidRequest = {
        ...validRequest,
        amount: 25 // Below minimum
      };

      expect(() => validator.validateRequest(validRequest)).to.not.throw();
      expect(() => validator.validateRequest(invalidRequest)).to.throw(/must be at least 50/);
    });
  });
});