<#
SYNC_TO_YANDEX.ps1 — зеркалит текущее состояние репозитория на Яндекс Диск
(облачный путь: _Upload/Fagot-M2/repo). Папка .git не копируется.

Запуск из корня репы:
    powershell -ExecutionPolicy Bypass -File .\SYNC_TO_YANDEX.ps1

Дома буква диска Яндекса может отличаться — тогда:
    powershell -ExecutionPolicy Bypass -File .\SYNC_TO_YANDEX.ps1 -Drive Y
#>
param([string]$Drive = 'N')

$ErrorActionPreference = 'Stop'
$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$dst = "$($Drive):\_Upload\Fagot-M2\repo"

if (-not (Test-Path "$($Drive):\")) {
    throw "Диск $($Drive): не найден — Яндекс Диск не подключён?"
}

robocopy $src $dst /MIR /XD .git /NFL /NDL /NJH /NJS /NP | Out-Null
if ($LASTEXITCODE -ge 8) {
    throw "robocopy завершился с кодом $LASTEXITCODE (>=8 — ошибка)"
}

$cnt = (Get-ChildItem $dst -Recurse -File).Count
Write-Host "OK: зеркало обновлено -> $dst ($cnt файлов)"
