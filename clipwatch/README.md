### Clipwatch

Genymotion has access to host's clipboard to be able to copy paste text to emulator. 
It is enabled by default. Malware can steal host's clipboard data just by using clipboardmonitorservice.
To use clipboardmonitorservice, apps doesnt need any permission. 

You can build this project or download [clipwatch.apk](clipwatch.apk) and test yourself.

Here is the demonstration [video](https://www.youtube.com/watch?v=Tod8Q6sf0P8)


I reported it to genymotion and they said `You can disable it` :man_shrugging:

Disputed CVE : [CVE-2021-27549](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-27549)
