<#
.SYNOPSIS
    Packs KoreForge.Templates into a versioned .nupkg in the artifacts/ folder.
.PARAMETER Version
    Version to stamp on the package (e.g. 0.0.2-alpha).
    Defaults to the version in Directory.Build.props.
#>
[CmdletBinding()]
param(
    [string]$Version
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$csproj = Join-Path $PSScriptRoot "..\KoreForge.Templates.csproj"
$artifactsDir = Join-Path $PSScriptRoot "..\artifacts"

if (Test-Path $artifactsDir) {
    Remove-Item $artifactsDir -Recurse -Force
}

$packArgs = @(
    "pack", $csproj,
    "--configuration", "Release"
)

if ($Version) {
    $packArgs += "/p:PackageVersion=$Version"
}

Write-Host "Packing KoreForge.Templates…" -ForegroundColor Cyan
dotnet @packArgs

if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$pkg = Get-ChildItem -Path $artifactsDir -Filter "*.nupkg" | Select-Object -First 1
if ($pkg) {
    Write-Host ""
    Write-Host "✓ $($pkg.Name)" -ForegroundColor Green
    Write-Host ""
    Write-Host "To install locally:" -ForegroundColor Cyan
    Write-Host "  dotnet new install $($pkg.FullName)" -ForegroundColor White
    Write-Host ""
    Write-Host "To publish to NuGet:" -ForegroundColor Cyan
    Write-Host "  dotnet nuget push $($pkg.FullName) --source nuget.org --api-key <key>" -ForegroundColor White
}
