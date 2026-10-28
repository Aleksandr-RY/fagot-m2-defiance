# ============================================================
# Fagot-M2 v2.0.0 GOG 1.9 - XML PHASE BUILDER (PREPARE)
# Extracts the stock species XML from the GOG 1.9 PAKs, applies the
# Fagot-M2 profiles (same rules as the proven 1.08 PREPARE) and writes
# the overrides INSIDE this mod folder only. Game PAKs are not touched.
# Outputs:
#   basis\scripts\species\{ammunition,emp,guns,squads,squad_upgrades}.xml
#   basis\predefinedSaves\globalMap.sav        (shipped as-is, verified)
#   dlc\{Legion,Resistance,Canada}\basis\scripts\species\*.xml
#   dlc\{...}\localization\ru\basis_ru\locale\ammunition.xml (when present)
#   localization\ru\basis_ru\locale\ammunition.xml
# Idempotent: re-run reproduces the same result from stock PAKs.
# ============================================================
$ErrorActionPreference = 'Stop'
$ModRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$GameRoot = [System.IO.Path]::GetFullPath((Join-Path $ModRoot '..\..'))
$SS = 'urn:schemas-microsoft-com:office:spreadsheet'

if (-not (Test-Path -LiteralPath (Join-Path $GameRoot 'basis.pak'))) {
    throw ('Game root not found (no basis.pak): ' + $GameRoot)
}
Write-Host ('[INFO] mod root: ' + $ModRoot)
Write-Host ('[INFO] game root: ' + $GameRoot)

function Find-7Zip {
    $candidates = New-Object System.Collections.Generic.List[string]
    $cmd = Get-Command 7z.exe -ErrorAction SilentlyContinue
    if ($cmd -and $cmd.Source) { [void]$candidates.Add([string]$cmd.Source) }
    if ($env:ProgramFiles) {
        $p = Join-Path $env:ProgramFiles '7-Zip\7z.exe'
        if (Test-Path -LiteralPath $p) { [void]$candidates.Add([string]$p) }
    }
    $pf86 = ${env:ProgramFiles(x86)}
    if ($pf86) {
        $p = Join-Path $pf86 '7-Zip\7z.exe'
        if (Test-Path -LiteralPath $p) { [void]$candidates.Add([string]$p) }
    }
    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) { return [string]$candidate }
    }
    throw '7z.exe not found. Install 7-Zip or add it to PATH.'
}
$Seven = [string](Find-7Zip)
Write-Host ('[OK] 7-Zip: ' + $Seven)
= '<REDACTED - set the game PAK password here; never commit the real value>'
Write-Host '[OK] Game PAK password loaded.'

function Get-ArchiveContains([string]$Archive, [string]$Entry) {
    if (-not (Test-Path -LiteralPath $Archive)) { return $false }
    $out = & $Seven l -slt "-p$PakPass" $Archive $Entry 2>$null
    if ($LASTEXITCODE -ne 0) { return $false }
    $target = ($Entry -replace '\\','/').ToLowerInvariant()
    foreach ($line in $out) {
        if ($line -match '^Path = (.+)$') {
            $p = ($Matches[1] -replace '\\','/').ToLowerInvariant()
            if ($p -eq $target) { return $true }
        }
    }
    return $false
}

function Find-EffectiveArchive([string]$Folder, [string]$Entry) {
    $archives = @()
    $basis = Join-Path $Folder 'basis.pak'
    if (Test-Path -LiteralPath $basis) { $archives += (Get-Item -LiteralPath $basis).FullName }
    $archives += Get-ChildItem -LiteralPath $Folder -Filter 'patch_*.pak' -File -ErrorAction SilentlyContinue | Sort-Object Name | ForEach-Object { $_.FullName }
    $selected = $null
    foreach ($a in $archives) {
        if (Get-ArchiveContains $a $Entry) { $selected = $a }
    }
    return $selected
}

