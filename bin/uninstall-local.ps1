<#
.SYNOPSIS
    Uninstalls all locally-installed KoreForge templates.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

$templates = @(
    @{ Name = "kf-kafka-processor"; Path = Resolve-Path (Join-Path $repoRoot "..\apps\EventProcessor") },
    @{ Name = "kf-data";            Path = Join-Path $repoRoot "templates\kf-data" },
    @{ Name = "kf-odata";           Path = Join-Path $repoRoot "templates\kf-odata" }
)

foreach ($t in $templates) {
    Write-Host "Uninstalling $($t.Name): $($t.Path)" -ForegroundColor Cyan
    dotnet new uninstall $t.Path
    Write-Host ""
}
