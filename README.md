# MultiMeta
Multi Metadata analysis and export without Windows 10 admin privileges for videofiles with MediaInfo CLI written in Batch.


This projekt startet with the need to analyse the metadata of countless videofiles at my work. This process often included much more than 500 files per day.
As [MediaInfo](https://mediaarea.net/en/MediaInfo) is already used on site, I used the CLI version of MediaInfo.

The computers we use on site are heavily restricted by our Administrators and are also part of an Office365 environment which forced the use of many *workarounds* to not trigger the UAC.


## What does MultiMeta

## Install
In order to install MultiMeta you just have to execute the **install_MultiMeta.bat** from the downloaded directory.
This script will do the following:
- Create directory *C:\MultiMeta* and copy everything from the downloaded zip to *C:\MultiMeta\Tool*
- Create start menu entry under *%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MultiMeta*
- Move *uninstall_MultiMeta.bat* up one directory for clean uninstall
- Copy shortcut to Desktop for local user and for Windows365 environment

## Usage

## Uninstall
Uninstall is easily done with executing **uninstall_MultiMeta.bat** under *C:\MultiMeta\*.
This script will have the following effects:
- Desktop shortcuts (local and Windows365) will get deleted
- Temp files will get deleted
- Start menu entry will get deleted
- Explorer.exe will get stopped, program directory and the uninstall script will get deleted and Explorer.exe will get restarted

## Credits
I had to search the web alot as I am neither a developer nor a programmer.\
Give credit where credit is due.
  
**Multiple Colors in Batch File:**  
- https://stackoverflow.com/a/38617204  
Jens A. Koch  
- https://github.com/MicrosoftDocs/Console-Docs/blob/master/docs/console-virtual-terminal-sequences.md  
miniksa, bitcrazed, DanielRosenwasser, GoBigorGoHome, VSC-Service-Account, craigloewenms, Vap0r1ze, zadjii-msft, mattwojo, JPRuskin  

**Folder Browser - dialog:**  
- https://stackoverflow.com/a/15885133  
rojo  
- https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.folderbrowserdialog?redirectedfrom=MSDN&view=netframework-4.8  
mairaw, VSC-Service-Account, TianqiZhang, yishengjin1413, dend, BillWagner, mkwhalen, jkotas, gewarren  

**Progress as window title:**  
- https://gist.github.com/Archigos/0e34219b4a8b82358bb0  
Archigos  

**Deletion of self and parent directory:**  
- https://stackoverflow.com/a/17180982  
BILL  

**Convertion from CSV to HTML table:**  
- https://www.computerhope.com/forum/index.php/topic,160315.msg961200.html#msg961200  
Hackoo  

**Metadata analysis:**  
- https://mediaarea.net/en/MediaInfo  
Jérôme Martinez and Team
