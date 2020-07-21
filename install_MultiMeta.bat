:: MultiMeta Install Tool
:: Creates MultiMeta Directory, Desktop shortcut, Start menu entry
:: Moves all Files to %installdir%

set startmenu=%appdata%\Microsoft\Windows\Start Menu\Programs\MultiMeta
set installdir=C:\MultiMeta\Tool\


mkdir "%startmenu%"
mkdir "%installdir%"
move /y "%cd%\Tool" "%installdir%"
copy "%installdir%\S-Meta.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\S-Meta"
copy "%installdir%\S-Meta.lnk" "%OneDrive%\Desktop"
copy "%installdir%\S-Meta.lnk" "%Userprofile%\Desktop"
