@echo off
title CIRCUITPILOT CHECK
color 0A
cd /d "%~dp0"
cls
echo ==================================================
echo    CIRCUITPILOT CHECK  -  read-only, deletes nothing
echo ==================================================
echo.
if not exist "%~dp0circuitpilot_check.ps1" (
  color 0C
  echo [ERROR] circuitpilot_check.ps1 not found.
  echo.
  echo You opened this file from INSIDE the zip.
  echo Close, right-click the zip ^> "Extract All",
  echo then open the extracted folder and try again.
  echo.
  pause
  exit /b
)
net session >nul 2>&1
if errorlevel 1 (
  color 0E
  echo [STEP 1] Administrator rights are needed.
  echo.
  echo Close this window, then:
  echo   RIGHT-click RUN_CHECK.bat
  echo   ^> "Run as administrator" ^> Yes
  echo.
  pause
  exit /b
)
echo [STEP 2] Checking. This takes a few minutes.
echo          Do NOT close this window.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0circuitpilot_check.ps1"
echo.
if exist "%USERPROFILE%\Desktop\circuitpilot_report.txt" (
  color 0A
  echo ==================================================
  echo   DONE!  Report saved on your Desktop:
  echo   circuitpilot_report.txt
  echo.
  echo   RED [!] lines = suspicious. Read GUIDE_CircuitPilot.md
  echo   No [!] lines   = no CircuitPilot found.
  echo ==================================================
  start "" explorer /select,"%USERPROFILE%\Desktop\circuitpilot_report.txt"
) else (
  color 0C
  echo [ERROR] The report was not created.
  echo Take a screenshot of this window and ask for help.
)
echo.
pause
