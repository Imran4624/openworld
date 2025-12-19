module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
    "/generated/**/*", // Ignore generated files.
    "/test/**/*", // Ignore test files.
  ],
  plugins: [
    "@typescript-eslint",
    "import",
  ],
  rules: {
    "quotes": ["error", "double"],
    "import/no-unresolved": 0,
    "indent": ["error", 2],
    "linebreak-style": 0, // Disable linebreak style check
    "require-jsdoc": 0, // Disable JSDoc requirement
    "valid-jsdoc": 0,
    "max-len": "off", // Temporarily disable max line length
    "camelcase": "off", // Temporarily disable camelcase
    "@typescript-eslint/no-explicit-any": "off", // Temporarily disable any warnings
    "@typescript-eslint/no-non-null-assertion": "off", // Temporarily disable non-null assertion warnings
  },
};
