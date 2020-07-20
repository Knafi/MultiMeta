:: S-Meta - Spiegel TV Metadatenanalyse
:: Geschrieben von Philip Brautlecht
:: Basierend auf der Mediainfo CLI Version

@echo off
Title S-Meta
cls

:: Main Program Routine
call :SETUP
call :CLEANUP
call :DATETIME
call :HOME
setlocal enabledelayedexpansion
call :WHITELIST
call :BROWSEFORFOLDER
IF [%nichts%] EQU [y] exit /b
setlocal enabledelayedexpansion
call :MEDIAANALYSE
call :CONVERT2HTML
goto :EOF

:HOME
echo [31m       _____ _____ _____ ______ _____ ______ _         _________      __
echo [31m      / ____^|  __ \_   _^|  ____/ ____^|  ____^| ^|       ^|__   __\ \    / /
echo [31m     ^| (___ ^| ^|__) ^|^| ^| ^| ^|__ ^| ^|  __^| ^|__  ^| ^|          ^| ^|   \ \  / / 
echo [31m      \___ \^|  ___/ ^| ^| ^|  __^|^| ^| ^|_ ^|  __^| ^| ^|          ^| ^|    \ \/ /  
echo [31m      ____) ^| ^|    _^| ^|_^| ^|___^| ^|__^| ^| ^|____^| ^|____      ^| ^|     \  /   
echo [31m     ^|______^|_^|   ^|_____^|______\_____^|______^|______^|     ^|_^|      \/    
echo [0m                                                                      
echo:              	  	 ---- S-Meta ----
echo:                Tool zum Analysieren von Mediafiles                                                
echo:	   
echo:
echo     Anleitung:
echo:
echo     1. Zu gewnschtem Ordner Navigieren
echo     2. Auswahl best„tigen
echo     3. HTML-Report wird ge”ffnet
echo:
goto :EOF


:SETUP
mode con lines=22 cols=78
set ExifDir=C:\sptvtools\S-Meta
set user=%username%
set Dektop=%USERPROFILE%\Desktop
set Mediainfo=C:\sptvtools\S-Meta\MediaInfo.exe
goto :EOF

:CLEANUP
del %temp%\whitelist.txt 2>nul
del %temp%\MediaInfoCLI.txt 2>nul
del %temp%\S-Meta.csv 2>nul
del %temp%\whitelist.tmp 2>nul
del %temp%\S-Meta.tmp 2>nul
goto :EOF

:DATETIME
:: Setzt Datum und Uhrzeit für den HTML Report
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% um %ldt:~8,2%:%ldt:~10,2% Uhr
goto :EOF

:BROWSEFORFOLDER
:: Powershell Workaround, für den Ordner Auswählen Dialog
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'SpiegelTV S-Meta',0x0200,17).self.path""
for /f "usebackq delims=" %%H in (`powershell %psCommand%`) do set "folder=%%H"
set ort=!folder!
IF [!folder!] EQU [] set nichts=y
setlocal enabledelayedexpansion
echo     Es wurde folgender Ordner gew„hlt:
echo     [31m%ort%
echo	 [0m
endlocal
goto :EOF


:WHITELIST
:: Bereitet die Analyse anhand der Konfigurationsdatei vor. Stichwort erlaubte Dateitypen
set B=%ExifDir%\S-Meta.conf
set A=*
for /F "delims=, eol=#" %%b in (%ExifDir%\S-Meta.conf) do (
	<nul echo %A%%%b >>%temp%\whitelist.tmp
	)
for /F %%i in ('type %temp%\whitelist.tmp') do (
	@<nul set /p"=%%i ">>%temp%\S-Meta.tmp
	)
del %temp%\whitelist.tmp

FOR /F "delims=" %%o in (%temp%\S-Meta.tmp) do (
	set whitelist=!whitelist! %%o
	)
del %temp%\S-Meta.tmp
goto :EOF
 


:MEDIAANALYSE
:: Führt die Analyse auf die im vorhinein definierten Files aus, zählt alle die gescannten Files und gibt den aktuellen Status im Programmtitel wieder
Title S-Meta - Suche Files...
echo File^|GrÃ¶ÃŸe^|LÃ¤nge^|AuflÃ¶sung^|FPS^|Scan-Type^|Format>>%temp%\MediaInfoCLI.txt
set /a countmax =0
For /R "%ort%" %%G IN (%whitelist%) do (
	set /a countmax +=1
echo %%G >>%temp%\whitelist.txt
)

set /a countcur =0

for /f "tokens=*" %%D in ('type %temp%\whitelist.txt') do (
	%Mediainfo% --Inform=file://C:\sptvtools\S-Meta\MI-Meta.conf "%%D">>%temp%\MediaInfoCLI.txt
	set /a countcur +=1
	set /a prozent=100*!countcur!/!countmax!
	SET ProgressPercent=!prozent!
	SET /A NumBars=!ProgressPercent!/2
	SET /A NumSpaces=50-!NumBars!
	SET Meter=
	FOR /L %%C IN (!NumBars!,-1,1) DO SET Meter=!Meter!I
	FOR /L %%C IN (!NumSpaces!,-1,1) DO SET Meter=!Meter! 
	TITLE S-Meta - Analysiere Media Files [!Meter!]  !ProgressPercent!%%
)
	
for /f "usebackq tokens=* delims=" %%a in ("%temp%\MediaInfoCLI.txt") do (echo(%%a)>>~.txt
move /y  ~.txt "%temp%\S-Meta.csv">nul
goto :EOF

:CONVERT2HTML
:: Erstellt die HTML Datei
@echo off
Title S-Meta - Erstelle HTML Report
set delims="|"
set "CSV_File=%temp%\S-Meta.csv"
for /f "usebackq delims=" %%a in (`echo "%CSV_File%"`) do ( set "HTML_File=%temp%\%%~na.html")
if exist "%HTML_File%" del /f /q "%HTML_File%"
Timeout /T 2 /nobreak>nul
Call :CreateHTMLtable "%CSV_File%" "%HTML_File%"
del %temp%\whitelist.txt
del %temp%\MediaInfoCLI.txt
copy /y "%HTML_File%" "%ExifDir%\Work\" 1>nul
start "" "%HTML_File%"
exit /b

:CreateHTMLTable <inputfile> <outputfile>
setlocal
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
	echo ^<link rel="shortcut icon" href="file://localhost/%ExifDir%/favicon.ico" type="image/x-icon"^>
	echo ^</HEAD^>
	echo ^<BODY^>
	echo Report von ^<b^>%user%^</b^> ^</^>
	echo am %ldt% erstellt.^</br^>
	echo Gescannter Ordner war: ^<b^>
	echo %ort:~0,2%\%DriveLabel%\%ort:~3%^</br^>^</b^>
	echo Es wurde^(n^) ^<b^>%countmax% File^(s^)^</b^> analysiert. ^<input type="button" value="Drucken" onClick="window.print()"^>^</br^>
	echo ^<a href="file:///%ExifDir%\S-Meta.odc"^>In Excel Ã¶ffnen^</a^>
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
	echo ^<a href="mailto:messtechnik@spiegel-tv.de?subject=Feedback S-Meta Version 1.2"^>Feedback senden^</a^>
	echo ^</BODY^>
	echo ^</HTML^>
)>>%2
endlocal
exit /b

:Error
Timeout /T 4 /NoBreak >nul
Exit







::Credits
::
::Mehrere Farben in der Kommandozeile - 
::	Stackoverflow: https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line
::	MSDN: https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences?redirectedfrom=MSDN
::
::"FolderBrowser - Dialog" -
::	Stackoverflow: https://stackoverflow.com/questions/15885132/file-folder-chooser-dialog-from-a-windows-batch-script
::	MSDN: https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.folderbrowserdialog?redirectedfrom=MSDN&view=netframework-4.8
::
::Fortschritt in Programmtitel - 
::	Github: https://gist.github.com/Archigos/0e34219b4a8b82358bb0
::
::MediainfoCLI - 
::	https://mediaarea.net/de/MediaInfo/Download/Windows
::
::CSV zu HTML konvertieren - 
::	Computerhope: https://www.computerhope.com/forum/index.php?topic=160315.0
::
::Rest - 
::	Philip Brautlecht
::	philip.brautlecht@spiegel-tv.de
