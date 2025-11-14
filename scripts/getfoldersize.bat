@echo off
REM --- Self-elevate to Administrator ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

REM --- Run PowerShell command ---
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Get-ChildItem '\\frst-irss2\ByUser' -Directory | ForEach-Object {^
    $line = (robocopy $_.FullName NULL /L /S /NFL /NDL /NJH /BYTES /NC /NS /NP | Select-String 'Bytes :').ToString();^
    $bytes = [double](([regex]::Matches($line, '\d+(\.\d+)?') | Select-Object -First 1).Value);^
    $sizeGB = [math]::Round($bytes / 1GB, 2);^
    [PSCustomObject]@{ Folder = $_.Name; SizeGB = $sizeGB }^
} | Format-Table -AutoSize"

pause
