# KoreForge.Templates

NuGet template package providing `dotnet new` scaffolding for KoreForge applications and libraries.

## Available Templates

| Short name | Type | Description |
|---|---|---|
| `koreforge-kafka-processor` | Solution | Kafka consumer with Vue 3 dashboard, SignalR metrics, SQL live-reload settings, structured logging, health checks |
| `koreforge-data` | Solution | EF Core data library with database-first scaffolding, partial DbContext, options, and DI registration |
| `koreforge-odata` | Solution | OData controller library with Roslyn source-generated CRUD controllers from a DbContext |

## Install

```powershell
dotnet new install KoreForge.Templates
```

## Usage

### Kafka Processor

```powershell
dotnet new koreforge-kafka-processor -n MyApp --KafkaTopic orders --DatabaseName OrderDb
```

| Parameter | Default | Description |
|---|---|---|
| `-n` | _(required)_ | Application name (replaces `EventProcessor` everywhere) |
| `--KafkaTopic` | `transactions` | Kafka topic to consume |
| `--DatabaseName` | `FraudEngine` | SQL Server database name |

### Data Library

```powershell
dotnet new koreforge-data -n MyCompany.Data.Staff --DatabaseShort Staff
```

| Parameter | Default | Description |
|---|---|---|
| `-n` | _(required)_ | Project name and namespace (replaces `KoreForge.Data.Alerts`) |
| `--DatabaseShort` | `Alerts` | Short name for DbContext, options, methods (e.g. `Staff` → `StaffDbContext`) |

After scaffolding, edit `config/scaffold-config.json` with your connection string and schemas, then run:

```powershell
./scr/scaffold-db.ps1
```

### OData Library

```powershell
dotnet new koreforge-odata -n MyCompany.OData.Staff --DatabaseShort Staff --DataNamespace MyCompany.Data.Staff
```

| Parameter | Default | Description |
|---|---|---|
| `-n` | _(required)_ | Project name and namespace (replaces `KoreForge.OData.Alerts`) |
| `--DatabaseShort` | `Alerts` | Short name matching Data library (e.g. `Staff` → `StaffDbContext`) |
| `--DataNamespace` | `KoreForge.Data.Alerts` | Full namespace of the Data library where the DbContext lives |

After scaffolding, add a `ProjectReference` to your Data library in the `.csproj`, build, then run:

```powershell
./scr/scaffold-odata.ps1
```

---

## Development Workflow

### Template Sources

| Template | Source Location |
|---|---|
| `koreforge-kafka-processor` | `apps/EventProcessor/` (golden master — live app IS the template) |
| `koreforge-data` | `templates/koreforge-data/` (standalone template archetype) |
| `koreforge-odata` | `templates/koreforge-odata/` (standalone template archetype) |

### Local Development Install

```powershell
# Install all templates directly from source folders
./scr/install-local.ps1

# Test scaffolding
dotnet new koreforge-data -n TestData --DatabaseShort Test -o /tmp/TestData
dotnet new koreforge-odata -n TestOData --DatabaseShort Test --DataNamespace TestData -o /tmp/TestOData

# Uninstall when done
./scr/uninstall-local.ps1
```

### Pack and Release

1. Bump `PackageVersion` in `Directory.Build.props`
2. Run `scr/build-pack.ps1` → produces `artifacts/KoreForge.Templates.<version>.nupkg`
3. Publish to NuGet or let the GitHub Actions workflow handle Trusted Publishing


