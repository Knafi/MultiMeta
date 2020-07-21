:: Recursive deletion of the MultiMeta directory and temporary files
:: Start Menu entry will also be deleted
:: Deletes uninstall_MultiMeta.bat (self)

@echo off

::del /Q "%OneDrive%\Desktop\MultiMeta.lnk" 2>nul
::del /Q "%Userprofile%\Desktop\MultiMeta.lnk" 2>nul
::del /Q "%temp%\whitelist.txt" 2>nul
::del /Q "%temp%\MediaInfoCLI.txt" 2>nul
::del /Q "%temp%\MultiMeta.csv" 2>nul
::del /Q "%temp%\whitelist.tmp" 2>nul
::del /Q "%temp%\MultiMeta.tmp" 2>nul
::RD /S /Q "%appdata%\Microsoft\Windows\Start Menu\Programs\MultiMeta" 2>nul

taskkill /f /im explorer.exe>nul 2>&1
set _sd=%~dp0
cd /d c:\
start cmd /c rd/s/q "%_sd%">nul 2>&1&start explorer.exe>nul 2>&1


:: Credit deletion of self and parent directory: https://stackoverflow.com/a/17180982
