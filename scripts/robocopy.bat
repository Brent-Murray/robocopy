@echo off
setlocal

:: --- Self-elevate if not running as admin ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: --- Variables ---
set "LOGDIR=%~dp0logs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"
for /f "tokens=1-6 delims=/:. " %%a in ("%date% %time%") do set "DT=%%c-%%a-%%b_%%d%%e%%f"
set "LOG=%LOGDIR%\robocopy_%DT%.log"

echo Starting backup: %date% %time% >> "%LOG%"

:: --- Robocopy commands (your originals) ---
robocopy "D:/" "E:/" /XA:SH /E /MT /ZB >> "%LOG%" 2>&1
echo Returned RC=%ERRORLEVEL% after D: -> E: >> "%LOG%"

robocopy "F:/" "E:/" /XA:SH /E /MT /ZB >> "%LOG%" 2>&1
echo Returned RC=%ERRORLEVEL% after F: -> E: >> "%LOG%"

echo Finished: %date% %time% >> "%LOG%"
type "%LOG%"

endlocal
pause
