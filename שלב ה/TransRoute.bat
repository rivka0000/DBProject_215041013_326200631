@echo off
title TransRoute - Transportation Management System
cd /d "%~dp0"

where python >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Python is not installed. Please install it from https://www.python.org
    pause
    exit /b 1
)

echo ============================================
echo   TransRoute - starting up...
echo ============================================

echo [1/3] Checking required packages...
pip install -q -r "app\requirements.txt"

echo [2/3] Opening browser at http://localhost:5000 ...
start /b cmd /c "timeout /t 3 >nul & start http://localhost:5000"

echo [3/3] Starting server. To stop: press Ctrl+C or close this window.
echo.
python "app\app.py"
pause
