# ============================================================
# Fagot-M2 diagnosis helper - prints a support card for the
# author about bin\logic.dll and the game build on this PC.
# Read-only: nothing is patched, renamed or deleted.
# Output: console + FagotM2_diag.txt next to this script.
# ============================================================
$ErrorActionPreference = 'SilentlyContinue'
$ModRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# Same walk-up logic as the installer: find the game root (with bin\).
$probe = $ModRoot
$GameRoot = $null
for ($i = 0; $i -lt 6; $i++) {
    $c = Join-Path $probe 'bin\logic.dll'
    if (Test-Path -LiteralPath $c) { $GameRoot = $probe; break }
    $up = Split-Path -Parent $probe
    if ([string]$up -eq [string]$probe) { break }
    $probe = $up
}

if (-not $GameRoot) {
    Write-Host '[ERROR] bin\logic.dll not found from this script folder.'
    Write-Host '        Run this DIAG from inside the mod folder: mods\<mod folder>\DIAG_LOGIC_GOG19.bat'
    pause
    exit 2
}

$Dll = Join-Path $GameRoot 'bin\logic.dll'
$L = (Get-Item -LiteralPath $Dll).Length
$H = (Get-FileHash -LiteralPath $Dll -Algorithm SHA256).Hash.ToLowerInvariant()

Write-Host '============================================================'
Write-Host ' Fagot-M2 DIAG (Fagot-M2 DIAG card)'
Write-Host '============================================================'
Write-Host (" game root      : " + $GameRoot)
Write-Host (" logic.dll size : " + $L + " bytes")
Write-Host (" logic.dll sha  : " + $H)
Write-Host (" game exe       : trm.exe " + (((Get-Item -LiteralPath (Join-Path $GameRoot 'bin\trm.exe')).Length)) + " bytes")

Write-Host ''
Write-Host ' pak files in game root (fingerprint of the game build):'
Get-ChildItem -LiteralPath $GameRoot -Filter '*.pak' -File | Sort-Object Name | ForEach-Object {
    Write-Host ("   " + $_.Name + "  " + $_.Length + " B")
}

Write-Host ''
Write-Host ' installed Fagot-M2 saves / mods folders:'
Get-ChildItem -LiteralPath (Join-Path $GameRoot 'mods') -Directory | Sort-Object Name | ForEach-Object {
    Write-Host ("   mods\" + $_.Name)
}

Write-Host ''
Write-Host '============================================================'
Write-Host ' Copy/PASTE the text above (or attach FagotM2_diag.txt)'
Write-Host ' to the mod author. Nothing on this PC was changed.'
Write-Host '============================================================'

$lines = @(
    'Fagot-M2 DIAG',
    ('game root      : ' + $GameRoot),
    ('logic.dll size : ' + $L + ' bytes'),
    ('logic.dll sha  : ' + $H),
    ('pak files      :'), ((Get-ChildItem -LiteralPath $GameRoot -Filter '*.pak' -File | Sort-Object Name | ForEach-Object { '  ' + $_.Name + '  ' + $_.Length + ' B' }) -join [Environment]::NewLine),
    ('mods folders   :'), ((Get-ChildItem -LiteralPath (Join-Path $GameRoot 'mods') -Directory | Sort-Object Name | ForEach-Object { '  mods\' + $_.Name }) -join [Environment]::NewLine)
)
Out-File -FilePath (Join-Path $ModRoot 'FagotM2_diag.txt') -InputObject ($lines -join [Environment]::NewLine) -Encoding UTF8
Write-Host ('[OK] saved: ' + (Join-Path $ModRoot 'FagotM2_diag.txt'))
pause
