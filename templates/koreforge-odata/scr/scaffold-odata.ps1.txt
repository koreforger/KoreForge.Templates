<#
.SYNOPSIS
    Creates placeholder partial controller files for OData CRUD customisation.

.DESCRIPTION
    Scans the compiled assembly for DbContext types and creates an empty partial
    controller file for each non-ignored DbSet entity that doesn't already have one.
    Run after the first successful build so the source generator has already
    produced the controller base classes.

.PARAMETER AssemblyPath
    Path to the compiled assembly (DLL) of this OData library project.
    Defaults to the first DLL found under the src project's bin/Debug/net10.0/.

.EXAMPLE
    .\scr\scaffold-odata.ps1
    .\scr\scaffold-odata.ps1 -AssemblyPath scr\\Release\net10.0\MyApp.OData.dll
#>
param(
    [string]$AssemblyPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectDir = Split-Path $PSScriptRoot -Parent
$srcDir = Get-ChildItem -Path (Join-Path $projectDir 'src') -Directory | Select-Object -First 1

if (-not $srcDir) {
    Write-Error "No src/ subdirectory found under $projectDir"
    return
}

if (-not $AssemblyPath) {
    $expectedDll = Join-Path $srcDir.FullName "scr\\Debug\net10.0\$($srcDir.Name).dll"
    if (Test-Path $expectedDll) {
        $AssemblyPath = $expectedDll
    } else {
        Write-Error "No compiled assembly found at $expectedDll. Run 'dotnet build' first."
        return
    }
}

if (-not (Test-Path $AssemblyPath)) {
    Write-Error "Assembly not found: $AssemblyPath"
    return
}

$controllersDir = Join-Path $srcDir.FullName 'Controllers'
if (-not (Test-Path $controllersDir)) {
    New-Item -ItemType Directory -Path $controllersDir | Out-Null
    Write-Host "Created $controllersDir"
}

$projectNamespace = $srcDir.Name

Write-Host "Scanning $AssemblyPath ..."
Write-Host ""

Add-Type -Path $AssemblyPath -ErrorAction Stop

$dbContextType = [AppDomain]::CurrentDomain.GetAssemblies() |
    ForEach-Object { try { $_.GetTypes() } catch { @() } } |
    Where-Object { $_.FullName -eq 'Microsoft.EntityFrameworkCore.DbContext' } |
    Select-Object -First 1

if (-not $dbContextType) {
    Write-Error "Could not find DbContext base type. Ensure EF Core is referenced."
    return
}

$asm = [System.Reflection.Assembly]::LoadFrom($AssemblyPath)
$contextTypes = $asm.GetTypes() | Where-Object { -not $_.IsAbstract -and $dbContextType.IsAssignableFrom($_) }

$created = 0
foreach ($ctx in $contextTypes) {
    foreach ($prop in $ctx.GetProperties()) {
        $pt = $prop.PropertyType
        if (-not $pt.IsGenericType) { continue }
        $gtd = $pt.GetGenericTypeDefinition()
        if ($gtd.FullName -ne 'Microsoft.EntityFrameworkCore.DbSet`1') { continue }

        $entityType = $pt.GetGenericArguments()[0]

        # Skip [ODataIgnore]
        $ignored = $entityType.GetCustomAttributes($true) |
            Where-Object { $_.GetType().Name -eq 'ODataIgnoreAttribute' }
        if ($ignored) { continue }

        $entityName = $entityType.Name
        $controllerName = "${entityName}Controller"
        $filePath = Join-Path $controllersDir "$controllerName.cs"

        if (Test-Path $filePath) {
            Write-Host "  SKIP  $controllerName.cs (already exists)"
            continue
        }

        $content = @"
namespace $projectNamespace.Controllers;

/// <summary>
/// Partial extension point for the generated $controllerName.
/// Add custom OData actions, function imports, or hook overrides here.
/// </summary>
public partial class $controllerName
{
}
"@

        $content | Set-Content -Path $filePath -Encoding UTF8
        Write-Host "  CREATE $controllerName.cs"
        $created++
    }
}

Write-Host ""
if ($created -gt 0) {
    Write-Host "$created controller stub(s) created in $controllersDir" -ForegroundColor Green
} else {
    Write-Host "No new controller stubs needed." -ForegroundColor Yellow
}

