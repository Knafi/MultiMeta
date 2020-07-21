:: MultiMeta Install Tool
:: Creates MultiMeta Directory, Desktop shortcut, Start menu entry
:: Moves all Files to %installdir%

@echo off
set startmenu="%appdata%\Microsoft\Windows\Start Menu\Programs\MultiMeta"
set installdir="C:\MultiMeta"


mkdir "%startmenu%"
mkdir "%installdir%"
move /y "%cd%\Tool" "%installdir%"
move /y "%installdir%\Tool\uninstall_MultiMeta.bat" "%installdir%"
copy "%installdir%\Tool\MultiMeta.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\MultiMeta"
copy "%installdir%\Tool\MultiMeta.lnk" "%OneDrive%\Desktop"
copy "%installdir%\Tool\MultiMeta.lnk" "%Userprofile%\Desktop"
