# KoreForge.Data.Alerts

A KoreForge data library for the AlertsDB database, built with EF Core database-first scaffolding.

## Quick Start

1. **Configure your database** — edit `config/scaffold-config.json` with your connection string, schemas, and tables.

2. **Install EF Core tools** (if not already installed):
   ```
   dotnet tool install --global dotnet-ef
   ```

3. **Scaffold entities**:
   ```powershell
   ./scr/scaffold-db.ps1
   ```

4. **Build**:
   ```
   dotnet build
   ```

5. **Register in your application**:
   ```csharp
   services.AddAlertsDb(o => o.ConnectionString = connectionString);
   ```

## Project Structure

| Path | Purpose |
|------|---------|
| `src/KoreForge.Data.Alerts/AlertsDbContext.cs` | Partial DbContext — hand-edited, survives re-scaffold |
| `src/KoreForge.Data.Alerts/AlertsDbOptions.cs` | Connection options bound from config |
| `src/KoreForge.Data.Alerts/AlertsDbServiceCollectionExtensions.cs` | DI registration extensions |
| `src/KoreForge.Data.Alerts/Generated/` | Scaffold output — do not edit by hand |
| `config/scaffold-config.json` | Scaffold configuration (connection, schemas, tables) |
| `scr/scaffold-db.ps1` | Scaffold automation script |
| `tst/KoreForge.Data.Alerts.Tests/` | Unit tests |

## Scaffold Configuration

Edit `config/scaffold-config.json` to configure:
- **connectionString** — your SQL Server connection string
- **schemas** — which database schemas to include (empty = all)
- **tables** — specific tables to include (empty = all in schemas)
- **outputDir / contextDir** — where generated files go
- **namespace / contextNamespace** — C# namespaces for generated code

Re-run `scr/scaffold-db.ps1` whenever the database schema changes.

