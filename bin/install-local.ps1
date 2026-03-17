<#
.SYNOPSIS
    Installs the KafkaProcessor template directly from the local EventProcessor source folder.
    No pack step required — changes to the source are immediately available.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$templateSource = Resolve-Path (Join-Path $PSScriptRoot "..\..\apps\EventProcessor")
Write-Host "Installing template from: $templateSource" -ForegroundColor Cyan
dotnet new install $templateSource
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓ Template installed. Scaffold a new app with:" -ForegroundColor Green
    Write-Host "  dotnet new kf-kafka-processor -n MyApp" -ForegroundColor White
}
