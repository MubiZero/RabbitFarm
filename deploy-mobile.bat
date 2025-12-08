@echo off
REM Production Mobile App Build Script for RabbitFarm (Windows)
REM This script builds the Android APK with production API URL

echo ==============================================
echo 📱 RabbitFarm Mobile - Production Build
echo ==============================================
echo.

REM Configuration
set PRODUCTION_API_URL=http://108.181.167.236:4567/api/v1

echo Configuration:
echo   API URL: %PRODUCTION_API_URL%
echo.

echo 📋 Pre-build Checklist:
echo   - Flutter SDK installed
echo   - Android SDK configured
echo   - Java JDK installed
echo   - Backend is running on production
echo.

set /p CONTINUE="Continue with build? (Y/N): "
if /i not "%CONTINUE%"=="Y" (
    echo Build cancelled.
    exit /b
)

echo.
echo Step 1/5: Changing to mobile directory...
cd mobile
if errorlevel 1 (
    echo ❌ Mobile directory not found!
    exit /b 1
)
echo ✅ Directory changed

echo.
echo Step 2/5: Cleaning previous builds...
call flutter clean
if errorlevel 1 (
    echo ⚠️  Clean failed, continuing anyway...
)
echo ✅ Clean completed

echo.
echo Step 3/5: Getting dependencies...
call flutter pub get
if errorlevel 1 (
    echo ❌ Failed to get dependencies
    cd ..
    exit /b 1
)
echo ✅ Dependencies updated

echo.
echo Step 4/5: Building production APK...
echo This may take 5-10 minutes...
echo.
call flutter build apk --release --dart-define=API_URL=%PRODUCTION_API_URL%
if errorlevel 1 (
    echo ❌ Build failed!
    cd ..
    exit /b 1
)
echo ✅ Build completed!

echo.
echo Step 5/5: Locating APK file...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ APK found!
    echo.
    echo File location: build\app\outputs\flutter-apk\app-release.apk
    
    REM Show file size
    for %%A in ("build\app\outputs\flutter-apk\app-release.apk") do (
        set size=%%~zA
        set /a sizeMB=%%~zA/1048576
    )
    echo File size: !sizeMB! MB
    
    REM Copy to easier location
    echo.
    echo Copying APK to project root for easy access...
    copy "build\app\outputs\flutter-apk\app-release.apk" "..\RabbitFarm-Production.apk"
    if errorlevel 1 (
        echo ⚠️  Could not copy to root
    ) else (
        echo ✅ Copied to: RabbitFarm-Production.apk
    )
) else (
    echo ❌ APK file not found!
    cd ..
    exit /b 1
)

cd ..

echo.
echo ==============================================
echo 🎉 Build Complete!
echo ==============================================
echo.
echo APK Locations:
echo   1. mobile\build\app\outputs\flutter-apk\app-release.apk
echo   2. RabbitFarm-Production.apk (copy in root)
echo.
echo Next steps:
echo   1. Transfer APK to your Android device
echo   2. Install the app
echo   3. Test registration and login
echo   4. Verify all features work with production API
echo.
echo Installation methods:
echo   - USB: Copy APK to phone and install
echo   - Email: Send APK to yourself
echo   - Cloud: Upload to Google Drive/Dropbox
echo   - ADB: adb install RabbitFarm-Production.apk
echo.
echo ⚠️  Note: You may need to enable "Install from Unknown Sources"
echo     in Android settings to install the APK.
echo.
pause
