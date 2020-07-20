:: MultiMeta Install Tool
:: "Installs" MultiMeta shortcut on the Desktop and adds a Start menu entry.
:: außerdem wird der uninstaller eine Ebene hoch geschoben (C:\sptvtools), damit er ordntlich funktioniert. Ansonsten kann es passieren, dass er den S-Meta Ordner nicht löscht
mkdir "%appdata%\Microsoft\Windows\Start Menu\Programs\MultiMeta"
copy "C:\sptvtools\S-Meta\S-Meta.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\S-Meta"
copy "C:\sptvtools\S-Meta\S-Meta.lnk" "%OneDrive%\Desktop"
copy "C:\sptvtools\S-Meta\S-Meta.lnk" "%Userprofile%\Desktop"
move /y "C:\sptvtools\S-Meta\uninstall_S-Meta.bat" "C:\sptvtools"
