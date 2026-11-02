@echo off
setlocal EnableExtensions

echo ============================================================
echo  Fagot-M2 v2.0.0 - GOG AUTO INSTALL (any supported build)
echo  [1/2] XML phase: species profiles + RU names (mod folder only)
echo  [2/2] Engine: bin\logic.dll in-place byte patch (no ready DLL)
echo  The engine installer detects your build automatically:
echo    - GOG 1.09.1223 (9,253,648 B)
echo    - older GOG 1.09 (Sep 2026, 9,212,928 B)
echo    - GOG 1.08.1173 (9,104,384 B)
echo  Anything else is refused - nothing is changed.
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
echo [2/2] Patching bin\logic.dll in place (auto-detected build)...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0INSTALL_LOGIC_v2.0.0_AUTO.ps1"
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
echo To revert the engine: RESTORE_GOG_AUTO.bat
echo.
pause
