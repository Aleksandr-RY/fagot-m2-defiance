@echo off
setlocal EnableExtensions

echo ============================================================
echo  Fagot-M2 v2.0.0 - GOG 1.9 (legacy build) - FULL INSTALL
echo  Engine: REV1.9.2L (for GOG logic.dll 9,212,928 B / Sep 2026)
echo  [1/2] XML phase: species profiles + RU names (mod folder only)
echo  [2/2] Engine: bin\logic.dll in-place byte patch (no ready DLL)
echo ============================================================
echo.
echo For the CURRENT GOG build (1.09.1223, logic.dll 9,253,648 B)
echo use the main GOG19 package instead. This installer refuses
echo any other logic.dll build - nothing will be changed otherwise.
echo.
echo Close the game before continuing.
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
echo [2/2] Patching bin\logic.dll in place (REV1.9.2L legacy chain)...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0INSTALL_LOGIC_v2.0.0_GOG19_LEGACY.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] logic.dll installation stopped. See the error above.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo [DONE] Fagot-M2 v2.0.0 installed (XML + engine REV1.9.2L).
echo ============================================================
echo In the game MODS menu enable "Fagot-M2 FINAL 4 Modes v2.0.0".
echo Revert engine: RESTORE_GOG19_LEGACY.bat (XML lives in the mod folder).
echo.
pause
