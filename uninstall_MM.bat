:: Recursive deletion of the MultiMeta directory and temporary files
:: Start Menu entry will also be deleted
:: Deletes uninstall_MM.bat (self)

@echo off

del /Q "%OneDrive%\Desktop\S-Meta.lnk" 2>nul
del /Q "%Userprofile%\Desktop\S-Meta.lnk" 2>nul
del /Q "%temp%\whitelist.txt" 2>nul
del /Q "%temp%\MediaInfoCLI.txt" 2>nul
del /Q "%temp%\S-Meta.csv" 2>nul
del /Q "%temp%\whitelist.tmp" 2>nul
del /Q "%temp%\S-Meta.tmp" 2>nul
RD /S /Q "%appdata%\Microsoft\Windows\Start Menu\Programs\S-Meta" 2>nul
RD /S /Q "C:\sptvtools\S-Meta" 2>nul
(goto) 2>nul & del "%~f0"
