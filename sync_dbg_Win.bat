set isMounted="false"
for /f %%i in ('subst ^| grep -i z:') do set isMounted="true"
if %isMounted%=="false" subst Z: E:\views\cp2_view_DDADeltaDbg

cd /d Z:\BuildScripts
echo Waiting for \\was-cc2-tech\cm_bld1\%BuildNum%\BuildProgress\binaries.DEBUG.64.txt
WaitAFile.exe \\was-cc2-tech\cm_bld1\%BuildNum%\BuildProgress\binaries.DEBUG.64.txt
echo Found \\was-cc2-tech\cm_bld1\%BuildNum%\BuildProgress\binaries.DEBUG.64.txt
cleartool update Z:\BuildScripts\conspecs
cleartool setcs -over Z:\BuildScripts\conspecs\%BuildNum%_cs.txt
xcopy /I /Y /E /V /F \\was-cc2-tech\cm_bld1\%BuildNum%\DEBUG\* Z:\
cd /d Z:\3rdParty
CALL Register.Bat
cd /d Z:\BuildScripts
perl SetInstallRegistry.pl
perl SetRegistry.pl

@echo off

set from=jingwang@microstrategy.com
set to=jingwang@microstrategy.com

if [%2] == [] goto SENDMAIL

:SENDMAILCC
set cc=%2@microstrategy.com
C:\blat321\full\blat -q -server 10.15.79.125 -to %to% -f %from% -cc %cc% -subject "Delta view sync completed on %COMPUTERNAME%" -body "%COMPUTERNAME%  is synced to build %BuildNum%||This is an automated email."
goto EOF

:SENDMAIL
::C:\blat321\full\blat -q -server 10.15.79.125 -to %to% -f %from% -subject "Delta view sync completed on %COMPUTERNAME%" -body "%COMPUTERNAME%  is synced to build %BuildNum%||This is an automated email."


:EOF