# Openworld App

## Quick Start

### Prerequisites
```bash
fvm install 3.29.3
fvm use 3.29.3
```

### Run Locally
```bash
fvm flutter run
# For web with CORS disabled
fvm flutter run -d chrome --web-browser-flag="--disable-web-security"
```

### Build Runner (for code generation)
```bash
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

### Generate App Icons
```bash
fvm flutter pub run flutter_launcher_icons
```


## Development

### Local Development
```bash
fvm flutter run -d chrome --web-browser-flag="--disable-web-security"
```



## Deployment

### Pre-deployment Checklist
- Increment app version in pubsec.yml
- Generate app icons: `fvm flutter pub run flutter_launcher_icons`
- Verify app name and icon

### Build for Release
 fvm flutter pub upgrade
 
#### Android
```bash
fvm flutter build appbundle --release
```

#### iOS
```bash
fvm flutter build ipa --release
```

#### Web
```bash
export FLUTTER_WEB_RENDERER=canvaskit
fvm flutter build web --release
```

## Firebase Configuration

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



#