function Extract-Entry([string]$Archive,[string]$Entry,[string]$TempRoot) {
    if (Test-Path -LiteralPath $TempRoot) { Remove-Item -LiteralPath $TempRoot -Recurse -Force }
    New-Item -ItemType Directory -Path $TempRoot -Force | Out-Null
    & $Seven x -y "-p$PakPass" "-o$TempRoot" $Archive $Entry | Out-Null
    if ($LASTEXITCODE -ne 0) { throw ('7-Zip failed to extract ' + $Entry + ' from ' + $Archive) }
    $p = Join-Path $TempRoot ($Entry -replace '/','\')
    if (-not (Test-Path -LiteralPath $p)) { throw ('Not found after extract: ' + $p) }
    return $p
}

function New-NsMgr([xml]$Doc) {
    $ns = New-Object System.Xml.XmlNamespaceManager($Doc.NameTable)
    $ns.AddNamespace('ss',$SS)
    return ,$ns
}
function Get-CellMap($Row,$Ns) {
    $map = @{}; $col = 1
    foreach ($cell in $Row.SelectNodes('ss:Cell',$Ns)) {
        $idx = $cell.GetAttribute('Index',$SS)
        if ($idx) { $col = [int]$idx }
        $map[$col] = $cell; $col++
    }
    return $map
}
function Get-CellText($Row,[int]$Col,$Ns) {
    $m = Get-CellMap $Row $Ns
    if (-not $m.ContainsKey($Col)) { return $null }
    $d = $m[$Col].SelectSingleNode('ss:Data',$Ns)
    if ($null -eq $d) { return $null }
    return $d.InnerText
}
function Set-CellText($Row,[int]$Col,[string]$Text,$Ns,[string]$Type='String') {
    $m = Get-CellMap $Row $Ns
    if (-not $m.ContainsKey($Col)) { throw ('Row has no column ' + $col + '; patch stopped safely.') }
    $cell = $m[$Col]
    $d = $cell.SelectSingleNode('ss:Data',$Ns)
    if ($null -eq $d) {
        $d = $Row.OwnerDocument.CreateElement('Data',$SS)
        [void]$cell.AppendChild($d)
    }
    [void]$d.SetAttribute('Type',$SS,$Type)
    $d.InnerText = $Text
}
function Get-HeaderMap($Table,$Ns) {
    foreach ($row in $Table.SelectNodes('ss:Row',$Ns)) {
        if ((Get-CellText $row 1 $Ns) -eq 'sysname') {
            $h=@{}; $m=Get-CellMap $row $Ns
            foreach ($k in $m.Keys) { $t=Get-CellText $row $k $Ns; if ($t) { $h[$t]=[int]$k } }
            return $h
        }
    }
    return $null
}
function Find-RowBySysname($Table,[string]$Name,$Ns) {
    foreach ($row in $Table.SelectNodes('ss:Row',$Ns)) {
        if ((Get-CellText $row 1 $Ns) -eq $Name) { return $row }
    }
    return $null
}
function Inc-RowCount($Table,[int]$Delta) {
    $v=$Table.GetAttribute('ExpandedRowCount',$SS)
    if ($v) { [void]$Table.SetAttribute('ExpandedRowCount',$SS,([int]$v+$Delta).ToString()) }
}

$AmmoIds = @('fagot_m2_emp','fagot_m2_schizo','fagot_m2_takeover')
$Profiles = @(
    @{ Ammo='fagot_m2_emp'; Profile='fagot_m2_emp_profile'; LifeTime='0.8'; Radius='30'; Comment='Fagot-M2 EMP: radius=30; life_time=0.8; EMP only, 45s suspended' },
    @{ Ammo='fagot_m2_schizo'; Profile='fagot_m2_schizo_profile'; LifeTime='0.9'; Radius='30'; Comment='Fagot-M2 Schizo: radius=30; life_time=0.9 signature; exact victim -> player_ally' },
    @{ Ammo='fagot_m2_takeover'; Profile='fagot_m2_takeover_profile'; LifeTime='1.0'; Radius='30'; Comment='Fagot-M2 Takeover: radius=30; life_time=1.0 signature; exact victim -> player team' }
)

function Patch-Ammunition([string]$Path) {
    [xml]$doc = New-Object System.Xml.XmlDocument
    $doc.PreserveWhitespace=$true; $doc.Load($Path); $ns=New-NsMgr $doc
    foreach ($table in $doc.SelectNodes('//ss:Table',$ns)) {
        $hdr=Get-HeaderMap $table $ns
        if (-not $hdr -or -not $hdr.ContainsKey('bullet_type')) { continue }
        $base=Find-RowBySysname $table 'inf_atm' $ns
        if ($null -eq $base) { continue }
        $after=$base; $added=0
        foreach ($p in $Profiles) {
            if ($null -ne (Find-RowBySysname $table $p.Ammo $ns)) { continue }
            $r=$base.CloneNode($true)
            Set-CellText $r $hdr['sysname'] $p.Ammo $ns
            if ($hdr.ContainsKey('comments')) { Set-CellText $r $hdr['comments'] $p.Comment $ns }
            if ($hdr.ContainsKey('comment')) { Set-CellText $r $hdr['comment'] $p.Comment $ns }
            Set-CellText $r $hdr['shot_start_velocity'] '50' $ns 'Number'
            Set-CellText $r $hdr['min_shot_angle'] '0' $ns 'Number'
            Set-CellText $r $hdr['max_shot_angle'] '0' $ns 'Number'
            Set-CellText $r $hdr['bullet_type'] 'emp' $ns
            Set-CellText $r $hdr['rocket'] $p.Profile $ns
            [void]$table.InsertAfter($r,$after); $after=$r; $added++
        }
        if ($added) { Inc-RowCount $table $added }
    }
    $doc.Save($Path)
}

function Patch-Emp([string]$Path) {
    [xml]$doc=New-Object System.Xml.XmlDocument
    $doc.PreserveWhitespace=$true; $doc.Load($Path); $ns=New-NsMgr $doc
    foreach ($table in $doc.SelectNodes('//ss:Table',$ns)) {
        $hdr=Get-HeaderMap $table $ns
        if (-not $hdr -or -not $hdr.ContainsKey('radius') -or -not $hdr.ContainsKey('life_time')) { continue }
        $base=Find-RowBySysname $table 'small_emp' $ns
        if ($null -eq $base) { continue }
        $after=$base; $added=0
        foreach ($p in $Profiles) {
            $r=Find-RowBySysname $table $p.Profile $ns
            if ($null -eq $r) {
                $r=$base.CloneNode($true)
                Set-CellText $r $hdr['sysname'] $p.Profile $ns
                [void]$table.InsertAfter($r,$after); $after=$r; $added++
            }
            Set-CellText $r $hdr['life_time'] $p.LifeTime $ns 'Number'
            Set-CellText $r $hdr['radius'] $p.Radius $ns 'Number'
            if ($hdr.ContainsKey('suspension_duration')) { Set-CellText $r $hdr['suspension_duration'] '45' $ns 'Number' }
        }
        if ($added) { Inc-RowCount $table $added }
    }
    $doc.Save($Path)
}

function Append-AmmoList([string]$Old,[bool]$WithCount) {
    $tokens=@()
    if ($Old) { $tokens += ($Old.Trim() -split '\s+') | Where-Object { $_ } }
    foreach ($id in $AmmoIds) {
        $exists=$false
        foreach($t in $tokens) { if (($t -split ':')[0] -eq $id) { $exists=$true; break } }
        if (-not $exists) { $tokens += $(if($WithCount){"$id`:4"}else{$id}) }
    }
    return ($tokens -join ' ')
}

function Patch-Guns([string]$Path) {
    [xml]$doc=New-Object System.Xml.XmlDocument
    $doc.PreserveWhitespace=$true; $doc.Load($Path); $ns=New-NsMgr $doc
    foreach ($table in $doc.SelectNodes('//ss:Table',$ns)) {
        $hdr=Get-HeaderMap $table $ns
        if (-not $hdr -or -not $hdr.ContainsKey('ammunition')) { continue }
        $r=Find-RowBySysname $table 'inf_javelin' $ns
        if ($null -eq $r) { continue }
        Set-CellText $r $hdr['ammunition'] (Append-AmmoList (Get-CellText $r $hdr['ammunition'] $ns) $true) $ns
        if ($hdr.ContainsKey('ammunition_upgraded')) {
            Set-CellText $r $hdr['ammunition_upgraded'] (Append-AmmoList (Get-CellText $r $hdr['ammunition_upgraded'] $ns) $true) $ns
        }
    }
    $doc.Save($Path)
}

function Patch-SquadLike([string]$Path) {
    [xml]$doc=New-Object System.Xml.XmlDocument
    $doc.PreserveWhitespace=$true; $doc.Load($Path); $ns=New-NsMgr $doc
    foreach ($table in $doc.SelectNodes('//ss:Table',$ns)) {
        $hdr=Get-HeaderMap $table $ns
        if (-not $hdr -or -not $hdr.ContainsKey('gun_mounts_special') -or -not $hdr.ContainsKey('ammunition')) { continue }
        foreach ($r in $table.SelectNodes('ss:Row',$ns)) {
            $g=Get-CellText $r $hdr['gun_mounts_special'] $ns
            if (-not $g -or $g -notmatch 'inf_javelin') { continue }
            Set-CellText $r $hdr['ammunition'] (Append-AmmoList (Get-CellText $r $hdr['ammunition'] $ns) $false) $ns
        }
    }
    $doc.Save($Path)
}

function Patch-LocalizationAmmo([string]$Path) {
    [xml]$doc=New-Object System.Xml.XmlDocument
    $doc.PreserveWhitespace=$true; $doc.Load($Path); $ns=New-NsMgr $doc
    $names=@{
        'fagot_m2_emp'='Фагот-М2 «ЭМИ»'
        'fagot_m2_schizo'='Фагот-М2 «Шизофреник»'
        'fagot_m2_takeover'='Фагот-М2 «Перехват»'
    }
    foreach ($table in $doc.SelectNodes('//ss:Table',$ns)) {
        $hdr=Get-HeaderMap $table $ns
        if (-not $hdr) { continue }
        $base=Find-RowBySysname $table 'inf_atm' $ns
        if ($null -eq $base) { continue }
        $nameCol = if ($hdr.ContainsKey('name')) { $hdr['name'] } else { 2 }
        $after=$base; $added=0
        foreach($id in $AmmoIds) {
            if ($null -ne (Find-RowBySysname $table $id $ns)) { continue }
            $r=$base.CloneNode($true)
            Set-CellText $r 1 $id $ns
            Set-CellText $r $nameCol $names[$id] $ns
            [void]$table.InsertAfter($r,$after); $after=$r; $added++
        }
        if ($added) { Inc-RowCount $table $added }
    }
    $doc.Save($Path)
}

$SpeciesJobs = @(
    @{ entry='scripts/species/ammunition.xml';     kind='ammo' }
    @{ entry='scripts/species/emp.xml';            kind='emp' }
    @{ entry='scripts/species/guns.xml';           kind='guns' }
    @{ entry='scripts/species/squads.xml';         kind='squads' }
    @{ entry='scripts/species/squad_upgrades.xml'; kind='upgrades' }
)

function Apply-Species([string]$Arc,[string]$Entry,[string]$Kind,[string]$DstDir) {
    $temp=Join-Path $env:TEMP ('FagotM2_v200_' + $Kind)
    $ex=Extract-Entry $Arc $Entry $temp
    New-Item -ItemType Directory -Path $DstDir -Force | Out-Null
    $dst=Join-Path $DstDir (Split-Path $Entry -Leaf)
    Copy-Item -LiteralPath $ex $dst -Force
    switch($Kind) {
        'ammo'     { Patch-Ammunition $dst }
        'emp'      { Patch-Emp $dst }
        'guns'     { Patch-Guns $dst }
        'squads'   { Patch-SquadLike $dst }
        'upgrades' { Patch-SquadLike $dst }
    }
    if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    Write-Host ('[OK] ' + $DstDir + '\' + (Split-Path $Entry -Leaf) + '  (' + $Kind + ')')
}

# ---------------- base species (game root paks) ----------------
foreach ($j in $SpeciesJobs) {
    $arc = Find-EffectiveArchive $GameRoot $j.entry
    if (-not $arc) { Write-Host ('[WARN] base ' + $j.entry + ' not found in any pak - SKIPPED'); continue }
    Apply-Species $arc $j.entry $j.kind (Join-Path $ModRoot 'basis\scripts\species')
}

# ---------------- base RU localization ----------------
$baseLocPak = Join-Path $GameRoot 'localization\ru\basis_ru.pak'
if (Test-Path -LiteralPath $baseLocPak) {
    $entry='locale/ammunition.xml'
    if (Get-ArchiveContains $baseLocPak $entry) {
        $temp=Join-Path $env:TEMP 'FagotM2_v200_baseloc'
        $ex=Extract-Entry $baseLocPak $entry $temp
        $dst=Join-Path $ModRoot 'localization\ru\basis_ru\locale\ammunition.xml'
        New-Item -ItemType Directory -Path (Split-Path $dst -Parent) -Force | Out-Null
        Copy-Item -LiteralPath $ex $dst -Force; Patch-LocalizationAmmo $dst
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
        Write-Host '[OK] base RU localization: Fagot-M2 names added'
    } else { Write-Host '[WARN] locale/ammunition.xml not found in basis_ru.pak' }
} else { Write-Host '[WARN] base localization\ru\basis_ru.pak not found' }

# ---------------- DLC species + loc ----------------
function Prepare-Dlc([string]$FolderName) {
    $srcRoot = Join-Path $GameRoot ('dlc\' + $FolderName)
    if (-not (Test-Path -LiteralPath $srcRoot)) { Write-Host ('[SKIP] DLC ' + $FolderName + ' not found'); return }
    foreach ($j in $SpeciesJobs) {
        $arc = Find-EffectiveArchive $srcRoot $j.entry
        if (-not $arc) { continue }
        Apply-Species $arc $j.entry $j.kind (Join-Path $ModRoot ('dlc\' + $FolderName + '\basis\scripts\species'))
    }
    $locPak = Join-Path $srcRoot 'localization\ru\basis_ru.pak'
    if (Test-Path -LiteralPath $locPak) {
        $entry='locale/ammunition.xml'
        if (Get-ArchiveContains $locPak $entry) {
            $temp=Join-Path $env:TEMP ('FagotM2_v200_' + $FolderName + '_loc')
            $ex=Extract-Entry $locPak $entry $temp
            $dst=Join-Path $ModRoot ('dlc\' + $FolderName + '\localization\ru\basis_ru\locale\ammunition.xml')
            New-Item -ItemType Directory -Path (Split-Path $dst -Parent) -Force | Out-Null
            Copy-Item -LiteralPath $ex $dst -Force; Patch-LocalizationAmmo $dst
            if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
            Write-Host ('[OK] ' + $FolderName + ': RU names')
        }
    }
}
Prepare-Dlc 'Legion'
Prepare-Dlc 'Resistance'
Prepare-Dlc 'Canada'

# ---------------- predefined save (shipped payload, verified) ----------------
$sav = Join-Path $ModRoot 'basis\predefinedSaves\globalMap.sav'
$savSha = '5dac11842b8883295d00fad40c671999f1b9a2c47274836069a26317638bf8e2'
if (Test-Path -LiteralPath $sav) {
    $h=(Get-FileHash -LiteralPath $sav -Algorithm SHA256).Hash.ToLower()
    if ($h -eq $savSha) { Write-Host '[OK] predefinedSaves\globalMap.sav: payload verified' }
    else { Write-Host ('[WARN] globalMap.sav sha mismatch: ' + $h) }
} else { Write-Host '[WARN] globalMap.sav payload missing (predefined map will use game stock)' }

# ---------------- final verification ----------------
$fail = 0
function Test-Row([string]$Path,[string]$Sys) {
    if (-not (Test-Path -LiteralPath $Path)) { Write-Host ('[FAIL] missing file: ' + $Path); $script:fail++; return }
    [xml]$doc=New-Object System.Xml.XmlDocument
    $doc.Load($Path); $ns=New-NsMgr $doc
    $found=$false
    foreach ($table in $doc.SelectNodes('//ss:Table',$ns)) {
        if ($null -ne (Find-RowBySysname $table $Sys $ns)) { $found=$true; break }
    }
    if ($found) { Write-Host ('[PASS] ' + (Split-Path $Path -Leaf) + ' contains ' + $Sys) }
    else { Write-Host ('[FAIL] ' + (Split-Path $Path -Leaf) + ' lacks ' + $Sys); $script:fail++ }
}
function Test-SquadAmmo([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { Write-Host ('[FAIL] missing file: ' + $Path); $script:fail++; return }
    [xml]$doc=New-Object System.Xml.XmlDocument
    $doc.Load($Path); $ns=New-NsMgr $doc
    $found=$false
    foreach ($table in $doc.SelectNodes('//ss:Table',$ns)) {
        $hdr=Get-HeaderMap $table $ns
        if (-not $hdr -or -not $hdr.ContainsKey('gun_mounts_special') -or -not $hdr.ContainsKey('ammunition')) { continue }
        foreach ($r in $table.SelectNodes('ss:Row',$ns)) {
            $g=Get-CellText $r $hdr['gun_mounts_special'] $ns
            if (-not $g -or $g -notmatch 'inf_javelin') { continue }
            $a=Get-CellText $r $hdr['ammunition'] $ns
            if ($a -and $a -match 'fagot_m2_schizo') { $found=$true; break }
        }
        if ($found) { break }
    }
    if ($found) { Write-Host ('[PASS] ' + (Split-Path $Path -Leaf) + ': inf_javelin mount row carries fagot ammo') }
    else { Write-Host ('[FAIL] ' + (Split-Path $Path -Leaf) + ': no inf_javelin row carries fagot ammo'); $script:fail++ }
}
Test-Row (Join-Path $ModRoot 'basis\scripts\species\ammunition.xml') 'fagot_m2_schizo'
Test-Row (Join-Path $ModRoot 'basis\scripts\species\emp.xml') 'fagot_m2_schizo_profile'
Test-Row (Join-Path $ModRoot 'basis\scripts\species\guns.xml') 'inf_javelin'
Test-SquadAmmo (Join-Path $ModRoot 'basis\scripts\species\squads.xml')
Test-SquadAmmo (Join-Path $ModRoot 'basis\scripts\species\squad_upgrades.xml')
Test-Row (Join-Path $ModRoot 'localization\ru\basis_ru\locale\ammunition.xml') 'fagot_m2_schizo'
if ($fail -ne 0) { throw ('Verification failed: ' + $fail + ' check(s)') }
Write-Host '[DONE] XML phase complete. Game PAKs untouched; overrides live in the mod folder only.'