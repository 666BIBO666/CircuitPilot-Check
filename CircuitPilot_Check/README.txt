CIRCUITPILOT CHECK - read-only, it does NOT delete or change anything.

1. Right-click the zip > Extract All.
2. Open the extracted folder.
3. RIGHT-click RUN_CHECK.bat > Run as administrator > Yes.
   ("Windows protected your PC": More info > Run anyway)
4. Green window: wait for DONE. The report folder opens by itself.
   - Yellow window = not run as administrator.
   - Red window    = opened inside the zip, or an error.
5. Read circuitpilot_report.txt on your Desktop:
   - No [!] lines: no CircuitPilot found. Still run Defender Offline.
   - Red [!] lines: follow GUIDE_CircuitPilot.md, step 3.
     Delete ONLY what is marked [!]. Prefetch (.pf) files are just logs.

BEFORE cleaning: change passwords FROM YOUR PHONE, enable 2FA.
Never download "missing DLLs" from DLL sites.
After cleaning: reboot, run the check again, then Defender Offline
(Windows Security > Virus & threat protection > Scan options).
If anything comes back: back up your files and reinstall Windows.
On someone else's PC: always ask the owner first.
