# ============================================================
#  REV1.9.2 BUILDER
#  base = REV1.9.1 stable (1.08, sha 29eb0525...)  + 1.9 dry (ca639936...)
#  fix: vtable range-guard before both indirect vtable calls in the
#       cave "reset behavior NORMAL" tail (cave+0x90D call [rax+0xB0]
#       and cave+0x926 call [rax+0x80]) - use-after-free race when
#       the victim unit dies before the callback fires (schizo/takeover)
#  outputs:
#   - 06_ACTIVE_BUILD\logic.dll.FagotM2_REV1.9.2_1.08.dll   (master 1.08)
#   - 09_DELTA_PATCH\logic.dll.FagotM2_REV1.9.2_FOR_GOG19.dry.dll (master 1.9)
#   - console: final hashes + embedded hex tables for installer
# ============================================================
$ErrorActionPreference = 'Stop'
$arc = 'C:\Users\Aleksandr\Desktop\FagotM2_ARCHIVE'
$f108 = 'D:\Games\Terminator Dark Fate - Defiance v 1.08.1173\Terminator Dark Fate - Defiance\bin\logic.dll'
$f19d = Join-Path $arc '09_DELTA_PATCH\logic.dll.FagotM2_REV1.9.1_FOR_GOG19.dry.dll'

function Hex-B([string]$x) { $n = [int]($x.Length / 2); $b = New-Object byte[] $n; for ($i = 0; $i -lt $n; $i++) { $b[$i] = [byte][Convert]::ToUInt32($x.Substring($i * 2, 2), 16) }; return $b }
function H-B([byte[]]$b, [int]$o, [int]$n) { $s = ''; for ($i = $o; $i -lt ($o + $n); $i++) { $s += $b[$i].ToString('x2') }; return $s }
function Sha-B([byte[]]$b) { return [System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash($b)).Replace('-','').ToLowerInvariant() }

# ---------------- patch payload (cave-relative offsets) ----------------
# 0x90A: mov rax,[rcx] ; call [rax+0xB0]   -> jmp guard1
# 0x921: mov rax,[rcx] ; xor edx,edx ; call [rax+0x80] -> jmp guard2
# guard1 @0x940 (52 B), guard2 @0x980 (54 B); IMGEND baked per target
$s1old = '488b01ff90b0000000'
$s2old = '488b0131d2ff9080000000'
$p1    = 'e93100000090909090'
$p2    = 'e95a000000909090909090'

$z52  = ('0' * 104)
$z54  = ('0' * 108)

function Build-Guard([long]$imgEnd) {
    $sub = ('00 f0 {0:x2} 00' -f (($imgEnd -shr 16) -band 0xFF)).Replace(' ', '')
    $add = ('00 f0 {0:x2} 00' -f (($imgEnd -shr 16) -band 0xFF)).Replace(' ', '')
    return ('488b01' + '4c8d1d00000000' + '4981eb' + $sub + '4c39d8' + '7217' + '4981c3' + $add + '4c39d8' + '730b' + 'ff90b0000000' + 'e9a6ffffff' + '31c0' + 'e99fffffff')
}
function Build-Guard2([long]$imgEnd) {
    $sub = ('00 f0 {0:x2} 00' -f (($imgEnd -shr 16) -band 0xFF)).Replace(' ', '')
    $add = ('00 f0 {0:x2} 00' -f (($imgEnd -shr 16) -band 0xFF)).Replace(' ', '')
    return ('488b01' + '31d2' + '4c8d1d00000000' + '4981eb' + $sub + '4c39d8' + '7217' + '4981c3' + $add + '4c39d8' + '730b' + 'ff9080000000' + 'e97dffffff' + '31c0' + 'e976ffffff')
}

