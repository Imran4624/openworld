# Firebase Functions


### Authentication & Project Setup
```bash
# Switch Firebase accounts if needed
firebase logout
firebase login

# Add project
firebase use --add
```

### Check Active Project
```bash
# View active project
firebase use

# Change active project by alias
firebase use staging
```

### Deploy Firebase Functions
```bash
cd functions
npm install
npm install eslint --save-dev
firebase deploy --only functions
cd ..
```

## Get a list of deployed endpoint urls
```bash
gcloud functions list --format="value(name)" | while read func; do
  gcloud functions describe "$func" --format="value(serviceConfig.uri)" 2>/dev/null
done | grep -v "^$"
```

## Run tests
```bash
npm test
```


## Adding a New Cloud Function

To add a new cloud function to the project:

1. **Create the endpoint**: Add your function implementation in `src/endpoints/[category]/[functionName].ts`
   - Follow the existing pattern with proper error handling
   - Use the appropriate Firebase Functions v2 triggers (onCall, onRequest, etc.)

2. **Add tests**: Create corresponding test files in `test/endpoints/[category]/[functionName].test.js`
   - Follow existing test patterns
   - Include unit tests for success and error cases

3. **Export function**: Add the function export to `src/index.ts`
   - Import your function at the top
   - Add it to the appropriate export section with the dynamic naming pattern
   - The function will automatically get the app type suffix (e.g., `_events121`)
