This Help is from: https://fossies.org/linux/misc/MediaInfo_CLI_20.08_GNU_FromSource.tar.xz/  
*Attention: The text wasn't changed. I just reformatted it a bit for readability.*

---

Note from MediaInfo author:  
> this document was written by someone else.  
> I provide no support about it.  
> Author: Anonymous  
> Licence: Public domain  



# MediaInfo Commmand Line Interface

MediaInfo GUI provides multiple ways to display the attributes of an audio/visual file.

MediaInfo Command Line Interface(CLI) provides the additional capability to query the values of specific attributes of an audio/video file, which then allows these values to be used within batch files to determine the appropriate processing of the file.

For example when converting a file with ffmpeg, if the audio or video stream is already encoded in the target format then the copy option can be used in place of the target codec option used for other stream formats. Similarly for example the existing audio stream bitrate can be used to set the target bit rate, rather than setting a fixed value that may be greater or less than the source bitrate.

Since the GUI and CLI use different versions of mediainfo.exe, and the GUI.exe installs into C:\Program Files, the best bet is to unzip the command line CLI.zip files into C:\programs\mediainfo_cli\.

## The Command Line Options

The CLI command line with its options would then be:
```
C:\programs\mediainfo_cli\mediainfo.exe -h             --> for a description of the command line options
C:\programs\mediainfo_cli\mediainfo.exe --Version      --> display the Mediainfo version and exit
C:\programs\mediainfo_cli\mediainfo.exe avfile         --> for a listing of the key attributes of avfile
C:\programs\mediainfo_cli\mediainfo.exe -f avfile      --> for a listing of all the attributes of avfile
C:\programs\mediainfo_cli\mediainfo.exe --help-Inform  --> for a description of the -–Inform= option
C:\programs\mediainfo_cli\mediainfo.exe --Info-Parameters --> for a listing of the attributes available as parameters with the --Inform= option. An abbreviated list of key attributes is provided in Appendix A
C:\programs\mediainfo_cli\mediainfo.exe --Inform=section;template avfile --> to output the specified section and template values of attributes of avifile
C:\programs\mediainfo_cli\mediainfo.exe --Inform=[section;]file://templatefile avfile --> to output the values of avifile attributes specified in the section and templatefile. If section is not specified in the command line it must be specified in the templatefile.
```
Sections may be:           General, Video, Audio, Text, Chapter, Image, Menu

Templates are of the form: [text]%parameter%[text][%parameter%][text]...

Templatefiles contain: [section;][text]%parameter%[text][%parameter%][text]...

Text may include:  \r\n to begin a newline. (carriage return 0D and linefeed 0A)

Additionally the options --Output=HTML and/or --Language=raw may be added to the command to force output in HTML tag format or internal text, however they do not work with the --Inform options, and the HTML option does not seem to work with the other options.

## Command Line Examples

Using the template option for example:
```
C:\programs\mediainfo_cli\mediainfo.exe "--Inform=General;Filename is: %FileName%" "C:\videos\USA Holiday.mpg"
```
will output:
```
Filename is: USA Holiday
```
And using the templatefile option for example:

If the file C:\temp\template.txt contains:
```
General;File is:%FileName%
Video;Resolution is:%Width%x%Height%\r\nAspect %DisplayAspectRatio/String%\r\n
Audio;Codec = %Format%
```
and the command is:
```
C:\programs\mediainfo_cli\mediainfo.exe --Inform=file://C:\temp\template.txt "C:\videos\USA Holiday.mpg"
```
then the output will be:
```
File is:Holiday Resolution is:720x480
Aspect 4/3
Codec = AC-3
```
## Important Notes
---
Note that:
-if the options or filenames in the command contain blanks they must be enclosed in quotes ".
-	each %parameter% must match the spelling and capitalization shown in the --Info-Parameters listing.
-	parameters followed by /String will convert numeric values to fractional form eg: 1.333 will be 4/3
-	the template option may only be used for the output of one section
-	the templatefile option must be used for output from multiple sections
-	a section may only be specified once in a templatefile. eg: if a second Video; line is used it will be ignored.
-	multiple parameters may be specified for a section eg: [text]%parm1%[text]%parm2%[text]...
-	the blank spaces following parameters in a templatefile are significant on output. For example the blank space between Holiday and Resolution in the example was due to a space following %FileName% in the template.txt file.
-	\> outputfilename at the end of the command line will pipe output to a file.
-	if the commands are used within a .bat file, the parameters must be enclosed in double % signs ie: %%parameter%%

## Using the CLI Output in Batch Processing

