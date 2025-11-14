@echo off
setlocal enabledelayedexpansion

REM === Set the source directory (current directory by default) ===
set "SRC_DIR=%cd%"

REM === Loop through all subfolders ===
for /d %%F in ("%SRC_DIR%\*") do (
    echo Zipping folder: %%~nxF
    powershell -command "Compress-Archive -Path '%%F\*' -DestinationPath '%SRC_DIR%\%%~nxF.zip' -Force"
    
    REM === Check if the zip file was created successfully ===
    if exist "%SRC_DIR%\%%~nxF.zip" (
        echo Deleting folder: %%~nxF
        rmdir /s /q "%%F"
    ) else (
        echo Failed to zip folder: %%~nxF
    )
)

echo.
echo All folders processed successfully.
pause
