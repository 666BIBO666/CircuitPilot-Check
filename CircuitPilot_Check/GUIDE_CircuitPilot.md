# "CircuitPilot.exe – amd_ags_x64.dll was not found": how I found and removed a RAT without reinstalling Windows

**Symptom:** a popup keeps appearing: *"CircuitPilot.exe – The code execution cannot proceed because amd_ags_x64.dll was not found."* You never installed CircuitPilot.

That popup is good news in disguise: the malware is trying to start and failing. But it is a **remote access trojan (RAT) loader**, and it may have run before. Below is exactly what I found on my PC and how I cleaned it.

> I am not a security company. This is a real case, written to help. If anything here differs on your PC, stop and ask in a security forum (e.g. r/computerhelp, BleepingComputer) before deleting.

---

## 0. First, from your PHONE (not the PC)
Change passwords for email, bank/PayPal, Steam/Epic/Discord, cloud storage. Turn on two-factor authentication. Check "recent logins" on email and bank. A RAT can see what you type.

## 1. Run the read-only checker
1. Download `circuitpilot_check.ps1` to your Desktop. **Open it in Notepad and read it first** – never run a script you can't read. It only *reads*; it deletes nothing.
2. Open **PowerShell as Administrator** and paste:
   ```
   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Desktop\circuitpilot_check.ps1"
   ```
3. Lines marked **[!]** are suspicious. A report is saved as `circuitpilot_report.txt` on the Desktop.

## 2. What this infection looked like (my case)
| Where | What | Meaning |
|---|---|---|
| `C:\Users\<you>\bg.exe\` and `og.exe\` | **folders** named like programs, containing `CircuitPilot.exe`, `cache_mgr.lock`, `profilerrelay67.conf` | the RAT, two copies |
| `C:\Users\<you>\al.exe\` and `bq.exe\` | folders with `C-Sil.exe`, `Up.dll`, `router-prof.conf`, `libssl-1_1.dll`, Microsoft runtime DLLs | second component, two copies |
| `%APPDATA%\base_cmd_system_net7\Crisp.exe` and `C:\ProgramData\base_cmd_system_net7\` | exe + SSL DLLs | network component |
| `%APPDATA%\MgrMaintain\XPFix.exe` | exe | another component |
| Startup folder: `AltDriver_i386.lnk` | shortcut → `...\og.exe\CircuitPilot.exe` | how it restarted at every boot |
| `C:\Windows\Prefetch\CIRCUITPILOT.EXE-*.pf` | Windows log of launches | proof it **ran**, with first/last date |

All files had creation times **within the same few minutes**. Look at that date: it tells you which download brought it (in my case, a cracked game/software download). Malwarebytes did **not** detect it.

## 3. Removal (only after the checker confirms the same items)
Replace `<you>` with your user name. One line at a time, PowerShell as Administrator:
```
Stop-Process -Name CircuitPilot,C-Sil,Crisp,XPFix -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\AltDriver_i386.lnk" -Force
Remove-Item "C:\Users\<you>\bg.exe","C:\Users\<you>\og.exe","C:\Users\<you>\al.exe","C:\Users\<you>\bq.exe" -Recurse -Force
Remove-Item "$env:APPDATA\base_cmd_system_net7","$env:APPDATA\MgrMaintain","C:\ProgramData\base_cmd_system_net7" -Recurse -Force
```
Your folder names may be different (other random letters + `.exe`). Delete only what the checker marked **[!]**.

### ⚠️ Do NOT delete
- `WindowsActionDialog` scheduled task / `WindowsActionDialog.exe` – a real Windows file. Searching for "og.exe" matches "Dial**og.exe**" – that's a false positive I hit myself.
- Startup items you recognise (audio drivers, Steam, OneDrive, equalizers...).
- The `.pf` file in Prefetch – it's just a log, harmless.
- **Never** download `amd_ags_x64.dll` from "DLL download" sites to "fix" the popup – you would help the malware start.

## 4. After cleaning
1. Reboot – the popup must be gone.
2. Run the checker again – it should report 0 items.
3. **Microsoft Defender Offline scan:** Windows Security → Virus & threat protection → Scan options → Microsoft Defender Offline.
4. Remove Defender exclusions you don't need (cracked games often ask you to add them – that's the open door).
5. Optional: **Autoruns** (only from microsoft.com/sysinternals) → Options → Scan Options → Check VirusTotal.com. Investigate anything with red detections.

## 5. Do I have to reinstall Windows?
Reinstalling is the only **100% certain** option, because a RAT that ran could have downloaded other things. But if the checker, Defender Offline and Autoruns are all clean, the popup is gone and your accounts show no strange logins, keeping your Windows is a reasonable choice. If anything comes back, back up your projects and reinstall.

## 6. Don't get it again
Avoid cracks, repacks from unofficial mirrors, "free" cheat tools and torrent clients bundled with adware. Fake sites of well-known repackers exist; the real one is not the first Google result.

---
*Shared free to help others. No warranty. The script is read-only on purpose: an automatic "remover" can delete real Windows files.*
