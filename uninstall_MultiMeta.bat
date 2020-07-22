rem Recursive deletion of the MultiMeta directory and temporary files
rem Start Menu entry will also be deleted
rem Deletes uninstall_MultiMeta.bat (self)

:: keep it silent
@echo off

:: Delete shortcut on Desktop (Windows365 environment)
del /Q "%OneDrive%\Desktop\MultiMeta.lnk" 2>nul
:: Delete shortcut on Desktop (local User)
del /Q "%Userprofile%\Desktop\MultiMeta.lnk" 2>nul
:: Delete temp files (these will get replaced everytime the Tool gets executed)
del /Q "%temp%\whitelist.txt" 2>nul
del /Q "%temp%\MediaInfoCLI.txt" 2>nul
del /Q "%temp%\MultiMeta.csv" 2>nul
del /Q "%temp%\whitelist.tmp" 2>nul
del /Q "%temp%\MultiMeta.tmp" 2>nul
:: Delete start menu entry
RD /S /Q "%appdata%\Microsoft\Windows\Start Menu\Programs\MultiMeta" 2>nul

:: Delete program directory. Explorer.exe needs to get restarted to delete parent directory...
taskkill /f /im explorer.exe>nul 2>&1
set _sd=%~dp0
cd /d c:\
start cmd /c rd/s/q "%_sd%">nul 2>&1&start explorer.exe>nul 2>&1
