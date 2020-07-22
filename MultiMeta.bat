:: Keep it silent
@echo off
:: Set windows title
Title MultiMeta
:: Tidy
cls


:: Main program routine
:: Calls subroutines and gets back with goto :EOF or exit /b
call :SETUP
call :CLEANUP
call :DATETIME
call :HOME
setlocal enabledelayedexpansion
call :WHITELIST
call :BROWSEFORFOLDER
IF [%not%] EQU [y] exit /b
setlocal enabledelayedexpansion
call :MEDIAANALYSE
call :CONVERT2HTML
goto :EOF

:: Main program windows - this is what the user sees
:HOME
:: Colored logo here
:: Pipe character needs to get escaped with ^
echo:
echo [31m                   __  __       _ _   _ __  __      _        
echo [31m                  ^|  \/  ^|     ^| ^| ^| (_)  \/  ^|    ^| ^|       
echo [31m                  ^| \  / ^|_   _^| ^| ^|_ _^| \  / ^| ___^| ^|_ __ _ 
echo [31m                  ^| ^|\/^| ^| ^| ^| ^| ^| __^| ^| ^|\/^| ^|/ _ \ __/ _` ^|
echo [31m                  ^| ^|  ^| ^| ^|_^| ^| ^| ^|_^| ^| ^|  ^| ^|  __/ ^|^| (_^| ^|
echo [31m                  ^|_^|  ^|_^|\__,_^|_^|\__^|_^|_^|  ^|_^|\___^|\__\__,_^|
echo [0m                                                                      
echo:                       Tool for mass metadata analysis
echo:	        	  MediaInfo Version 20.03
echo:
echo     How To:
echo:
echo     1. Choose directory
echo     2. Confirm
echo     3. Once finished, report will open automatically
echo:
goto :EOF

:SETUP
:: Set windows size
mode con lines=22 cols=78
:: Keep it variable for future changes
set Installdir=C:\MultiMeta\Tool
set user=%username%
set Dektop=%USERPROFILE%\Desktop
set Mediainfo=C:\MultiMeta\Tool\MediaInfo.exe
goto :EOF

:CLEANUP
:: Cleanup last session
del %temp%\whitelist.txt 2>nul
del %temp%\MediaInfoCLI.txt 2>nul
del %temp%\MultiMeta.csv 2>nul
del %temp%\whitelist.tmp 2>nul
del %temp%\MultiMeta.tmp 2>nul
goto :EOF

:DATETIME
:: Get date and time for usage in HTML and PDF report
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=Date: %ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2%, Time: %ldt:~8,2%:%ldt:~10,2%
goto :EOF

:BROWSEFORFOLDER
:: Browse for folder dialog with powershell
:: Without 0 in PsCommand it doesn't work. Don't ask me why...
:: Next is the description
:: 0x0200 disables the "new directory" Button 
:: 17 is the starting path. In this case "This Computer"
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'MultiMeta',0x0200,17).self.path""
for /f "usebackq delims=" %%H in (`powershell %psCommand%`) do set "folder=%%H"
set ort=!folder!
IF [!folder!] EQU [] set not=y
setlocal enabledelayedexpansion
echo     Chosen directory:
echo     [31m%ort%
echo	 [0m
endlocal
goto :EOF


:WHITELIST
:: Get all allowed extensions from MultiMeta.conf and type them into a temp file for use with MediaInfo
:: Adds * for usage like *.mp4, *.mxf, ...
set B=%Installdir%\MultiMeta.conf
set A=*
for /F "delims=, eol=#" %%b in (%Installdir%\MultiMeta.conf) do (
	<nul echo %A%%%b >>%temp%\whitelist.tmp
	)
for /F %%i in ('type %temp%\whitelist.tmp') do (
	@<nul set /p"=%%i ">>%temp%\MultiMeta.tmp
	)
del %temp%\whitelist.tmp

FOR /F "delims=" %%o in (%temp%\MultiMeta.tmp) do (
	set whitelist=!whitelist! %%o
	)
del %temp%\MultiMeta.tmp
goto :EOF
 


:MEDIAANALYSE
:: Change Title
Title MultiMeta - Searching...
:: Prepare report with first line for later reporting
:: If delimiter gets changeg. You have to change it in :CONVERT2HTML aswell
echo File^|Size^|Duration^|Resolution^|FPS^|Scan-Type^|Format>>%temp%\MediaInfoCLI.txt
:: Prepate Filecount for use in report and window title 
set /a countmax =0
For /R "%ort%" %%G IN (%whitelist%) do (
	set /a countmax +=1
echo %%G >>%temp%\whitelist.txt
)

set /a countcur =0
:: MediaInfo analysis with Mi-Meta.conf and whitelist
:: Set window title according to current progress
for /f "tokens=*" %%D in ('type %temp%\whitelist.txt') do (
	%Mediainfo% --Inform=file://C:\MultiMeta\Tool\MI-Meta.conf "%%D">>%temp%\MediaInfoCLI.txt
	set /a countcur +=1
	set /a prozent=100*!countcur!/!countmax!
	SET ProgressPercent=!prozent!
	SET /A NumBars=!ProgressPercent!/2
	SET /A NumSpaces=50-!NumBars!
	SET Meter=
	FOR /L %%C IN (!NumBars!,-1,1) DO SET Meter=!Meter!I
	FOR /L %%C IN (!NumSpaces!,-1,1) DO SET Meter=!Meter! 
	TITLE MultiMeta - Analysing Media Files [!Meter!]  !ProgressPercent!%%
)
	
for /f "usebackq tokens=* delims=" %%a in ("%temp%\MediaInfoCLI.txt") do (echo(%%a)>>~.txt
:: CSV file in temp directory
move /y  ~.txt "%temp%\MultiMeta.csv">nul
goto :EOF

:CONVERT2HTML
:: Update title
Title MultiMeta - Creating Report
:: set delimiter for csv conversion. If changed here has to be changed in :MEDIAANALYSE aswell
set delims="|"
set "CSV_File=%temp%\MultiMeta.csv"
:: Name HTML file
for /f "usebackq delims=" %%a in (`echo "%CSV_File%"`) do ( set "HTML_File=%temp%\%%~na.html")
:: Overwrite previous HTML file
if exist "%HTML_File%" del /f /q "%HTML_File%"
Timeout /T 2 /nobreak>nul
Call :CreateHTMLtable "%CSV_File%" "%HTML_File%"
:: Delete temp files to prevent wrong results at next execution
del %temp%\whitelist.txt
del %temp%\MediaInfoCLI.txt
:: Copy HTML file to %installdir%\work as backup. Gets overwritten everytime!!!
copy /y "%HTML_File%" "%Installdir%\Work\" 1>nul
:: Open HTML report
start "" "%HTML_File%"
exit /b

:CreateHTMLTable <inputfile> <outputfile>
setlocal
:: WMIC gets called to get the given Volemename (usefull for external drives or network shares)
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk %ort:~0,2% get VolumeName /value') do (
    set "DriveLabel=%%a"
  )
(
	echo ^<!DOCTYPE HTML PUBLIC
	echo "-//W3C//DTD HTML 4.01 Transitional//EN"
	echo  "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd"^>
	echo ^<HTML^>
	echo ^<HEAD^>
	echo ^<META HTTP-EQUIV="Content-Type"
	echo CONTENT="text/html; charset=utf-8"^>
	echo ^<link rel="shortcut icon" href="file://localhost/%Installdir%/favicon.ico" type="image/x-icon"^>
	echo ^</HEAD^>
	echo ^<BODY^>
	echo Report created by ^<b^>%user%^</b^> ^</^>
	echo - %ldt% ^</br^>
	echo Scannter directory: ^<b^>
	echo %ort:~0,2%\%DriveLabel%\%ort:~3%^</br^>^</b^>
	echo ^<b^>%countmax% File^(s^)^</b^> analysed. ^<input type="button" value="Print" onClick="window.print()"^>^</br^>
	echo ^<a href="file:///%Installdir%\MultiMeta.odc"^>Open in Excel^</a^>
	echo ^<style type="text/css"^>
	echo .tftable {font-size:12px;color:#333333;width:100%;border-width: 1px;border-color: #bcaf91;border-collapse: collapse;}
	echo .tftable th {font-size:12px;background-color:#ded0b0;border-width: 1px;padding: 8px;border-style: solid;border-color: #bcaf91;text-align:center;}
	echo .tftable tr {background-color:#e9dbbb;}
	echo .tftable td {font-size:12px;border-width: 1px;padding: 8px;border-style: solid;border-color: #bcaf91; text-align:left;}
	echo .tftable tr:hover {background-color:#ffffff;}
	echo ^</style^>
	echo ^<center^>^<table class="tftable" border="1"^>
)>%2

setlocal enabledelayedexpansion
for /F "delims=" %%A in ('Type "%~1"') do (
	set "var=%%A"
	set "var=!var:&=&amp;!"
	set "var=!var:<=&lt;!"
	set "var=!var:>=&gt;!"
	for %%a in (%delims%) do (
		set "var=!var:%%~a=</td><td>!"
	)
	echo ^<tr^>^<td^>!var!^</td^>^</tr^>
)>>%2

(
	echo ^</table^>^</center^>
	echo ^</BODY^>
	echo ^</HTML^>
)>>%2
endlocal
exit /b

:Error
:: failsafe
Timeout /T 4 /NoBreak >nul
Exit
