@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ============================================================
echo  Fagot-M2 DIAG - collect info about logic.dll and game build
echo  Read-only: NOTHING will be changed on this PC.
echo ============================================================
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0DIAG_LOGIC_GOG19.ps1"
