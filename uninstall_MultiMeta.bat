:: Keep it silent
@ECHO OFF

rem Recursive deletion of the MultiMeta directory and temporary files
rem Start menu entry will also be deleted
rem Deletes uninstall_MultiMeta.bat (self)


:: Delete shortcut on Desktop (Windows365 environment)
DEL /Q "%OneDrive%\Desktop\MultiMeta.lnk" 2>NUL
:: Delete shortcut on Desktop (local User)
DEL /Q "%Userprofile%\Desktop\MultiMeta.lnk" 2>NUL
:: Delete temp files (these will get replaced everytime the tool gets executed)
DEL /Q "%temp%\whitelist.txt" 2>NUL
DEL /Q "%temp%\MediaInfoCLI.txt" 2>NUL
DEL /Q "%temp%\MultiMeta.csv" 2>NUL
DEL /Q "%temp%\whitelist.tmp" 2>NUL
DEL /Q "%temp%\MultiMeta.tmp" 2>NUL
:: Delete start menu entry
RD /S /Q "%appdata%\Microsoft\Windows\Start Menu\Programs\MultiMeta" 2>NUL

:: Delete program directory. Explorer.exe needs to get restarted to delete parent directory...
TASKKILL /F /IM explorer.exe>NUL 2>&1
SET _sd=%~dp0
CD /D c:\
Start CMD /C RD/S/Q "%_sd%">NUL 2>&1&start explorer.exe>NUL 2>&1
