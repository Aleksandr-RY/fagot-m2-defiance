@echo off
setlocal EnableExtensions

echo ============================================================
echo  Fagot-M2 - revert engine patch (AUTO)
echo  Restores the most recent backup found in the game bin folder:
echo    logic.dll.GOG19_stock.bak / logic.dll.GOG19legacy_stock.bak /
echo    logic.dll.GOG108_stock.bak / logic.dll.broken192_before_repair.bak
echo ============================================================
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$d = $null; $root = Split-Path -Parent (Split-Path -Parent '%~dp0');" ^
  "for ($i = 0; $i -lt 6 -and -not $d; $i++) { $c = Join-Path $root 'bin\logic.dll'; if (Test-Path -LiteralPath $c) { $d = Split-Path -Parent $c } else { $root = Split-Path -Parent $root } };" ^
  "if (-not $d) { Write-Host '[ERROR] bin\logic.dll not found'; exit 1 }" ^
  "Write-Host ('[INFO] bin: ' + $d);" ^
  "$baks = Get-ChildItem -LiteralPath $d -Filter 'logic.dll.*.bak' -File | Sort-Object LastWriteTime -Descending;" ^
  "if (-not $baks) { Write-Host '[ERROR] no backups found in ' $d; exit 1 }" ^
  "$baks | ForEach-Object { Write-Host ('  backup found: ' + $_.Name) };" ^
  "$b = $baks[0];" ^
  "Write-Host ('[OK] restoring from: ' + $b.Name);" ^
  "Copy-Item -LiteralPath $b.FullName -Destination (Join-Path $d 'logic.dll') -Force;" ^
  "Write-Host ('[OK] restored, logic.dll SHA256: ' + (Get-FileHash -LiteralPath (Join-Path $d 'logic.dll') -Algorithm SHA256).Hash.ToLowerInvariant())"
echo.
pause