Since the MediaInfo output may be piped to a file, any attribute value can be output and read from the file by a .bat file and used to make processing decisions.

The following code may be used in a .bat file to generate a file with an attribute value from a %1 input file, access the file to extract the value, and then use it to determine subsequent processing:

```
: Generate file C:\value.txt with the value for %parameter% in section;
C:\Programs\mediainfo_cli\mediainfo.exe --Inform=Section;%%parameter%% %1 > C:\value.txt
: Read the value from C:\value.txt and Set myvar equal to it.
for /f "tokens=*" %%A in ('type C:\value.txt') do set myVar=%%A
:Compare the value now in myvar to a "target value" and control processing.
if ".%myvar%" == ".target value" statement
```

## Batch Processing Example

If a file C:\video\USA Holiday.mpg contains AC-3 audio, then this may be determined and used in the following C:\conversion.bat called using:

C:\conversion.bat C:\video\USA Holiday.mpg

### conversion.bat
```
@echo off
: Get the codec
C:\Programs\mediainfo_cli\mediainfo.exe --Inform=Audio;%%Codec%% %1 > C:\value.txt
: Read it
for /f "tokens=*" %%A in ('type C:\miresult.txt') do set myVar=%%A
: Test for AC-3
if ".%myvar%" == ".AC-3" goto :AC3
: non-AC-3 processing follows
ffmpeg.....
goto :exit
:AC3
: AC-3 processing follows
ffmpeg....
:exit
```



## Appendix A

The following pages contain an abbreviated set of parameter names and examples of possible target values generated by MediaInfo_CLI from actual av files. For use with the –Inform= option in .bat files.
Section;%Parameter%	Description			P o s s I b l e	V a l u e s		


| General;         |                                        |              |              |                        |        |               |          |             |
|------------------|----------------------------------------|--------------|--------------|------------------------|--------|---------------|----------|-------------|
| CompleteName     | Complete name (Folder\Name.Ext)        |              |              |                        |        |               |          |             |
| FileName         | File name only                         |              |              |                        |        |               |          |             |
| FileExtension    | File extension only  eg: mpg mkv avi   | mpg or vob   | ts           | avi                    | mp4    | wmv           | mkv      | flv         |
| Format           | Format used  eg: MPEG-2 Matroska       | MPEG-PS      | MPEG-TS      | AVI                    | MPEG-4 | Windows Media | Matroska | Flash Video |
| Format/Info      | Info about Format                      |              |              | Audio Video Interleave |        |               |          |             |
| FileSize         | File size in bytes                     | 4369920      | 843185452    | 1073739776             |        |               |          |             |
| FileSize/String  | File size (with measure)               | 4.17 MiB     | 804 MiB      | 1 024 MiB              |        |               |          |             |
| FileSize/String1 | File size (with measure, 1 digit mini) | 4 MiB        | 804 MiB      | 1 024 MiB              |        |               |          |             |
| FileSize/String2 | File size (with measure, 2 digit mini) | 4.2 MiB      | 804 MiB      | 1 024 MiB              |        |               |          |             |
| FileSize/String3 | File size (with measure, 3 digit mini) | 4.17 MiB     | 804 MiB      | 1 024 MiB              |        |               |          |             |
| FileSize/String4 | File size (with measure, 4 digit mini) | 4.167 MiB    | 804.1 MiB    | 1 024.0 MiB            |        |               |          |             |
| Duration         | Play time of the stream                | 2362278      | 396976       | 1568016                |        |               |          |             |
| Duration/String  | Play time (formated)                   | 6mn 36s      | 26mn 8s      | 39mn 22s               |        |               |          |             |
| Duration/String1 | Play time in : HHh MMmn SSs MMMms      | 6mn 36s 76ms | 26mn 8s 16ms | 39mn 22s 27ms          |        |               |          |             |
| Duration/String2 | Play time in format : HHh MMmn SSs     | 6mn 36s      | 26mn 8s      | 39mn 22s               |        |               |          |             |
| Duration/String3 | Play time in format : HH:MM:SS.MMM     | 06:37.0      | 26:08.0      | 39:22.0                |        |               |          |             |


