<#
.SYNOPSIS
    Uninstalls all locally-installed KoreForge templates.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

$templates = @(
    @{ Name = "koreforge-kafka-processor"; Path = Resolve-Path (Join-Path $repoRoot "..\apps\EventProcessor") },
    @{ Name = "koreforge-data";            Path = Join-Path $repoRoot "templates\koreforge-data" },
    @{ Name = "koreforge-odata";           Path = Join-Path $repoRoot "templates\koreforge-odata" }
)

foreach ($t in $templates) {
    Write-Host "Uninstalling $($t.Name): $($t.Path)" -ForegroundColor Cyan
    dotnet new uninstall $t.Path
    Write-Host ""
}
