## Office Data Connection

MultiMeta uses an Office Data Connection templatefile for viewing and sortig the report in Microsoft Excel.
``` 
MultiMeta.odc
```

This file was created and preformatted with EXCEL 365 (current version 1912). 

For security reasons those files are and should be blocked by default. You have to allow the use per session.  
Read here for more:
https://support.microsoft.com/en-us/office/block-or-unblock-external-content-in-office-documents-10204ae0-0621-411f-b0d6-575b0847a795?ui=en-us&rs=en-us&ad=us



To customize it you need to edit Line 23:
  
  
Change path to HTML report here:
```
Quelle = Web.Page(File.Contents(&quot;file:///C:\MultiMeta\Tool\WORK\MultiMeta.html&quot;)
```

Change scanned paramterers (first row headers) here:
```  
File Size Duration Resolution FPS Scan-Type Format  
```
```
{&quot;File&quot;, type text}, {&quot;Size&quot;, type text}, {&quot;Duration&quot;, type time}, {&quot;Resolution&quot;, type text}, {&quot;FPS&quot;, Int64.Type}, {&quot;Scan-Type&quot;, type text}, {&quot;Format&quot;, type text}
```
