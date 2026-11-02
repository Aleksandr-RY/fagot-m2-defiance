@echo off
setlocal EnableExtensions
cd /d "%~dp0"
echo ============================================================
echo  Fagot-M2 - revert engine patch (legacy GOG build REV1.9.2L)
echo  Restores bin\logic.dll from logic.dll.GOG19legacy_stock.bak
echo ============================================================
if not exist "..\..\bin\logic.dll.GOG19legacy_stock.bak" (
  echo [ERROR] backup not found: ..\..\bin\logic.dll.GOG19legacy_stock.bak
  pause
  exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$b = Join-Path (Join-Path (Split-Path -Parent (Split-Path -Parent '%~dp0')) 'bin') 'logic.dll'; $bak = Join-Path (Split-Path -Parent $b) 'logic.dll.GOG19legacy_stock.bak'; Copy-Item -LiteralPath $bak -Destination (Join-Path (Split-Path -Parent $b) 'logic.dll') -Force; $h = (Get-FileHash -LiteralPath $b -Algorithm SHA256).Hash.ToLowerInvariant(); Write-Host ('[OK] restored, logic.dll SHA256: ' + $h)"
echo.
pause