| Video;                    |                                     | mpg,vob,ts     | avi or mp4         | mp4 only      | mp4 or mkv           | wmv only   | wmv only     | flv only     |
|---------------------------|-------------------------------------|----------------|--------------------|---------------|----------------------|------------|--------------|--------------|
| Format                    | Format used                         | MPEG Video     | MPEG-4 Visual      | MPEG-4 Visual | AVC                  | WVP2       | VC-1         | H.263 or VP6 |
| Format/Info               | Info about Format                   |                |                    |               | Advanced Video Codec |            |              |              |
| Format_Version            | Version of this format              | Version 2      |                    |               |                      |            |              |              |
| Format_Profile            | Profile of the Format               | Main@Main      | Streaming Video@L1 | Simple@Ln     | Main@L4.n            |            | MP@ML        |              |
|                           |                                     | Main@High      |                    |               | High@L3.1            |            |              |              |
| CodecID                   | Codec ID (found in some containers) |                | XVID or DX50       | MP4V          | V_MPEG4/ISO/AVC      | WVP2       | WMV3         |              |
| CodecID/Hint              | A hint for this codec ID            |                | XviD or DivX 5     |               |                      |            | WMV3         |              |
| Duration                  | Play time of the stream             | 729578         |                    |               |                      |            |              |              |
| Duration/String           | Play time (formated)                | 12mn 9s        |                    |               |                      |            |              |              |
| Duration/String1          | Play time in : HHh MMmn SSs MMMms   | 12mn 9s 78ms   |                    |               |                      |            |              |              |
| Duration/String2          | Play time in format : HHh MMmn SSs  | 12mn 9s        |                    |               |                      |            |              |              |
| Duration/String3          | Play time in format : HH:MM:SS.MMM  | 12:10.0        |                    |               |                      |            |              |              |
| BitRate_Mode              | Bit rate mode (VBR, CBR)            | CBR            | VBR                |               |                      |            |              |              |
| BitRate_Mode/String       | Bit rate mode (VBR, CBR)            | Constant       | Variable           |               |                      |            |              |              |
| BitRate                   | Bit rate in bps                     | 3018811        |                    |               |                      |            |              |              |
| BitRate/String            | Bit rate (with measurement)         | 3 019 Kbps     | 15.9 Mbps          |               |                      |            |              |              |
| BitRate_Minimum           | Minimum Bit rate in bps             |                |                    |               |                      |            |              |              |
| BitRate_Minimum/String    | Minimum Bit rate (with measurement) |                |                    |               |                      |            |              |              |
| BitRate_Nominal           | Nominal Bit rate in bps             | 10000000       | 17448800           |               |                      |            |              |              |
| BitRate_Nominal/String    | Nominal Bit rate (with measurement) | 10 000 Kbps    | 17.4 Mbps          |               |                      |            |              |              |
| BitRate_Maximum           | Maximum Bit rate in bps             |                |                    |               |                      |            |              |              |
| BitRate_Maximum/String    | Maximum Bit rate (with measurement) |                |                    |               |                      |            |              |              |
| Width                     | Width                               | 320            | 640                | 704           | 720                  | 720        | 1280         | 1920         |
| Width/String              |                                     | 320 pixels     | 640 pixels         | 704 pixels    | 720 pixels           | 720 pixels | 1 280 pixels | 1 920 pixels |
| Height                    | Height                              | 240            | 480                | 480           | 480                  | 576        | 720          | 1080         |
| Height/String             |                                     | 240 pixels     | 480 pixels         | 480 pixels    | 480 pixels           | 576 pixels | 720 pixels   | 1 080 pixels |
| PixelAspectRatio          | Pixel Aspect ratio                  |                |                    | 0.909         | 1.185                |            | 1            | 1            |
| PixelAspectRatio/String   | Pixel Aspect ratio                  |                |                    |               |                      |            |              |              |
| DisplayAspectRatio        | Display Aspect ratio                | Jan 25         | 1.333              | 1.778         |                      |            |              |              |
| DisplayAspectRatio/String | Display Aspect ratio                | 05. Apr        | 04. Mrz            | 16. Sep       |                      |            |              |              |
| FrameRate_Mode            | Frame rate mode (CFR, VFR)          | CFR            |                    |               |                      |            |              |              |
| FrameRate_Mode/String     | Frame rate mode (CFR, VFR)          | Constant       |                    |               |                      |            |              |              |
| FrameRate                 | Frame rate                          | 15.001         | 23.976             | 25            | 29.97                | 30         |              |              |
| FrameRate/String          | Frame rate                          | 15.001 fps     | 23.976 fps         | 25.000 fps    | 29.970 fps           | 30.000 fps |              |              |
| FrameCount                | Frame count                         | 56638          |                    |               |                      |            |              |              |
| Standard                  | NTSC or PAL                         | NTSC           | Component          | PAL           |                      |            |              |              |
| Colorimetry               |                                     | 04:02:00       |                    |               |                      |            |              |              |
| ScanType                  |                                     | Progressive    | Interlaced         |               |                      |            |              |              |
| ScanType/String           |                                     | Progressive    | Interlaced         |               |                      |            |              |              |
| StreamSize                | Stream size in bytes                | 3318999        | 35368360           | 933204082     |                      |            |              |              |
| StreamSize/String         |                                     | 3.17 MiB (76%) | 33.7 MiB (75%)     | 890 MiB (89%) |                      |            |              |              |
| StreamSize/String1        |                                     | 3 MiB          | 34 MiB             | 890 MiB       |                      |            |              |              |
| StreamSize/String2        |                                     | 3.2 MiB        | 34 MiB             | 890 MiB       |                      |            |              |              |
| StreamSize/String3        |                                     | 3.17 MiB       | 33.7 MiB           | 890 MiB       |                      |            |              |              |
| StreamSize/String4        |                                     | 3.165 MiB      | 33.73 MiB          | 890.0 MiB     |                      |            |              |              |
| Language/String           | Language (full)                     | English        | en-us              |               |                      |            |              |              |


