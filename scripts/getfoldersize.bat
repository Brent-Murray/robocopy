@echo off
setlocal

:: --- Check for Administrator privileges ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/k \"\"%~f0\"\"' -Verb RunAs"
    goto :eof
)

cls
echo Running folder size scan as Administrator...
echo.

:: --- Run PowerShell command ---
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Get-ChildItem '\\frst-irss2\ByUser' -Directory ^| ForEach-Object { ^
    $line = (robocopy $_.FullName NULL /L /S /NFL /NDL /NJH /BYTES /NC /NS /NP ^| Select-String 'Bytes :' ^| Out-String); ^
    $bytes = [double](([regex]::Matches($line, '\d+(\.\d+)?') ^| Select-Object -First 1).Value); ^
    $sizeGB = [math]::Round($bytes / 1GB, 2); ^
    [PSCustomObject]@{ Folder = $_.Name; SizeGB = $sizeGB } ^
} ^| Format-Table -AutoSize"

echo.
pause
endlocal
