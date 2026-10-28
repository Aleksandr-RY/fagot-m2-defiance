@echo off
setlocal EnableExtensions
cd /d "%~dp0"
for %%I in ("%~dp0..") do set "BIN=%%~fI\bin"

echo ============================================================
echo  Fagot-M2 GOG 1.9: revert bin\logic.dll to previous state
echo ============================================================
echo.
echo Close the game before continuing.
echo.
pause

if exist "%BIN%\logic.dll.GOG19_stock.bak" (
  copy /y "%BIN%\logic.dll.GOG19_stock.bak" "%BIN%\logic.dll" >nul
  echo [OK] Restored: original stock GOG 1.9 logic.dll
  pause
  exit /b 0
)
if exist "%BIN%\logic.dll.FagotM2_191dry_before_192.bak" (
  copy /y "%BIN%\logic.dll.FagotM2_191dry_before_192.bak" "%BIN%\logic.dll" >nul
  echo [OK] Restored: dry REV1.9.1 logic.dll
  pause
  exit /b 0
)

echo [ERROR] No backup found in %BIN%.
echo If the patch was never installed, logic.dll is already original.
pause
exit /b 1
