# MultiMeta

This projekt startet with the need to analyse the metadata of countless videofiles at my work. This process often included much more than 500 files per day.
The commandline version of [MediaInfo](https://mediaarea.net/en/MediaInfo) is used to do the analysing part. It is fast, customizable and has a the possibility to redirect the output.

![MultiMeta](MultiMeta_Gui.JPG)

The computers we use on site are heavily restricted by our Administrators and are also part of an Office365 environment which forced the use of many workarounds to not trigger the UAC. The biggest restriction was not beeing able to install anything. Which brought up the interesting challenge of using Batch only


## What does MultiMeta
With MultiMeta it is possible to use MediaInfo on a whole directory tree. You get asked to choose the parent directory and everything (checked against a whitelist) inside said directory will get analysed and reported with your set parameters (not yet interactive). Right now those parameters are:  
- Filename (with full path), 
- Filesize
- Duration
- Resolution
- FPS
- Scan-Type
- Format  

Once the analysing part is complete a HTML page with the report will open in your standard browser.
From here on you can print, print to PDF or open the report in Excel.


## Install
In order to install MultiMeta you have to execute the **install_MultiMeta.bat** from the downloaded directory.
This script will do the following:
- Create directory *C:\MultiMeta* and copy everything from the downloaded zip to *C:\MultiMeta\Tool*
- Create a start menu entry under *%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\MultiMeta*
- Move *uninstall_MultiMeta.bat* to *C:\MultiMeta* for clean uninstall
- Copy shortcut to Desktop for local user and for Windows365 environment

## Usage

![MultiMeta](MultiMeta_usage.gif)  


## Uninstall
Uninstall is easily done with executing **uninstall_MultiMeta.bat** under *C:\MultiMeta*.
This script will have the following effects:
- Desktop shortcuts (local and Windows365) will get deleted
- Temp files will get deleted
- Start menu entry will get deleted
- Explorer.exe will get stopped, program directory and the uninstall script will get deleted and Explorer.exe will get restarted (cleanest way so far)

## Useful Links
I came across multiple website that helped me during development. Here are some of them. The rest is listed under Credits.  
- https://ss64.com/nt/  
on SS64 and its forum I learnt alot about Dos and Don'ts with Batch. This is my Goto ressource when it comes to Batch.  
The forum provides many tricks and interresting ideas. Definately worth a read.  
- https://www.robvanderwoude.com/  
Rob van der Woude provides very helpful informations on his site. He has many code examples which have perfect desciptions on how they work.  
- https://de.wikibooks.org/wiki/Batch-Programmierung  
German Wikibook.  
- https://en.wikibooks.org/wiki/Windows_Batch_Scripting  
Similiar english version.  


## Credits
I had to search the web alot as I am neither a developer nor a programmer.\
Give credit where credit is due.
  
**Metadata analysis:**  
This product uses [MediaInfo library](https://mediaarea.net/en/MediaInfo), Copyright (c) 2002-2020 [MediaArea.net SARL](info@mediaarea.net).  
- https://mediaarea.net/en/MediaInfo  
Jérôme Martinez and Team  
  
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
