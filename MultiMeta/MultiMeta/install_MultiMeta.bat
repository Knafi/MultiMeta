:: Keep it silent
@ECHO OFF

rem MultiMeta Install Tool
rem Creates MultiMeta Directory, Desktop shortcut, Start menu entry
rem Copies all files to %installdir%


:: Keep it variable for future changes
:: If changed here, needs to be adapted accordingly in MultiMeta.bat and MultiMeta.odc
SET installdir="C:\MultiMeta"

:: Create directory for start menu entry
2>NUL MKDIR "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MultiMeta"
:: Create program/working directory
2>NUL MKDIR "%installdir%\Tool\Work"
:: Copy everything from current directory to program directory
>NUL COPY /Y "%cd%" "%installdir%\Tool\"
:: Move uninstall script one up to enable complete removal of MultiMeta's directories
>NUL MOVE /Y "%installdir%\Tool\uninstall_MultiMeta.bat" "%installdir%"
:: Copy shortcut to start menu directory
>NUL COPY "%installdir%\Tool\MultiMeta.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\MultiMeta"
:: Copy shortcut to Desktop (Windows365 environment)
>NUL COPY "%installdir%\Tool\MultiMeta.lnk" "%OneDrive%\Desktop"
:: Copy shortcut to Desktop (local User)
>NUL COPY "%installdir%\Tool\MultiMeta.lnk" "%Userprofile%\Desktop"
