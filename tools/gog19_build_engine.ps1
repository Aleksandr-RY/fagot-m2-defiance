# !!! SUPERSEDED 2026-10-28: historical master 34e2abd2 was corrupt (COFF machine byte
# !!! clobbered -> 0xc000007b Bad Image). Canonical patch definition = windows in
# !!! installers/v2.0.0_GOG19/INSTALL_LOGIC_v2.0.0_GOG19.ps1 (verified: LoadLibraryEx + both-path rehearsal).
# !!! Incident: journal/2026-10-28_badimage_machine_byte.md. History only - do NOT rebuild from 34e2abd2.
# ============================================================
# GOG19 variant-B engine generator
# Reads: stock GOG 1.9 logic.dll (da62ed73...) and dry master REV1.9.2
# (34e2abd2...), computes ALL diff windows (stock -> master), validates
# the 1.9.1-dry intermediate state (each window must match old OR new
# bytes there), and emits the installer engine ps1 with embedded table.
# ============================================================
$ErrorActionPreference = 'Stop'
$stockPath = 'D:\Games\Terminator Dark Fate - Defiance GOG 1.9\bin\logic.dll'
$masterPath = 'C:\Users\Aleksandr\Desktop\FagotM2_ARCHIVE\09_DELTA_PATCH\logic.dll.FagotM2_REV1.9.2_FOR_GOG19.dry.dll'
$dry191Path = 'C:\Users\Aleksandr\Desktop\FagotM2_ARCHIVE\09_DELTA_PATCH\logic.dll.FagotM2_REV1.9.1_FOR_GOG19.dry.dll'
$engineOut = 'C:\Users\Aleksandr\AppData\Local\Temp\opencode\INSTALL_LOGIC_REV1.9.2_GOG19.ps1'

$ShaFinal   = '34e2abd21c23bbed6f3a328f090f9832ccd67dbf32908492f6ee2f7010a13f86'
$ShaStock   = 'da62ed73b43fafa8af0f25fba0501bff641a0cfd1bfb0d3a0b8777a1b0d99271'
$ShaDry191  = 'ca63993645348280225c1f0e08749744f247e14d79570ef17cf2e26ccb716eb8'

$S = [System.IO.File]::ReadAllBytes($stockPath)
$M = [System.IO.File]::ReadAllBytes($masterPath)
$D = [System.IO.File]::ReadAllBytes($dry191Path)
$hs = (Get-FileHash -LiteralPath $stockPath -Algorithm SHA256).Hash.ToLower()
$hm = (Get-FileHash -LiteralPath $masterPath -Algorithm SHA256).Hash.ToLower()
$hd = (Get-FileHash -LiteralPath $dry191Path -Algorithm SHA256).Hash.ToLower()
if ($hs -ne $ShaStock) { throw ('stock sha mismatch: ' + $hs) }
if ($hm -ne $ShaFinal) { throw ('master sha mismatch: ' + $hm) }
if ($hd -ne $ShaDry191) { throw ('dry191 sha mismatch: ' + $hd) }
if ($S.Length -ne 9253648) { throw ('stock size ' + $S.Length) }
if ($M.Length -ne 9257984) { throw ('master size ' + $M.Length) }
Write-Host ('[1] masters ok. stock=' + $S.Length + ' master=' + $M.Length)

