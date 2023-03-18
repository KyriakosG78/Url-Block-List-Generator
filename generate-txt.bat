@echo off
setlocal enabledelayedexpansion

set "sites_dir=sites"
set "output_file=sites.txt"

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
        set "site_with_www=www.!site_no_www!"
        echo !site_no_www!>>%output_file%
    )
)

echo Removing duplicates and sorting...
rem Sort the output file and remove duplicates using a temporary file

for /f "delims=" %%s in ('sort %output_file%') do (
    set "site=%%s"
    set "site_no_www=!site!"
    set "site_with_www=www.!site_no_www!"
    rem echo !site_no_www!>>temp.txt
    rem echo !site_with_www!>>temp.txt

    if "!site_no_www!" NEQ "!last_site_a!" (
        echo !site_no_www!>>temp.txt
        set "last_site_a=!site_no_www!"
    )
    if "!site_with_www!" NEQ "!last_site_b!" (
        echo !site_with_www!>>temp.txt
        set "last_site_b=!site_with_www!"
    )
)

move /y temp.txt %output_file% > nul
del temp.txt

echo Done!