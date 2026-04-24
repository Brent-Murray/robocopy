@echo off
setlocal enabledelayedexpansion

set "LOG=%USERPROFILE%\Desktop\drive_check_report_%DATE:/=-%_%TIME::=-%.txt"
set "LOG=%LOG: =_%"

echo Drive Check Report > "%LOG%"
echo Generated: %DATE% %TIME% >> "%LOG%"
echo. >> "%LOG%"

echo Checking all local drives...
echo Log file: "%LOG%"
echo.

for /f "skip=1 tokens=1" %%D in ('wmic logicaldisk where "drivetype=3" get deviceid') do (
    if not "%%D"=="" (
        echo ======================================== >> "%LOG%"
        echo Checking drive %%D >> "%LOG%"
        echo ======================================== >> "%LOG%"
        echo. >> "%LOG%"

        echo Checking %%D ...

        chkdsk %%D >> "%LOG%" 2>&1

        echo. >> "%LOG%"
    )
)

echo.
echo Finished.
echo Report saved to:
echo "%LOG%"

pause