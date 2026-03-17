<#
.SYNOPSIS
    Uninstalls the locally-installed KafkaProcessor template.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$templateSource = Resolve-Path (Join-Path $PSScriptRoot "..\..\apps\EventProcessor")
Write-Host "Uninstalling template: $templateSource" -ForegroundColor Cyan
dotnet new uninstall $templateSource
