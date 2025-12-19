/**
 * Schema Validation Utility
 *
 * This utility provides runtime schema validation for Firebase Function
 * endpoints. It ensures that requests and responses conform to their
 * documented schemas.
 */

export interface SchemaField {
  type: "string" | "number" | "boolean" | "object" | "array";
  required?: boolean;
  properties?: { [key: string]: SchemaField };
  items?: SchemaField;
  minLength?: number;
  maxLength?: number;
  min?: number;
  max?: number;
  pattern?: RegExp;
  enum?: (string | number)[];
}

export interface EndpointSchema {
  request: { [key: string]: SchemaField };
  response: { [key: string]: SchemaField };
}

export class ValidationError extends Error {
  constructor(message: string, public field: string) {
    super(message);
    this.name = "ValidationError";
  }
}

export class SchemaValidator {
  /**
   * Validates data against a schema
   */
  static validateObject(
    data: unknown,
    schema: {[key: string]: SchemaField},
    context: string,
  ): void {
    // Type guard to ensure data is an object
    if (!data || typeof data !== "object" || Array.isArray(data)) {
      throw new ValidationError(
        `Expected object in ${context} but got ${typeof data}`,
        context,
      );
    }

    const dataObj = data as Record<string, unknown>;

    // Check for required fields
    for (const [fieldName, fieldSchema] of Object.entries(schema)) {
      if (fieldSchema.required !== false && !(fieldName in dataObj)) {
        throw new ValidationError(
          `Required field '${fieldName}' is missing in ${context}`,
          fieldName,
        );
      }
    }

    // Validate each field in the data
    for (const [fieldName, value] of Object.entries(dataObj)) {
      const fieldSchema = schema[fieldName];
      if (!fieldSchema) {
        throw new ValidationError(
          `Unexpected field '${fieldName}' in ${context}`,
          fieldName,
        );
      }

      this.validateField(value, fieldSchema, `${context}.${fieldName}`);
    }
  }

  /**
   * Validates a single field against its schema
   */
  static validateField(
    value: unknown,
    schema: SchemaField,
    path: string,
  ): void {
    // Handle null/undefined
    if (value === null || value === undefined) {
      if (schema.required !== false) {
        throw new ValidationError(
          `Field '${path}' is required but got ${value}`,
          path,
        );
      }
      return;
    }

    // Type validation
    const actualType = Array.isArray(value) ? "array" : typeof value;
    if (actualType !== schema.type) {
      throw new ValidationError(
        `Field '${path}' expected type '${schema.type}' ` +
        `but got '${actualType}'`,
        path,
      );
    }

    // Type-specific validation
    switch (schema.type) {
    case "string":
      this.validateString(value as string, schema, path);
      break;
    case "number":
      this.validateNumber(value as number, schema, path);
      break;
    case "object":
      if (schema.properties) {
        this.validateObject(value, schema.properties, path);
      }
      break;
      break;
    case "array":
      if (schema.items) {
        (value as unknown[]).forEach((item: unknown, index: number) => {
          this.validateField(item, schema.items!, `${path}[${index}]`);
        });
      }
      break;
    }
  }

  private static validateString(
    value: string,
    schema: SchemaField,
    path: string,
  ): void {
    if (schema.minLength !== undefined && value.length < schema.minLength) {
      throw new ValidationError(
        `Field '${path}' must be at least ${schema.minLength} characters`,
        path,
      );
    }

    if (schema.maxLength !== undefined && value.length > schema.maxLength) {
      throw new ValidationError(
        `Field '${path}' must be at most ${schema.maxLength} characters`,
        path,
      );
    }

    if (schema.pattern && !schema.pattern.test(value)) {
      throw new ValidationError(
        `Field '${path}' does not match required pattern`,
        path,
      );
    }

    if (schema.enum && !schema.enum.includes(value)) {
      throw new ValidationError(
        `Field '${path}' must be one of: ${schema.enum.join(", ")}`,
        path,
      );
    }
  }

  private static validateNumber(
    value: number,
    schema: SchemaField,
    path: string,
  ): void {
    if (schema.min !== undefined && value < schema.min) {
      throw new ValidationError(
        `Field '${path}' must be at least ${schema.min}`,
        path,
      );
    }

    if (schema.max !== undefined && value > schema.max) {
      throw new ValidationError(
        `Field '${path}' must be at most ${schema.max}`,
        path,
      );
    }

    if (schema.enum && !schema.enum.includes(value)) {
      throw new ValidationError(
        `Field '${path}' must be one of: ${schema.enum.join(", ")}`,
        path,
      );
    }
  }

  /**
   * Creates a validation middleware for Firebase Functions
   */
  static createValidator(schema: EndpointSchema) {
    return {
      validateRequest: (data: unknown) => {
        try {
          this.validateObject(data, schema.request, "request");
        } catch (error) {
          if (error instanceof ValidationError) {
            throw new Error(`Request validation failed: ${error.message}`);
          }
          throw error;
        }
      },

      validateResponse: (data: unknown) => {
        try {
          this.validateObject(data, schema.response, "response");
        } catch (error) {
          if (error instanceof ValidationError) {
            throw new Error(`Response validation failed: ${error.message}`);
          }
          throw error;
        }
      },
    };
  }
}

/**
 * Utility function to create schema field definitions
 */
export const field = {
  string: (options: Partial<SchemaField> = {}): SchemaField => ({
    type: "string",
    required: true,
    ...options,
  }),

  number: (options: Partial<SchemaField> = {}): SchemaField => ({
    type: "number",
    required: true,
    ...options,
  }),

  boolean: (options: Partial<SchemaField> = {}): SchemaField => ({
    type: "boolean",
    required: true,
    ...options,
  }),

  object: (
    properties: {[key: string]: SchemaField},
    options: Partial<SchemaField> = {},
  ): SchemaField => ({
    type: "object",
    required: true,
    properties,
    ...options,
  }),

  array: (
    items: SchemaField,
    options: Partial<SchemaField> = {},
  ): SchemaField => ({
    type: "array",
    required: true,
    items,
    ...options,
  }),

  optional: (schema: SchemaField): SchemaField => ({
    ...schema,
    required: false,
  }),
};
