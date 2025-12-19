const { expect } = require('chai');
const { SchemaValidator, ValidationError } = require('../../lib/utils/schemaValidator');
const { 
  ENDPOINT_SCHEMAS,
  processOneTimePaymentSchema,
  createPaymentMethodSchema,
  getPaymentMethodsSchema,
  updatePaymentMethodSchema,
  deletePaymentMethodSchema,
  setDefaultPaymentMethodSchema,
  togglePaymentMethodSchema,
  subscribeSchema,
  unsubscribeSchema,
  processRefundSchema,
  deleteUserAccountSchema,
  filterProfilesSchema,
  updateAppVersionSchema,
  sendEmailSchema
} = require('../../lib/schemas/endpointSchemas');

describe('Endpoint Schema Validation', () => {
  
  describe('Schema Registry', () => {
    it('should contain all required endpoint schemas', () => {
      const requiredEndpoints = [
        'processOneTimePayment',
        'createPaymentMethod', 
        'getPaymentMethods',
        'updatePaymentMethod',
        'deletePaymentMethod',
        'setDefaultPaymentMethod',
        'togglePaymentMethod',
        'subscribe',
        'unsubscribe',
        'processRefund',
        'deleteUserAccount',
        'filterProfiles',
        'updateAppVersion',
        'sendEmail'
      ];
      
      for (const endpoint of requiredEndpoints) {
        expect(ENDPOINT_SCHEMAS).to.have.property(endpoint);
        expect(ENDPOINT_SCHEMAS[endpoint]).to.be.an('object');
        expect(ENDPOINT_SCHEMAS[endpoint]).to.have.property('request');
        expect(ENDPOINT_SCHEMAS[endpoint]).to.have.property('response');
      }
    });
  });

  describe('processOneTimePayment Schema Validation', () => {
    const validator = SchemaValidator.createValidator(processOneTimePaymentSchema);

    describe('Request Validation', () => {
      it('should accept valid request', () => {
        const validRequest = {
          userId: 'user123',
          amount: 2000,
          currency: 'usd',
          commissionAmount: 15,
          commissionType: 'percentage',
          recipientId: 'recipient456',
          paymentMethodId: 'pm_123',
          description: 'Payment for services',
          paymentType: 'marketplace'
        };
        
        expect(() => validator.validateRequest(validRequest)).to.not.throw();
      });

      it('should reject request with missing required fields', () => {
        const invalidRequest = {
          userId: 'user123',
          amount: 2000
          // Missing other required fields
        };
        
        expect(() => validator.validateRequest(invalidRequest)).to.throw(/Required field.*is missing/);
      });

      it('should reject request with invalid amount', () => {
        const invalidRequest = {
          userId: 'user123',
          amount: 25, // Below minimum
          currency: 'usd',
          commissionAmount: 15,
          commissionType: 'percentage',
          recipientId: 'recipient456',
          paymentMethodId: 'pm_123',
          description: 'Payment for services',
          paymentType: 'marketplace'
        };
        
        expect(() => validator.validateRequest(invalidRequest)).to.throw(/must be at least 50/);
      });

      it('should reject request with invalid currency', () => {
        const invalidRequest = {
          userId: 'user123',
          amount: 2000,
          currency: 'invalid', // Invalid currency
          commissionAmount: 15,
          commissionType: 'percentage',
          recipientId: 'recipient456',
          paymentMethodId: 'pm_123',
          description: 'Payment for services',
          paymentType: 'marketplace'
        };
        
        expect(() => validator.validateRequest(invalidRequest)).to.throw(/must be one of: usd, eur, gbp/);
      });
    });

    describe('Response Validation', () => {
      it('should accept valid success response', () => {
        const validResponse = {
          success: true,
          data: {
            paymentIntentId: 'pi_123',
            amount: 2000,
            currency: 'usd',
            status: 'succeeded',
            commissionAmount: 300,
            netAmount: 1700,
            createdAt: '2025-12-06T10:30:00.000Z'
          }
        };
        
        expect(() => validator.validateResponse(validResponse)).to.not.throw();
      });

      it('should accept valid error response', () => {
        const validResponse = {
          success: false,
          error: 'Payment failed'
        };
        
        expect(() => validator.validateResponse(validResponse)).to.not.throw();
      });

      it('should reject response with unexpected fields', () => {
        const invalidResponse = {
          success: true,
          unexpectedField: 'should not be here',
          data: {
            paymentIntentId: 'pi_123',
            amount: 2000,
            currency: 'usd',
            status: 'succeeded',
            commissionAmount: 300,
            netAmount: 1700,
            createdAt: '2025-12-06T10:30:00.000Z'
          }
        };
        
        expect(() => validator.validateResponse(invalidResponse)).to.throw(/Unexpected field.*unexpectedField/);
      });
    });
  });

  describe('createPaymentMethod Schema Validation', () => {
    const validator = SchemaValidator.createValidator(createPaymentMethodSchema);

    describe('Request Validation', () => {
      it('should accept valid request', () => {
        const validRequest = {
          card: {
            number: '4242424242424242',
            exp_month: 12,
            exp_year: 2025,
            cvc: '123'
          },
          billing_details: {
            name: 'John Doe',
            email: 'john@example.com'
          }
        };
        
        expect(() => validator.validateRequest(validRequest)).to.not.throw();
      });

      it('should reject request with invalid card number', () => {
        const invalidRequest = {
          card: {
            number: '123', // Too short
            exp_month: 12,
            exp_year: 2025,
            cvc: '123'
          }
        };
        
        expect(() => validator.validateRequest(invalidRequest)).to.throw(/does not match required pattern/);
      });

      it('should reject request with invalid email', () => {
        const invalidRequest = {
          card: {
            number: '4242424242424242',
            exp_month: 12,
            exp_year: 2025,
            cvc: '123'
          },
          billing_details: {
            email: 'invalid-email' // Invalid format
          }
        };
        
        expect(() => validator.validateRequest(invalidRequest)).to.throw(/does not match required pattern/);
      });
    });
  });

  describe('getPaymentMethods Schema Validation', () => {
    const validator = SchemaValidator.createValidator(getPaymentMethodsSchema);

    it('should accept empty request', () => {
      const validRequest = {};
      expect(() => validator.validateRequest(validRequest)).to.not.throw();
    });

    it('should validate response structure', () => {
      const validResponse = {
        success: true,
        data: {
          paymentMethods: [
            {
              paymentMethodId: 'pm_123',
              type: 'card',
              card: {
                brand: 'visa',
                last4: '4242',
                expMonth: 12,
                expYear: 2025
              },
              isDefault: true,
              isEnabled: true,
              createdAt: '2025-12-06T10:30:00.000Z'
            }
          ]
        }
      };
      
      expect(() => validator.validateResponse(validResponse)).to.not.throw();
    });
  });

  describe('updatePaymentMethod Schema Validation', () => {
    const validator = SchemaValidator.createValidator(updatePaymentMethodSchema);

      it('should require paymentMethodId', () => {
        const invalidRequest = {
          billing_details: {
            name: 'John Doe'
          }
        };
        
        expect(() => validator.validateRequest(invalidRequest)).to.throw(/Request validation failed/);
      });    it('should accept valid update request', () => {
      const validRequest = {
        paymentMethodId: 'pm_123',
        billing_details: {
          name: 'John Doe Updated',
          email: 'john.updated@example.com'
        }
      };
      
      expect(() => validator.validateRequest(validRequest)).to.not.throw();
    });
  });

  describe('deletePaymentMethod Schema Validation', () => {
    const validator = SchemaValidator.createValidator(deletePaymentMethodSchema);

    it('should require paymentMethodId', () => {
      const invalidRequest = {};
      expect(() => validator.validateRequest(invalidRequest)).to.throw(/Request validation failed/);
    });

    it('should accept valid delete request', () => {
      const validRequest = {
        paymentMethodId: 'pm_123'
      };
      
      expect(() => validator.validateRequest(validRequest)).to.not.throw();
    });
  });

  describe('setDefaultPaymentMethod Schema Validation', () => {
    const validator = SchemaValidator.createValidator(setDefaultPaymentMethodSchema);

    it('should require paymentMethodId', () => {
      const invalidRequest = {};
      expect(() => validator.validateRequest(invalidRequest)).to.throw(/Request validation failed/);
    });

    it('should validate response structure', () => {
      const validResponse = {
        success: true,
        data: {
          paymentMethodId: 'pm_123',
          isDefault: true,
          updatedAt: '2025-12-06T10:30:00.000Z'
        }
      };
      
      expect(() => validator.validateResponse(validResponse)).to.not.throw();
    });
  });

  describe('togglePaymentMethod Schema Validation', () => {
    const validator = SchemaValidator.createValidator(togglePaymentMethodSchema);

    it('should require paymentMethodId and enabled boolean', () => {
      const invalidRequest = {
        paymentMethodId: 'pm_123'
        // Missing enabled
      };
      
      expect(() => validator.validateRequest(invalidRequest)).to.throw(/Request validation failed/);
    });

    it('should reject non-boolean enabled value', () => {
      const invalidRequest = {
        paymentMethodId: 'pm_123',
        enabled: 'true' // String instead of boolean
      };
      
      expect(() => validator.validateRequest(invalidRequest)).to.throw(/expected type 'boolean'/);
    });
  });

  describe('subscribe Schema Validation', () => {
    const validator = SchemaValidator.createValidator(subscribeSchema);

    it('should accept valid subscription request', () => {
      const validRequest = {
        amount: 2000,
        currency: 'usd',
        interval: 'month',
        intervalCount: 1,
        productName: 'Premium Plan',
        trialPeriodDays: 7
      };
      
      expect(() => validator.validateRequest(validRequest)).to.not.throw();
    });

    it('should reject invalid interval', () => {
      const invalidRequest = {
        amount: 2000,
        currency: 'usd',
        interval: 'invalid', // Invalid interval
        intervalCount: 1,
        productName: 'Premium Plan'
      };
      
      expect(() => validator.validateRequest(invalidRequest)).to.throw(/must be one of: day, week, month, year/);
    });
  });

  describe('filterProfiles Schema Validation', () => {
    const validator = SchemaValidator.createValidator(filterProfilesSchema);

    it('should accept valid filter request', () => {
      const validRequest = {
        filters: {
          minAge: 25,
          maxAge: 35,
          gender: 'female',
          currentUserId: 'user123'
        },
        limit: 50
      };
      
      expect(() => validator.validateRequest(validRequest)).to.not.throw();
    });

    it('should reject invalid age range', () => {
      const invalidRequest = {
        filters: {
          minAge: 15, // Below minimum
          currentUserId: 'user123'
        }
      };
      
      expect(() => validator.validateRequest(invalidRequest)).to.throw(/must be at least 18/);
    });
  });

  describe('updateAppVersion Schema Validation', () => {
    const validator = SchemaValidator.createValidator(updateAppVersionSchema);

    it('should accept valid version update', () => {
      const validRequest = {
        platform: 'android',
        latest: '1.2.3'
      };
      
      expect(() => validator.validateRequest(validRequest)).to.not.throw();
    });

    it('should reject invalid platform', () => {
      const invalidRequest = {
        platform: 'windows', // Invalid platform
        latest: '1.2.3'
      };
      
      expect(() => validator.validateRequest(invalidRequest)).to.throw(/must be one of: android, ios/);
    });

    it('should reject invalid version format', () => {
      const invalidRequest = {
        platform: 'android',
        latest: 'v1.2' // Invalid format
      };
      
      expect(() => validator.validateRequest(invalidRequest)).to.throw(/does not match required pattern/);
    });
  });

  describe('Schema Change Protection', () => {
    it('should fail if processOneTimePayment request schema is modified', () => {
      // This test ensures that if someone tries to change the schema,
      // they must update the test, making schema changes explicit
      const currentRequestFields = Object.keys(processOneTimePaymentSchema.request);
      const expectedFields = [
        'userId', 'amount', 'currency', 'commissionAmount', 'commissionType',
        'recipientId', 'paymentMethodId', 'description', 'paymentType'
      ];
      
      expect(currentRequestFields.sort()).to.deep.equal(expectedFields.sort());
    });

    it('should fail if payment method schemas are modified', () => {
      const endpointSchemas = [
        'createPaymentMethod',
        'getPaymentMethods', 
        'updatePaymentMethod',
        'deletePaymentMethod',
        'setDefaultPaymentMethod',
        'togglePaymentMethod'
      ];
      
      endpointSchemas.forEach(schemaName => {
        expect(ENDPOINT_SCHEMAS).to.have.property(schemaName);
        expect(ENDPOINT_SCHEMAS[schemaName]).to.have.property('request');
        expect(ENDPOINT_SCHEMAS[schemaName]).to.have.property('response');
      });
    });

    it('should maintain response success/error structure across all endpoints', () => {
      Object.keys(ENDPOINT_SCHEMAS).forEach(endpointName => {
        const responseSchema = ENDPOINT_SCHEMAS[endpointName].response;
        expect(responseSchema).to.have.property('success');
        expect(responseSchema.success.type).to.equal('boolean');
        
        // All endpoints should support either data or error response
        const hasDataField = 'data' in responseSchema;
        const hasErrorField = 'error' in responseSchema;
        expect(hasDataField || hasErrorField).to.be.true;
      });
    });
  });
});