| Audio;              |                                     |               |                |                |                              |                      |          |          |
|---------------------|-------------------------------------|---------------|----------------|----------------|------------------------------|----------------------|----------|----------|
| Format              | Format used                         | MPEG Audio    | MPEG Audio     | AC-3           | DTS                          | AAC                  | Vorbis   | WMA2     |
| Format/Info         | Info about Format                   |               |                | Audio Coding 3 | Digital Theater Systems      | Advanced Audio Codec |          |          |
| Format_Version      | Version of this format              | Version 1     | Version 1 or 2 |                |                              | Version 2 or 4       |          |          |
| Format_Profile      | Profile of the Format               | Layer 2       | Layer 3        | Dolby Digital  |                              | LC                   |          | L1 or L2 |
| CodecID             | Codec ID (found in some containers) |               |                | 2000 or A_AC3  |                              |                      | A_VORBIS | 161      |
| CodecID/Hint        | A hint for this codec ID            |               | MP3            |                |                              |                      |          |          |
| Duration            | Play time of the stream             | 30888         | 1306533        |                |                              |                      |          |          |
| Duration/String     | Play time (formated)                | 30s 888ms     | 21mn 46s       |                |                              |                      |          |          |
| Duration/String1    | Play time in : HHh MMmn SSs MMMms   | 30s 888ms     | 21mn 46s 533ms |                |                              |                      |          |          |
| Duration/String2    | Play time in format : HHh MMmn SSs  | 30s 888ms     | 21mn 46s       |                |                              |                      |          |          |
| Duration/String3    | Play time in format : HH:MM:SS.MMM  | 00:31.0       | 21:47.0        |                |                              |                      |          |          |
| BitRate_Mode        | Bit rate mode (VBR, CBR)            | CBR           | VBR            |                |                              |                      |          |          |
| BitRate_Mode/String | Bit rate mode (VBR, CBR)            | Constant      | Variable       |                |                              |                      |          |          |
| BitRate             | Bit rate in bps                     | 63997         | 111504         | 128000         | 384000                       | 768000               |          |          |
| BitRate/String      | Bit rate (with measurement)         | 64.0 Kbps     | 112 Kbps       | 128 Kbps       | 384 Kbps                     | 768 Kbps             |          |          |
| Channel(s)          | Number of channels                  | 2             | 2              | 2              | 6                            |                      |          |          |
| Channel(s)/String   | Number of channels                  | 2 channels    | 2 channels     | 2 channels     | 6 channels                   |                      |          |          |
| ChannelPositions    | Position of channels                |               |                | L R            | Front: L C R, Rear: L R, LFE |                      |          |          |
| SamplingRate        | Sampling rate                       | 22050         | 44100          | 48000          | 48000                        |                      |          |          |
| SamplingRate/String | in KHz                              | 22.05 KHz     | 44.1 KHz       | 48.0 KHz       | 48.0 KHz                     |                      |          |          |
| StreamSize          | Stream size in bytes                | 961485        | 11252712       |                |                              |                      |          |          |
| StreamSize/String   |                                     | 939 KiB (22%) | 10.7 MiB (24%) |                |                              |                      |          |          |
| StreamSize/String1  |                                     | 939 KiB       | 11 MiB         |                |                              |                      |          |          |
| StreamSize/String2  |                                     | 939 KiB       | 11 MiB         |                |                              |                      |          |          |
| StreamSize/String3  |                                     | 939 KiB       | 10.7 MiB       |                |                              |                      |          |          |
| StreamSize/String4  |                                     | 939.0 KiB     | 10.73 MiB      |                |                              |                      |          |          |


| Menu;  |                           |           |
|--------|---------------------------|-----------|
| Format | Format used eg: DVD-Video | DVD-Video |
