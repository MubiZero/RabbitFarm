# 🚀 How to Run RabbitFarm Mobile App

## Prerequisites

1. **Flutter SDK** - Already installed ✅
2. **Backend API running** - Must be running on http://localhost:3000 ✅
3. **Android Emulator** or **Physical Android Device**

---

## Option 1: Android Emulator (Recommended)

### Step 1: Check available emulators
```bash
cd mobile
flutter emulators
```

### Step 2: Start an emulator
```bash
flutter emulators --launch <emulator_id>
```

Example:
```bash
flutter emulators --launch Pixel_5_API_33
```

### Step 3: Run the app
```bash
flutter run
```

Or specify the device:
```bash
flutter run -d <device_id>
```

---

## Option 2: Physical Android Device

### Step 1: Enable Developer Options on your device
1. Go to Settings → About Phone
2. Tap "Build Number" 7 times
3. Go back to Settings → Developer Options
4. Enable "USB Debugging"

### Step 2: Connect device via USB

### Step 3: Verify device is connected
```bash
flutter devices
```

You should see your device listed.

### Step 4: Update API base URL

⚠️ **IMPORTANT**: Physical devices can't use `10.0.2.2`

1. Find your PC's local IP address:
   - Windows: Run `ipconfig` and look for IPv4 Address
   - Example: `192.168.1.100`

2. Open `mobile/lib/core/api/api_endpoints.dart`

3. Update the base URL:
```dart
// Replace this:
static const String baseUrl = 'http://10.0.2.2:3000/api/v1';

// With your PC's IP:
static const String baseUrl = 'http://192.168.1.100:3000/api/v1';
```

### Step 5: Run the app
```bash
flutter run
```

---

## Option 3: Windows Desktop (if Visual Studio installed)

### Requirements
- Visual Studio 2022 with "Desktop development with C++"

### Run command
```bash
flutter run -d windows
```

---

## Testing the App

### Test Login
1. App will open on login screen
2. Test credentials are pre-filled:
   - Email: `admin@rabbitfarm.com`
   - Password: `admin123`
3. Click "Войти" (Login)
4. Should navigate to home screen with welcome message

### Test Registration
1. Click "Зарегистрироваться" (Register)
2. Fill in the form:
   - Full name
   - Email
   - Password
   - Confirm password
3. Click "Зарегистрироваться"
4. Should navigate to home screen

### Test Logout
1. On home screen, click profile menu (top right)
2. Click "Выйти" (Logout)
3. Should navigate back to login screen

---

## Troubleshooting

### Problem: "No devices found"
**Solution**: Make sure emulator is running or physical device is connected

```bash
flutter devices
```

### Problem: "Unable to connect to backend"
**For Emulator**:
- Use `http://10.0.2.2:3000/api/v1` in api_endpoints.dart
- Make sure backend is running on http://localhost:3000

**For Physical Device**:
- Use your PC's IP address (e.g., `http://192.168.1.100:3000/api/v1`)
- Make sure device and PC are on the same Wi-Fi network
- Check firewall isn't blocking port 3000

### Problem: Backend connection refused
**Solution**:
1. Verify backend is running:
```bash
cd backend
npm run dev
```

2. Test backend API directly:
```bash
curl http://localhost:3000/health
```

Should return:
```json
{"success":true,"message":"Server is running","data":{"uptime":...}}
```

### Problem: Build errors
**Solution**: Clean and rebuild
```bash
flutter clean
flutter pub get
flutter run
```

### Problem: "Waiting for another flutter command to release the startup lock"
**Solution**:
```bash
# Delete the lockfile
rm -f mobile/.dart_tool/flutter_build/
```

---

## Development Tips

### Hot Reload
- Press `r` in terminal for hot reload (faster, preserves state)
- Press `R` for hot restart (slower, resets state)
- Press `q` to quit

### View Logs
- All console.log output appears in terminal
- API requests/responses logged by LoggingInterceptor

### Debugging
```bash
# Run in debug mode (default)
flutter run

# Run in profile mode (performance testing)
flutter run --profile

# Run in release mode (production build)
flutter run --release
```

---

## API Configuration

### Current Settings
- **Base URL (Emulator)**: `http://10.0.2.2:3000/api/v1`
- **Base URL (Physical Device)**: Update to your PC's IP
- **Timeout**: 30 seconds

### Endpoints Configured
- ✅ POST /auth/login
- ✅ POST /auth/register
- ✅ POST /auth/logout
- ✅ GET /auth/me
- ✅ PUT /auth/profile
- ✅ POST /auth/refresh
- ✅ GET /rabbits
- ✅ POST /rabbits
- ✅ GET /rabbits/:id
- ✅ PUT /rabbits/:id
- ✅ DELETE /rabbits/:id
- ✅ GET /rabbits/statistics
- ✅ POST /rabbits/:id/weights
- ✅ GET /rabbits/:id/weights
- ✅ POST /rabbits/:id/photo

---

## Building for Production

### Android APK
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Google Play)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## Project Structure

```
mobile/
├── lib/
│   ├── core/              # Core infrastructure
│   │   ├── api/           # API client, endpoints, interceptors
│   │   ├── router/        # Navigation
│   │   └── theme/         # App theming
│   │
│   ├── features/          # Feature modules
│   │   ├── auth/          # Authentication
│   │   └── rabbits/       # Rabbits management
│   │
│   ├── shared/            # Shared widgets/models
│   └── main.dart          # App entry point
│
├── android/               # Android native code
├── ios/                   # iOS native code (not configured)
└── pubspec.yaml           # Dependencies
```

---

## Quick Start (Full Workflow)

```bash
# 1. Make sure backend is running
cd backend
npm run dev
# Backend should be on http://localhost:3000

# 2. In a new terminal, start Android emulator
cd mobile
flutter emulators --launch <emulator_id>

# 3. Wait for emulator to start, then run app
flutter run

# 4. Test login with:
#    Email: admin@rabbitfarm.com
#    Password: admin123

# 5. Enjoy! 🎉
```

---

## Support

If you encounter issues:
1. Check backend is running: `curl http://localhost:3000/health`
2. Check device is connected: `flutter devices`
3. Clean and rebuild: `flutter clean && flutter pub get && flutter run`
4. Check logs in terminal for error details

---

**Last Updated**: 2025-10-15
**Flutter Version**: 3.9.2+
**Minimum Android SDK**: 21 (Android 5.0)
**Target Android SDK**: 34 (Android 14)
