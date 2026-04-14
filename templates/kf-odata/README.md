# KF.OData.Alerts

A KoreForge OData controller library that generates CRUD controllers from `AlertsDbContext` via Roslyn source generator.

## Prerequisites

- A KoreForge Data library project with a scaffolded DbContext (see `kf-data` template)
- KoreForge.OData and KoreForge.OData.Generators NuGet packages

## Quick Start

1. **Add a project reference** to your Data library in `src/KF.OData.Alerts/KF.OData.Alerts.csproj`:
   ```xml
   <ItemGroup>
     <ProjectReference Include="..\..\path\to\KF.Data.Alerts\KF.Data.Alerts.csproj" />
   </ItemGroup>
   ```

2. **Build** the solution:
   ```
   dotnet build
   ```
   The source generator automatically creates OData controllers for each `DbSet<T>` in `AlertsDbContext`.

3. **Scaffold partial controllers** for customisation:
   ```powershell
   ./scripts/scaffold-odata.ps1
   ```

4. **Register OData** in your host application:
   ```csharp
   builder.Services.AddKoreForgeOData(typeof(AlertsDbContext).Assembly);
   ```

## Project Structure

| Path | Purpose |
|------|---------|
| `src/KF.OData.Alerts/AssemblyAttributes.cs` | Wires `[GenerateODataFor(typeof(AlertsDbContext))]` |
| `src/KF.OData.Alerts/Controllers/` | Partial controller extensions (hand-edited) |
| `scripts/scaffold-odata.ps1` | Generates partial controller stubs after first build |
| `tst/KF.OData.Alerts.Tests/` | Unit tests |

## How It Works

The `KoreForge.OData.Generators` Roslyn source generator reads `[GenerateODataFor]` assembly attributes at compile time and emits a full CRUD controller for each `DbSet<T>` entity in the referenced DbContext. Controllers support:

- GET (list + by key), POST, PUT, PATCH, DELETE
- OData query options ($filter, $select, $expand, $orderby, $top, $skip)
- Schema-aware routing (entities in named schemas get route prefixes)
- Row-level filtering via `IRowLevelFilterProvider`
- Virtual hooks for pre/post processing
