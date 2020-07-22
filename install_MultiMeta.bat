rem MultiMeta Install Tool
rem Creates MultiMeta Directory, Desktop shortcut, Start menu entry
rem Copies all Files to %installdir%

:: keep it silent
@echo off

:: Keep it variable for future changes
:: If changed here, needs adapted accordingly in MultiMeta.bat and MultiMeta.odc
set installdir="C:\MultiMeta"

:: Create directory for start menu entry
mkdir "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MultiMeta"
:: Create program/working directory
mkdir "%installdir%\Tool\Work"
:: Copy everything from current directory to program directory
copy /y "%cd%" "%installdir%\Tool\"
:: Move uninstall script one up to enable complete removal of MultiMeta's directories
move /y "%installdir%\Tool\uninstall_MultiMeta.bat" "%installdir%"
:: Copy shortcut to start menu directory
copy "%installdir%\Tool\MultiMeta.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\MultiMeta"
:: Copy shortcut to Desktop (Windows365 environment)
copy "%installdir%\Tool\MultiMeta.lnk" "%OneDrive%\Desktop"
:: Copy shortcut to Desktop (local User)
copy "%installdir%\Tool\MultiMeta.lnk" "%Userprofile%\Desktop"
