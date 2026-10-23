# circuitpilot_check.ps1 - READ-ONLY checker for the "CircuitPilot" RAT and similar loaders.
# It does NOT delete or change anything. It only writes a report to your Desktop.
# Run in PowerShell as Administrator:
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Desktop\circuitpilot_check.ps1"
$out = "$env:USERPROFILE\Desktop\circuitpilot_report.txt"
$ErrorActionPreference = "SilentlyContinue"
$hits = 0
function T($t) { "`r`n===== $t =====" | Out-File $out -Append -Encoding utf8 }
function W($x) { $x | Out-String -Width 400 | Out-File $out -Append -Encoding utf8 }
function HIT($x) { $script:hits++; ("[!] " + $x) | Out-File $out -Append -Encoding utf8; Write-Host "[!] $x" -ForegroundColor Red }
"CircuitPilot check - $(Get-Date) - READ ONLY" | Out-File $out -Encoding utf8
Write-Host "Checking, please wait (a few minutes)..."

# Known file names seen in this infection (Oct 2026). Exact names only, to avoid false positives.
$known = "CircuitPilot.exe","C-Sil.exe","Crisp.exe","XPFix.exe","AltDriver_i386.lnk","profilerrelay67.conf","router-prof.conf","cache_mgr.lock"
$knownDirs = "base_cmd_system_net7","MgrMaintain"

T "1. Folders named like programs (e.g. C:\Users\you\bg.exe\)  - the main trick of this malware"
Get-ChildItem $env:USERPROFILE,$env:APPDATA,$env:LOCALAPPDATA,$env:ProgramData -Directory -Force |
  Where-Object { $_.Name -match '\.(exe|dll|scr)$' } | ForEach-Object {
    $exe = @(Get-ChildItem $_.FullName -Filter *.exe -File -Force -ErrorAction SilentlyContinue)
    $dll = @(Get-ChildItem $_.FullName -Filter *.dll -File -Force -ErrorAction SilentlyContinue)
    if ($exe.Count -gt 0 -and $dll.Count -gt 0) { HIT ("Folder named like a program, with a program inside: " + $_.FullName + "  created " + $_.CreationTime) }
    else { Write-Output ("(ok, no program inside) " + $_.FullName) } }

T "2. Known file names"
Get-ChildItem $env:USERPROFILE,$env:ProgramData -Include $known -Recurse -Force | ForEach-Object { HIT ("Known malware file: " + $_.FullName + "  created " + $_.CreationTime) }
foreach ($d in $knownDirs) { foreach ($root in $env:APPDATA,$env:LOCALAPPDATA,$env:ProgramData) {
  if (Test-Path "$root\$d") { HIT ("Known malware folder: $root\$d") } } }

T "3. Prefetch (proof that it ran at least once)"
Get-ChildItem "$env:windir\Prefetch\*.pf" | Where-Object { $_.Name -match '^(CIRCUITPILOT|C-SIL|CRISP|XPFIX)\.EXE' } |
  ForEach-Object { HIT ("It has RUN on this PC: " + $_.Name + "  first " + $_.CreationTime + "  last " + $_.LastWriteTime) }

T "4. Startup folders (shortcuts pointing into your user folder are suspicious)"
$sh = New-Object -ComObject WScript.Shell
foreach ($d in "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup","$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp") {
  Get-ChildItem $d -Force | ForEach-Object {
    $t = if ($_.Extension -eq ".lnk") { $sh.CreateShortcut($_.FullName).TargetPath } else { $_.FullName }
    $line = $_.Name + " -> " + $t + "  (" + $_.CreationTime + ")"
    if ($t -match '\.(exe|dll)\\' -or $t -match '\\Users\\[^\\]+\\[^\\]+\.exe\\') { HIT ("Startup shortcut into a fake folder: " + $line) } else { W $line } }
}

T "5. Registry Run keys"
foreach ($k in "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run","HKLM:\Software\Microsoft\Windows\CurrentVersion\Run","HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run") {
  $p = Get-ItemProperty $k
  if ($p) { $p.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
    $line = "[" + $k + "] " + $_.Name + " -> " + $_.Value
    if ($_.Value -match '\.(exe|dll)\\') { HIT ("Run key into a fake folder: " + $line) } else { W $line } } }
}

T "6. Scheduled tasks that start programs from user folders"
Get-ScheduledTask | ForEach-Object { $tk = $_; foreach ($a in $tk.Actions) {
  $e = [Environment]::ExpandEnvironmentVariables([string]$a.Execute)
  if ($e -match '\.(exe|dll)\\') { HIT ("Task into a fake folder: " + $tk.TaskPath + $tk.TaskName + " -> " + $e) }
  elseif ($e -match '\\Users\\|\\AppData\\|\\Temp\\') { W ($tk.TaskPath + $tk.TaskName + " -> " + $e + " " + $a.Arguments) } } }

T "7. Running processes from user folders"
Get-Process | Where-Object { $_.Path -match '\\Users\\|\\Temp\\' } | Sort-Object Path -Unique | ForEach-Object {
  if ($_.Path -match '\.(exe|dll)\\') { HIT ("RUNNING NOW from a fake folder: " + $_.Path) } else { W ($_.ProcessName + " -> " + $_.Path) } }

T "8. Defender exclusions (malware sometimes adds them)"
W (Get-MpPreference | Select ExclusionPath,ExclusionProcess,ExclusionExtension)

T "RESULT"
if ($hits -eq 0) { $r = "No signs of CircuitPilot found. Still run a Microsoft Defender Offline scan." }
else { $r = "$hits suspicious item(s) found, marked [!]. Read the guide before deleting anything." }
W $r
Write-Host "`n$r`nReport: circuitpilot_report.txt on your Desktop"
