@echo off
echo ========================================
echo  Flashcard Quiz App - Setup Script
echo ========================================
echo.

echo [1/4] Cleaning old files...
if exist .dart_tool rmdir /s /q .dart_tool
if exist build rmdir /s /q build
if exist .flutter-plugins del /q .flutter-plugins
if exist .flutter-plugins-dependencies del /q .flutter-plugins-dependencies
if exist pubspec.lock del /q pubspec.lock
echo     Done!

echo.
echo [2/4] Getting Flutter packages...
call flutter pub get
if errorlevel 1 (
    echo     ERROR: Failed to get packages!
    pause
    exit /b 1
)
echo     Done!

echo.
echo [3/4] Running code generation...
call flutter pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    echo     Warning: Code generation had issues, continuing...
)
echo     Done!

echo.
echo [4/4] Checking Flutter doctor...
call flutter doctor
echo     Done!

echo.
echo ========================================
echo  Setup Complete!
echo ========================================
echo.
echo Now you can run:
echo   - Windows: flutter run -d windows
echo   - Chrome:  flutter run -d chrome
echo   - Android: flutter run -d android
echo.
pause
