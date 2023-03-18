@echo off
setlocal enabledelayedexpansion

set "sites_dir=sites"
set "output_file=hosts"

echo Generating list of blocked sites...

rem Clear old output file
echo. > %output_file%
if exist %output_file% del %output_file%

for %%f in (%sites_dir%\*.txt) do (
    echo Processing file : %%~nf...
    for /f "delims=" %%s in (%%f) do (
        set "site=%%s"
        set "site_no_www=!site!"
        if /i "!site_no_www:~0,4!" == "www." (
            set "site_no_www=!site_no_www:~4!"
        )
        
        echo 127.0.0.1 !site_no_www!>>%output_file%
    )
)

echo Removing duplicates and sorting...
rem Sort the output file and remove duplicates using a temporary file

echo # This is a sample HOSTS file used by Microsoft TCP/IP for Windows.>> temp.txt
echo # >> temp.txt
echo # Hosts file created by generate-hosts.bat >> temp.txt
echo # Date generated:%DATE% - %TIME% >> temp.txt
echo # >> temp.txt
echo # 127.0.0.1 localhost >> temp.txt
echo # ::1 localhost >> temp.txt
echo # >> temp.txt
echo # Blocked Sites >> temp.txt
echo. >> temp.txt

for /f "delims=" %%s in ('sort %output_file%') do (
    set "site=%%s"
    set "site_no_www=!site!"
    if "!site_no_www!" NEQ "!last_site!" (
        echo !site_no_www! >> temp.txt
        set "last_site=!site_no_www!"
    )
)

move /y temp.txt %output_file% > nul
del temp.txt

echo Done!