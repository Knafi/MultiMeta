:: Keep it silent
@ECHO OFF

:: SET windows title
TITLE MultiMeta
:: Tidy
CLS


:: Main program routine
:: Calls subroutines and returns with goto :EOF or EXIT /B
CALL :SETUP
CALL :CLEANUP
CALL :DATETIME
CALL :HOME
SETLOCAL ENABLEDELAYEDEXPANSION
CALL :WHITELIST
CALL :BROWSEFORFOLDER
IF [%not%] EQU [y] EXIT /B
SETLOCAL ENABLEDELAYEDEXPANSION
CALL :MEDIAANALYSE
CALL :CONVERT2HTML
GOTO :EOF

:: Main program windows - this is what the user sees
:HOME
:: Colored logo here
:: Pipe character needs to get escaped with ^
ECHO:
ECHO [31m                   __  __       _ _   _ __  __      _        
ECHO [31m                  ^|  \/  ^|     ^| ^| ^| (_)  \/  ^|    ^| ^|       
ECHO [31m                  ^| \  / ^|_   _^| ^| ^|_ _^| \  / ^| ___^| ^|_ __ _ 
ECHO [31m                  ^| ^|\/^| ^| ^| ^| ^| ^| __^| ^| ^|\/^| ^|/ _ \ __/ _` ^|
ECHO [31m                  ^| ^|  ^| ^| ^|_^| ^| ^| ^|_^| ^| ^|  ^| ^|  __/ ^|^| (_^| ^|
ECHO [31m                  ^|_^|  ^|_^|\__,_^|_^|\__^|_^|_^|  ^|_^|\___^|\__\__,_^|
ECHO [0m                                                                      
ECHO:                       Tool for mass metadata analysis
ECHO:	        	  MediaInfo Version 20.03
ECHO:
ECHO     How To:
ECHO:
ECHO     1. Choose directory
ECHO     2. Confirm
ECHO     3. Once finished, report will open automatically
ECHO:
GOTO :EOF

:SETUP
:: SET window size
mode con lines=22 cols=78
:: Keep it variable for future changes
SET Installdir=C:\MultiMeta\Tool
SET user=%username%
SET Dektop=%USERPROFILE%\Desktop
SET Mediainfo=C:\MultiMeta\Tool\MediaInfo.exe
GOTO :EOF

:CLEANUP
:: Cleanup last session
DEL %temp%\whitelist.txt 2>NUL
DEL %temp%\MediaInfoCLI.txt 2>NUL
DEL %temp%\MultiMeta.csv 2>NUL
DEL %temp%\whitelist.tmp 2>NUL
DEL %temp%\MultiMeta.tmp 2>NUL
GOTO :EOF

:DATETIME
:: Get date and time for usage in HTML and PDF report
FOR /F "usebackq tokens=1,2 delims==" %%i IN (`wmic os get LocalDateTime /VALUE 2^>NUL`) DO IF '.%%i.'=='.LocalDateTime.' SET ldt=%%j
SET ldt=Date: %ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2%, Time: %ldt:~8,2%:%ldt:~10,2%
GOTO :EOF

:BROWSEFORFOLDER
:: "Browse for folder" dialog with Powershell
:: Without 0 in PsCommand it doesn't work. Don't ask me why...
:: Next is the description
:: 0x0200 disables the "new directory" Button 
:: 17 is the starting path. In this case "This Computer"
SET "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'MultiMeta',0x0200,17).self.path""
FOR /F "usebackq delims=" %%H IN (`powershell %psCommand%`) DO SET "folder=%%H"
SET directory=!folder!
IF [!folder!] EQU [] SET not=y
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO     Chosen directory:
ECHO     [31m%directory%
ECHO	 [0m
ENDLOCAL
GOTO :EOF


:WHITELIST
:: Get all allowed extensions from MultiMeta.conf and type them into a temp file for use with MediaInfo
:: Adds * for usage like *.mp4, *.mxf, ...
SET B=%Installdir%\MultiMeta.conf
SET A=*
FOR /F "delims=, eol=#" %%b IN (%Installdir%\MultiMeta.conf) DO (
	<NUL ECHO %A%%%b >>%temp%\whitelist.tmp
	)
FOR /F %%i IN ('TYPE %temp%\whitelist.tmp') DO (
	@<NUL SET /P"=%%i ">>%temp%\MultiMeta.tmp
	)
DEL %temp%\whitelist.tmp

FOR /F "delims=" %%o IN (%temp%\MultiMeta.tmp) DO (
	SET whitelist=!whitelist! %%o
	)
DEL %temp%\MultiMeta.tmp
GOTO :EOF
 


:MEDIAANALYSE
:: Change Title
TITLE MultiMeta - Searching...
:: Prepare report with first line for later reporting
:: If delimiter gets changeg. You have to change it in :CONVERT2HTML aswell
ECHO File^|Size^|Duration^|Resolution^|FPS^|Scan-Type^|Format>>%temp%\MediaInfoCLI.txt
:: Prepate Filecount for use in report and window title 
SET /A countmax =0
FOR /R "%directory%" %%G IN (%whitelist%) DO (
	SET /A countmax +=1
ECHO %%G >>%temp%\whitelist.txt
)

SET /A countcur =0
:: MediaInfo analysis with Mi-Meta.conf and whitelist
:: SET window title according to current progress
FOR /F "tokens=*" %%D IN ('TYPE %temp%\whitelist.txt') DO (
	%Mediainfo% --Inform=file://C:\MultiMeta\Tool\MI_Meta.conf "%%D">>%temp%\MediaInfoCLI.txt
	SET /A countcur +=1
	SET /A prozent=100*!countcur!/!countmax!
	SET ProgressPercent=!prozent!
	SET /A NumBars=!ProgressPercent!/2
	SET /A NumSpaces=50-!NumBars!
	SET Meter=
	FOR /L %%C IN (!NumBars!,-1,1) DO SET Meter=!Meter!I
	FOR /L %%C IN (!NumSpaces!,-1,1) DO SET Meter=!Meter! 
	TITLE MultiMeta - Analysing Media Files [!Meter!]  !ProgressPercent!%%
)
	
FOR /F "usebackq tokens=* delims=" %%a IN ("%temp%\MediaInfoCLI.txt") DO (ECHO(%%a)>>~.txt
:: CSV file in temp directory
MOVE /Y  ~.txt "%temp%\MultiMeta.csv">NUL
GOTO :EOF

:CONVERT2HTML
:: Update title
TITLE MultiMeta - Creating Report
:: SET delimiter for csv conversion. If changed here has to be changed in :MEDIAANALYSE aswell
SET delims="|"
SET "CSV_File=%temp%\MultiMeta.csv"
:: Name HTML file
FOR /F "usebackq delims=" %%a IN (`ECHO "%CSV_File%"`) DO ( SET "HTML_File=%temp%\%%~na.html")
:: Overwrite previous HTML file
IF EXIST "%HTML_File%" DEL /F /Q "%HTML_File%"
TIMEOUT /T 2 /nobreak>NUL
CALL :CreateHTMLtable "%CSV_File%" "%HTML_File%"
:: Delete temp files to prevent wrong results at next execution
DEL %temp%\whitelist.txt
DEL %temp%\MediaInfoCLI.txt
:: Copy HTML file to %installdir%\work as backup. Gets overwritten everytime!!!
COPY /Y "%HTML_File%" "%Installdir%\Work\" 1>NUL
:: Open HTML report
START "" "%HTML_File%"
EXIT /B

:CreateHTMLTable <inputfile> <outputfile>
SETLOCAL
:: Wmic gets called to get the given Volemename (usefull for external drives or network shares)
FOR /F "tokens=2 delims==" %%a IN ('wmic logicaldisk %directory:~0,2% get VolumeName /value') DO (
    SET "DriveLabel=%%a"
  )
(
	ECHO ^<!DOCTYPE HTML PUBLIC
	ECHO "-//W3C//DTD HTML 4.01 Transitional//EN"
	ECHO  "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd"^>
	ECHO ^<HTML^>
	ECHO ^<HEAD^>
	ECHO ^<META HTTP-EQUIV="Content-Type"
	ECHO CONTENT="text/html; charset=utf-8"^>
	ECHO ^<link rel="shortcut icon" href="file://localhost/%Installdir%/favicon.ico" type="image/x-icon"^>
	ECHO ^</HEAD^>
	ECHO ^<BODY^>
	ECHO Report created by ^<b^>%user%^</b^> ^</^>
	ECHO - %ldt% ^</br^>
	ECHO Scanned directory: ^<b^>
	ECHO %directory:~0,2%\%DriveLabel%\%directory:~3%^</br^>^</b^>
	ECHO ^<b^>%countmax% File^(s^)^</b^> analysed. ^<input type="button" value="Print" onClick="window.print()"^>^</br^>
	ECHO ^<a href="file:///%Installdir%\MultiMeta.odc"^>Open in Excel^</a^>
	ECHO ^<style type="text/css"^>
	ECHO .tftable {font-size:12px;color:#333333;width:100%;border-width: 1px;border-color: #bcaf91;border-collapse: collapse;}
	ECHO .tftable th {font-size:12px;background-color:#ded0b0;border-width: 1px;padding: 8px;border-style: solid;border-color: #bcaf91;text-align:center;}
	ECHO .tftable tr {background-color:#e9dbbb;}
	ECHO .tftable td {font-size:12px;border-width: 1px;padding: 8px;border-style: solid;border-color: #bcaf91; text-align:left;}
	ECHO .tftable tr:hover {background-color:#ffffff;}
	ECHO ^</style^>
	ECHO ^<center^>^<table class="tftable" border="1"^>
)>%2

SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "delims=" %%A IN ('TYPE "%~1"') DO (
	SET "var=%%A"
	SET "var=!var:&=&amp;!"
	SET "var=!var:<=&lt;!"
	SET "var=!var:>=&gt;!"
	FOR %%a IN (%delims%) DO (
		SET "var=!var:%%~a=</td><td>!"
	)
	ECHO ^<tr^>^<td^>!var!^</td^>^</tr^>
)>>%2

(
	ECHO ^</table^>^</center^>
	ECHO ^</BODY^>
	ECHO ^</HTML^>
)>>%2
ENDLOCAL
EXIT /B

:Error
:: failsafe
TIMEOUT /T 4 /NOBREAK >NUL
EXIT
