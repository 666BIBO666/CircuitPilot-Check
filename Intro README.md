1) REDDIT POST  (r/computerhelp, r/techsupport)

Title: Got infected with "CircuitPilot" (RAT from a crack). Here's how I found and removed it + a free read-only check script

Hi all. My PC got infected, probably from a cracked program I downloaded in early April. Malwarebytes didn't detect it. I found it by hand, cleaned it, and wrote a small script to help other people check if they still have it.

Please read this first, I want to be honest:





I'm not a security expert. This is a small hobby tool, NOT an antivirus.



It has only been tested on one PC (mine), and only after I had already cleaned it.



It only reads your system. It does not delete or change anything.



The first version gave me 4 false alarms. I fixed them, but it may still flag harmless stuff on your PC. Read the "false alarms" section in the guide before deleting anything.



If you're infected, the safest fix is still: change passwords from another device, run Microsoft Defender Offline, and if in doubt reinstall Windows.

What the infection looked like on my PC:





Folders in C:\Users\<you>\ named like programs: bg.exe, og.exe, al.exe, bq.exe (they are folders, not files)



Inside: CircuitPilot.exe or C-Sil.exe, plus Up.dll, libssl-1_1.dll, and fake config files (profilerrelay67.conf, router-prof.conf)



AppData\Roaming\base_cmd_system_net7\Crisp.exe, AppData\Roaming\MgrMaintain\XPFix.exe, C:\ProgramData\base_cmd_system_net7\



A startup shortcut AltDriver_i386.lnk pointing to og.exe\CircuitPilot.exe



Symptom: a random DLL error popup at boot

Guide + script: [GitHub link]

If it finds something on your PC, or flags something that's clearly harmless, please tell me in the comments so I can improve it.



2) GITHUB README.md

CircuitPilot Check

A small read-only PowerShell script that looks for the traces of the "CircuitPilot" remote access trojan (RAT), found on a PC infected through a cracked program.

⚠️ Honest disclaimer





This is not an antivirus. It only looks for the exact files and patterns I found on my own PC.



Tested on one PC only (mine, Windows 11), after cleaning. It has never run on a still-infected machine other than my manual checks.



It changes nothing. It only reads and writes a report (circuitpilot_report.txt) on your Desktop.



False alarms are possible. The first version flagged 4 harmless folders on my PC. See below how to tell them apart.



A clean result does not guarantee your PC is clean. A RAT can download other malware with other names.

How to use





Download the zip → right-click → Extract All (don't run it from inside the zip).



Right-click RUN_CHECK.bat → Run as administrator → Yes.



Wait for DONE!. The report opens automatically.



Lines marked [!] in red are suspicious. Everything else is info.

False alarm or real? How to tell for sure

Examples from my own PC:







Found



Verdict



Why





C:\Users\<you>\og.exe\CircuitPilot.exe



🔴 MALWARE



A folder named .exe in your user folder, with an unsigned program + DLLs inside, created the same minute as other weird files





C:\Users\<you>\al.exe\C-Sil.exe + Up.dll



🔴 MALWARE



Same pattern; bq.exe was an identical backup copy





AltDriver_i386.lnk in Startup



🔴 MALWARE



Pointed to og.exe\CircuitPilot.exe





AppData\Roaming\MgrMaintain\XPFix.exe



🔴 MALWARE



Random name, no known publisher, created 6 minutes after the infection





Ableton, Ollama, SignalRGB folders



🟢 FALSE ALARM



Signed by real companies, installed by me, normal install paths





Scheduled task WindowsActionDialog



🟢 FALSE ALARM



Real Windows task: it runs C:\Windows\System32\WindowsActionDialog.exe. My manual search caught it only because the name contains "og.exe"





Peace.lnk in Startup



🟢 FALSE ALARM



Equalizer APO (audio equalizer) in C:\Program Files\EqualizerAPO\





Files named Crisp... (Arturia, Ableton, Photoshop presets)



🟢 FALSE ALARM



Just presets with a similar name

The 5 checks to be certain (do them all before deleting anything):





Digital signature: right-click the .exe → Properties → Digital Signatures. A real company (Microsoft, Adobe, Valve…) = almost always safe. No tab / unknown name = suspicious. PowerShell: Get-AuthenticodeSignature "path\file.exe"



Location: real programs live in C:\Program Files, C:\Program Files (x86), C:\Windows. A folder named something.exe directly in your user folder is never normal.



Creation date: if several unknown files were created in the same few minutes, and that matches when you downloaded something shady, that's a strong sign.



Do you recognize it? If you installed it yourself (your DAW, game launcher, RGB software) it's probably fine.



VirusTotal: upload the file (or its hash) to virustotal.com. Several engines flagging it = malware. Tip: Get-FileHash "path\file.exe" gives the hash, so you don't need to upload private files.

Rule: only delete something when at least checks 1, 2 and 5 say "suspicious". If unsure, ask in the issues before deleting. Never delete things in C:\Windows.

If you are infected





From your phone, change passwords (email first, then bank/PayPal, Steam, Discord…) and enable 2FA.



Follow GUIDE_CircuitPilot.md to remove the files.



Run Microsoft Defender Offline (Windows Security → Virus & threat protection → Scan options).



If anything comes back, reinstall Windows. It's the only 100% sure fix.

License

Free to use and share. No warranty: use at your own risk.