# diff runs between S and M (only over S.Length; beyond = tail)
$runs = New-Object System.Collections.Generic.List[object]
$i = 0
$stockLen = $S.Length
while ($i -lt $stockLen) {
    if ($S[$i] -ne $M[$i]) {
        $j = $i + 1
        while ($j -lt $stockLen -and $S[$j] -ne $M[$j]) { $j++ }
        $runs.Add(@{ o = $i; n = ($j - $i) })
        $i = $j
    } else { $i++ }
}
Write-Host ('[2] raw diff runs inside stock region: ' + $runs.Count)
# merge runs with gap < 8 bytes
$merged = New-Object System.Collections.Generic.List[object]
foreach ($r in $runs) {
    if ($merged.Count -gt 0) {
        $p = $merged[$merged.Count - 1]
        $gap = $r.o - ($p.o + $p.n)
        if ($gap -lt 8) {
            $merged[$merged.Count - 1] = @{ o = $p.o; n = ($r.o + $r.n - $p.o) }
            continue
        }
    }
    $merged.Add(@{ o = $r.o; n = $r.n })
}
Write-Host ('[3] merged windows: ' + $merged.Count)
$winRows = New-Object System.Collections.Generic.List[string]
$totBytes = 0
$badIntermed = 0
foreach ($r in $merged) {
    $old = ''; $new = ''
    for ($k = 0; $k -lt $r.n; $k++) { $old += $S[$r.o + $k].ToString('x2'); $new += $M[$r.o + $k].ToString('x2') }
    # intermediate state check: dry191 bytes must equal old OR new at this window
    $d191 = ''
    for ($k = 0; $k -lt $r.n; $k++) { $d191 += $D[$r.o + $k].ToString('x2') }
    if ($d191 -ne $old -and $d191 -ne $new) { $badIntermed++ }
    $totBytes += $r.n
    $winRows.Add(('    @{ off = ' + $r.o + '; old = ''' + $old + '''; new = ''' + $new + ''' }'))
}
Write-Host ('[4] window bytes total (in stock region): ' + $totBytes + ' / windows ' + $merged.Count + ' / intermediate-compatible: ' + ($badIntermed -eq 0))
if ($badIntermed -ne 0) { throw ('windows where dry191 matches neither old nor new: ' + $badIntermed) }
# tail: bytes in master beyond stock length (must ALL be appended bytes; dry191 must have identical tail if 1.9.1 flow was an extended file)
$tailLen = $M.Length - $stockLen
$tail = ''
$tailNonZero = 0
for ($k = $stockLen; $k -lt $M.Length; $k++) {
    $tail += $M[$k].ToString('x2')
    if ($M[$k] -ne 0) { $tailNonZero++ }
}
# dry191 tail must differ from master ONLY at the REV1.9.2 guard windows -> build tail windows (absolute offsets)
$tRuns = New-Object System.Collections.Generic.List[object]
$k = $stockLen
while ($k -lt $M.Length) {
    if ($D[$k] -ne $M[$k]) {
        $j = $k + 1
        while ($j -lt $M.Length -and $D[$j] -ne $M[$j]) { $j++ }
        $tRuns.Add(@{ o = $k; n = ($j - $k) })
        $k = $j
    } else { $k++ }
}
$twMerged = New-Object System.Collections.Generic.List[object]
foreach ($r in $tRuns) {
    if ($twMerged.Count -gt 0) {
        $p = $twMerged[$twMerged.Count - 1]
        if (($r.o - ($p.o + $p.n)) -lt 8) {
            $twMerged[$twMerged.Count - 1] = @{ o = $p.o; n = ($r.o + $r.n - $p.o) }
            continue
        }
    }
    $twMerged.Add(@{ o = $r.o; n = $r.n })
}
$twRows = New-Object System.Collections.Generic.List[string]
$twBytes = 0
foreach ($r in $twMerged) {
    $old = ''; $new = ''
    for ($k2 = 0; $k2 -lt $r.n; $k2++) { $old += $D[$r.o + $k2].ToString('x2'); $new += $M[$r.o + $k2].ToString('x2') }
    $twBytes += $r.n
    $twRows.Add(('    @{ off = ' + $r.o + '; old = ''' + $old + '''; new = ''' + $new + ''' }'))
}
Write-Host ('[5b] tail windows (dry191->master): ' + $twMerged.Count + ' windows, ' + $twBytes + ' B')

$wJoin = ($winRows -join "`r`n")
$twJoin = ($twRows -join "`r`n")
$engine = @"
# ============================================================
# Fagot-M2 REV1.9.2 - GOG 1.9 BYTE-PATCH installer (variant B)
# NO ready-made DLL: this engine edits bin\logic.dll in place.
# Accepted bases (SHA256):
#   da62ed73...  stock GOG 1.9 logic.dll   -> full chain + guard  (RECOMMENDED)
#   ca639936...  dry REV1.9.1 logic.dll    -> only REV1.9.2 guard windows
#   34e2abd2...  REV1.9.2 already installed -> nothing to do
# Result equals byte-for-byte the verified master:
#   34e2abd21c23bbed6f3a328f090f9832ccd67dbf32908492f6ee2f7010a13f86
# (9 257 984 B; stock 9 253 648 B + appended tail $tailLen B version)
# Full chain = 1.9.1 transfer windows + REV1.9.2 vtable range-guard
# (cave cave+0x940/0x980, guard imm 0x8DF000) - the same hotfix
# proven on v1.08.1173 (Schizo/Intercept use-after-free crash).
# ============================================================
`$ErrorActionPreference = 'Stop'

`$ShaFinal  = '$ShaFinal'
`$ShaStock  = '$ShaStock'
`$ShaDry191 = '$ShaDry191'
`$SizeStock = 9253648

# --- windows (off, old hex, new hex) stock -> REV1.9.2 ---
`$Windows = @(
$wJoin
)

# --- appended tail bytes (master region beyond stock length, $tailLen B) ---
`$TailHex = '$tail'
`$StockLen = $stockLen

# --- tail windows (dry REV1.9.1 -> REV1.9.2 master, absolute file offsets;
#     the flatten of the cave lives in the appended region) ---
`$TailWindows = @(
$twJoin
)

function Hex-Of([string]`$x) {
    if ((`$x.Length % 2) -ne 0) { throw ('odd hex length') }
    `$n = [int](`$x.Length / 2)
    `$b = New-Object byte[] `$n
    for (`$i = 0; `$i -lt `$n; `$i++) { `$b[`$i] = [byte][Convert]::ToUInt32(`$x.Substring(`$i * 2, 2), 16) }
    return `$b
}
function Hx([byte[]]`$b, [int]`$o, [int]`$n) { `$s = ''; for (`$i = `$o; `$i -lt (`$o + `$n); `$i++) { `$s += `$b[`$i].ToString('x2') }; return `$s }
function Hex4Spaces([string]`$x) {
    `$s = ''
    for (`$i = 0; `$i -lt `$x.Length; `$i += 2) { `$s += `$x.Substring(`$i, 2) + ' ' }
    return `$s.TrimEnd()
}
function Find-Bin {
    `$d = `$PSScriptRoot
    for (`$i = 0; `$i -lt 6; `$i++) {
        `$c = Join-Path `$d 'bin\logic.dll'
        if (Test-Path -LiteralPath `$c) { return (Split-Path -Parent `$c) }
        `$p = Split-Path -Parent `$d
        if ([string]`$p -eq [string]`$d) { break }
        `$d = `$p
    }
    return `$null
}

`$proc = Get-Process | Where-Object { `$_.ProcessName -match 'Terminator|Defiance' }
if (`$proc) {
    `$proc | ForEach-Object { Write-Host ('[BUSY] process: ' + `$_.ProcessName + ' (PID ' + `$_.Id + ')') }
    Write-Host '[ERROR] Game is running. Close it and run this installer again.'
    exit 3
}

`$Bin = Find-Bin
if (-not `$Bin) { Write-Host '[ERROR] bin\logic.dll not found (searched parents from script dir).'; exit 2 }
`$CurrentDll = Join-Path `$Bin 'logic.dll'
Write-Host ('[INFO] bin: ' + `$Bin)

`$Cur = (Get-FileHash -LiteralPath `$CurrentDll -Algorithm SHA256).Hash.ToLowerInvariant()
`$Len = (Get-Item -LiteralPath `$CurrentDll).Length
Write-Host ('[INFO] current logic.dll SHA256: ' + `$Cur)

if (`$Cur -eq `$ShaFinal) {
    Write-Host '[OK] REV1.9.2 is already installed. Nothing to do.'
    exit 0
}

`$Mode = ''
`$BakName = ''
if (`$Cur -eq `$ShaStock) {
    if (`$Len -ne `$SizeStock) { Write-Host ('[ERROR] stock size mismatch: ' + `$Len); exit 2 }
    `$Mode = 'STOCK'
    `$BakName = 'logic.dll.GOG19_stock.bak'
    Write-Host '[OK] recognized stock GOG 1.9 logic.dll (full chain: 1.9.1 + REV1.9.2 guard).'
} elseif (`$Cur -eq `$ShaDry191) {
    if (`$Len -ne 9257984) { Write-Host ('[ERROR] dry-1.9.1 size mismatch: ' + `$Len); exit 2 }
    `$Mode = 'DRY191'
    `$BakName = 'logic.dll.FagotM2_191dry_before_192.bak'
    Write-Host '[OK] recognized dry REV1.9.1 logic.dll (applying REV1.9.2 guard windows only).'
} else {
    Write-Host '[ERROR] logic.dll SHA256 unknown to this installer. Nothing was changed.'
    Write-Host ('[INFO] observed SHA256: ' + `$Cur)
    Write-Host '[HINT] This package only accepts stock GOG 1.9 logic.dll (da62ed73...).'
    exit 2
}

`$Bak = Join-Path `$Bin `$BakName
Copy-Item -LiteralPath `$CurrentDll -Destination `$Bak -Force
if ((Get-FileHash -LiteralPath `$Bak -Algorithm SHA256).Hash.ToLowerInvariant() -ne `$Cur) {
    Write-Host '[ERROR] backup verification failed.'
    exit 1
}
Write-Host ('[OK] backup: ' + `$Bak)

`$data = [System.IO.File]::ReadAllBytes(`$CurrentDll)
`$applied = 0
`$allWins = `$Windows
if (`$Mode -eq 'DRY191') { `$allWins = @() + `$Windows + `$TailWindows }

foreach (`$w in `$allWins) {
    `$nl = [int](`$w.new.Length / 2)
    `$got = Hx `$data `$w.off `$nl
    if (`$got -eq `$w.new) { continue }              # already REV1.9.2 content
    if (`$got -ne `$w.old) {
        Write-Host ('[ERROR] window 0x' + `$w.off.ToString('X') + ' neither old nor new. Refusing.')
        exit 2
    }
    `$pb = Hex-Of `$w.new
    [Array]::Copy(`$pb, 0, `$data, `$w.off, `$pb.Length)
    `$applied++
}

Write-Host (('[OK] windows applied: {0} / {1}' -f `$applied, `$allWins.Count))

if (`$Mode -eq 'STOCK') {
    `$tailB = Hex-Of `$TailHex
    `$grown = New-Object byte[] (`$StockLen + `$tailB.Length)
    [Array]::Copy(`$data, 0, `$grown, 0, `$StockLen)
    [Array]::Copy(`$tailB, 0, `$grown, `$StockLen, `$tailB.Length)
    `$data = `$grown
    Write-Host ('[OK] tail appended: ' + `$tailB.Length + ' B.')
}

`$Staging = Join-Path `$Bin 'logic.dll.FagotM2_192_staging'
[System.IO.File]::WriteAllBytes(`$Staging, `$data)
`$New = (Get-FileHash -LiteralPath `$Staging -Algorithm SHA256).Hash.ToLowerInvariant()
if (`$New -ne `$ShaFinal) {
    Write-Host ('[ERROR] staged copy SHA256 mismatch: ' + `$New)
    Remove-Item -LiteralPath `$Staging -Force
    exit 1
}
Write-Host ('[OK] staged copy verified, SHA256: ' + `$New)
Move-Item -LiteralPath `$Staging -Destination `$CurrentDll -Force
`$Post = (Get-FileHash -LiteralPath `$CurrentDll -Algorithm SHA256).Hash.ToLowerInvariant()
if (`$Post -ne `$ShaFinal) {
    Write-Host ('[ERROR] post-swap verification failed: ' + `$Post)
    exit 1
}
Write-Host '[OK] Fagot-M2 REV1.9.2 installed (GOG 1.9).'
Write-Host '[NEXT] In MODS menu enable the Fagot-M2 overrides if prompted by README; XML phase is separate.'
Write-Host '[BACK] Revert: RESTORE_GOG19.bat'
exit 0
"@
[System.IO.File]::WriteAllText($engineOut, $engine, [System.Text.Encoding]::UTF8)
Write-Host ('[6] engine written: ' + $engineOut + ' (' + (Get-Item -LiteralPath $engineOut).Length + ' B)')