function Patch-One([byte[]]$src, [long]$caveRO, [long]$caveVA, [long]$imgEnd, [string]$label) {
    $g1 = Build-Guard $imgEnd
    $g2 = Build-Guard2 $imgEnd
    $zT = ('0' * (0x1000 - 0x931) * 2)
    # asserts: original bytes as expected
    $t1 = H-B $src ([int]($caveRO + 0x90A)) 9;  if ($t1 -ne $s1old) { throw ($label + ' site1 mismatch: ' + $t1) }
    $t2 = H-B $src ([int]($caveRO + 0x921)) 11; if ($t2 -ne $s2old) { throw ($label + ' site2 mismatch: ' + $t2) }
    $tc = H-B $src ([int]($caveRO + 0x900)) 10; if ($tc -ne '488b4c24304885c97422') { throw ($label + ' ctx-0x900 mismatch: ' + $tc) }
    $td = H-B $src ([int]($caveRO + 0x913)) 14; if ($td -ne '4885c07414488b48284885c9740b') { throw ($label + ' ctx-0x913 mismatch: ' + $td) }
    $te = H-B $src ([int]($caveRO + 0x92C)) 5;  if ($te -ne '4883c468c3') { throw ($label + ' ctx-0x92C mismatch: ' + $te) }
    # free tail must be all zeros (0x931..0xFFF)
    $tz = H-B $src ([int]($caveRO + 0x931)) 0x6CF -as [string]
    if ($tz -ne ('0' * (0x6CF * 2))) { throw ($label + ' cave tail 0x931..0xFFF is NOT clean zeros') }
    # apply
    $m = New-Object byte[] $src.Length
    [Array]::Copy($src, $m, $src.Length)
    foreach ($e in @(
        @{ o = 0x90A; h = $p1 }, @{ o = 0x921; h = $p2 },
        @{ o = 0x940; h = $g1 }, @{ o = 0x980; h = $g2 })) {
        $pb = Hex-B $e.h; $off = [int]($caveRO + $e.o)
        [Array]::Copy($pb, 0, $m, $off, $pb.Length)
    }
    # verify: exact bytes at the 4 windows + nothing changed outside them
    $windows = @(
        @{ o = 0x90A; n = 9;  h = $p1 }, @{ o = 0x921; n = 11; h = $p2 },
        @{ o = 0x940; n = 52; h = $g1 }, @{ o = 0x980; n = 54; h = $g2 })
    foreach ($w in $windows) {
        $got = H-B $m ([int]($caveRO + $w.o)) $w.n
        if ($got -ne $w.h) { throw ($label + ' verify window 0x' + $w.o.ToString('X') + ' bad: ' + $got) }
    }
    $outside = 0
    for ($i = 0; $i -lt $src.Length; $i++) {
        if ($src[$i] -ne $m[$i]) {
            $r = $i - $caveRO; $in = $false
            foreach ($w in $windows) { if ($r -ge $w.o -and $r -lt ($w.o + $w.n)) { $in = $true; break } }
            if (-not $in) { $outside++ }
        }
    }
    if ($outside -ne 0) { throw ($label + ' modifications outside the 4 cave windows: ' + $outside) }
    Write-Host ('[' + $label + '] 4 sites patched cleanly (9+11+52+54 = 126 bytes), cave tail intact')
    return ,@($m, $g1, $g2)
}

# ---------------- 1.08 target ----------------
$STK = [System.IO.File]::ReadAllBytes($f108)
$h = Get-FileHash -LiteralPath $f108 -Algorithm SHA256
if ($h.Hash.ToLower() -ne '29eb0525e947321a5a4bc2a5ce52a4dab4792b28e48717ca25b4827348346044') { throw ('1.08 bin hash mismatch: ' + $h.Hash) }
if ($STK.Length -ne 9108480) { throw ('1.08 bin size mismatch: ' + $STK.Length) }
Write-Host ('1.08 base ok: 29eb0525... , ' + $STK.Length + ' B; cave VA=0x8BF000 RO=0x8AEC00; img end=0x8BF000')

$res = Patch-One $STK 0x8AEC00 0x8BF000 0x8BF000 '1.08'
$m = $res[0]
$h208 = Sha-B $m
$out1 = Join-Path $arc '06_ACTIVE_BUILD\logic.dll.FagotM2_REV1.9.2_1.08.dll'
[System.IO.File]::WriteAllBytes($out1, $m)
Write-Host ('1.08 master written: ' + $out1)
Write-Host ('1.08 REV1.9.2 SHA256: ' + $h208)
Write-Host ('1.08 guard1 hex (caveRO+0x940): ' + $res[1])
Write-Host ('1.08 guard2 hex (caveRO+0x980): ' + $res[2])

# ---------------- 1.9 target ----------------
$D19 = [System.IO.File]::ReadAllBytes($f19d)
$h19 = Get-FileHash -LiteralPath $f19d -Algorithm SHA256
if ($h19.Hash.ToLower() -ne 'ca63993645348280225c1f0e08749744f247e14d79570ef17cf2e26ccb716eb8') { throw ('1.9 dry hash mismatch: ' + $h19.Hash) }
if ($D19.Length -ne 9257984) { throw ('1.9 dry size mismatch: ' + $D19.Length) }
Write-Host ('1.9 base ok: ca639936... , ' + $D19.Length + ' B; cave VA=0x8DF000 RO=0x8D3400; img end (STOCK)=0x8DF000')

$res19 = Patch-One $D19 0x8D3400 0x8DF000 0x8DF000 '1.9'
$m19 = $res19[0]
$h219 = Sha-B $m19
$out2 = Join-Path $arc '09_DELTA_PATCH\logic.dll.FagotM2_REV1.9.2_FOR_GOG19.dry.dll'
[System.IO.File]::WriteAllBytes($out2, $m19)
Write-Host ('1.9 master written: ' + $out2)
Write-Host ('1.9 REV1.9.2 dry SHA256: ' + $h219)
Write-Host ('1.9 guard1 hex (caveRO+0x940): ' + $res19[1])
Write-Host ('1.9 guard2 hex (caveRO+0x980): ' + $res19[2])
