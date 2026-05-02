<#
.SYNOPSIS
    Installs all KoreForge templates directly from local source folders.
    No pack step required — changes to the source are immediately available.
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
    Write-Host "Installing $($t.Name) from: $($t.Path)" -ForegroundColor Cyan
    dotnet new install $t.Path
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to install $($t.Name)"
    }
    Write-Host ""
}

Write-Host "Done. Available templates:" -ForegroundColor Green
dotnet new list kf
