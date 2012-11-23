@echo off
REM ~~~~~~~~~~~~~~~~~~~~~~~~*****
REM This batch file will build, sign and deploy your WebWorks application to your
REM PlayBook device.
REM
REM In the code below, substitute the following values with your own:
REM
REM The script assumes that the following executables are in the system path:
REM     1. 7z
REM     2. bbwp
REM     3. java
REM ~~~~~~~~~~~~~~~~~~~~~~~~*****

cls
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Starting...
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

REM command-line parameters: ============================================================
set buildId=%1

REM Change these variables to match your project: =======================================
set projectDir=C:\RIM_Training\StudentFiles\WebWorks\workspace\MyFirstProject_FINAL
set projectName=MyTravelLogWW
set gcskPassword=[password]
set p12Password=[password]
set devicePassword=[password]
set deviceIP=[IP address]
set assetExtensions=*.html *.js *.css *.xml *.png *.woff *.sql *.json
set sdkRoot=C:\Program Files (x86)\Research In Motion\BlackBerry WebWorks SDK for TabletOS 2.2.0.5

if (%1)==() goto END

echo.
echo Using buildID %buildId%...
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set originalDirectory=%CD%
cd "%projectDir%"

echo.
echo Clearing old builds...
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
del /Q "%projectDir%\build\*.*"

echo.
echo Creating Zip archive...
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
7z a -r "%projectDir%\build\%projectName%.zip" %assetExtensions%

echo.
echo Generating BAR file...
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bbwp "%projectDir%\build\%projectName%.zip" -d -gcsk %gcskPassword% -gp12 %p12Password% -buildId %buildId% -o "%projectDir%\build\"

echo.
echo Deploying to device...
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
java -jar "%sdkRoot%\bbwp\blackberry-tablet-sdk\lib\BarDeploy.jar" -installApp -password %devicePassword% -device %deviceIP% -package "%projectDir%\build\%projectName%.bar"

cd \

echo.
echo Completed build and deploy for build %buildId%.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cd %originalDirectory%

REM Exit if everything went well.
goto :eof

:END
echo ERROR: Please pass in the incremented buildId as a number. eg 0001
