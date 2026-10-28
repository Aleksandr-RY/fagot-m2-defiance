@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ============================================================
echo  Fagot-M2 v2.0.0 for GOG 1.9 - FULL INSTALL
echo  [1/2] XML phase: species profiles + RU names (mod folder only)
echo  [2/2] Engine: bin\logic.dll in-place byte patch (no ready DLL)
echo  Engine revision REV1.9.2 (crash hotfix proven on 1.08)
echo ============================================================
echo.
echo Close the game before continuing.
echo.
pause

echo.
echo [1/2] Preparing XML overrides (extracts stock XML from game PAKs,
echo       applies Fagot-M2 profiles, writes them into this mod folder)...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0PREPARE_XML_v2.0.0_GOG19.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] XML phase stopped. See the error above. logic.dll was NOT changed.
  pause
  exit /b 1
)

echo.
echo [2/2] Patching bin\logic.dll in place...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0INSTALL_LOGIC_v2.0.0_GOG19.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] logic.dll installation stopped. See the error above.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo [DONE] Fagot-M2 v2.0.0 installed (XML + engine).
echo ============================================================
echo In the game MODS menu enable "Fagot-M2 FINAL 4 Modes v2.0.0".
echo Revert engine: RESTORE_GOG19.bat (XML lives only in the mod folder).
echo.
pause
