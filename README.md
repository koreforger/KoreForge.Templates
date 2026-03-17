# KoreForge.Templates

NuGet template package providing `dotnet new` scaffolding for KoreForge applications.

## Available templates

| Short name | Description |
|---|---|
| `kf-kafka-processor` | Kafka consumer with Vue 3 dashboard, SignalR metrics, SQL live-reload settings, structured logging, health checks |

## Usage

### Install from NuGet

```powershell
dotnet new install KoreForge.Templates
```

### Scaffold a new application

```powershell
# Minimal — renames everything from EventProcessor → MyApp
dotnet new kf-kafka-processor -n MyApp

# With explicit Kafka topic and database name
dotnet new kf-kafka-processor -n OrderProcessor --KafkaTopic orders --DatabaseName OrderDb
```

After scaffolding:

```powershell
cd MyApp
dotnet restore
cd dashboard && npm install && cd ..
```

### Parameters

| Parameter | Default | Description |
|---|---|---|
| `-n / --name` | _(required)_ | Application name. Replaces `EventProcessor` everywhere — files, folders, namespaces, appsettings. |
| `--KafkaTopic` | `transactions` | Kafka topic to consume from. |
| `--DatabaseName` | `FraudEngine` | SQL Server database name in the connection string. |

---

## Development workflow — maintaining the templates

The template source is the **EventProcessor** app itself (`apps/EventProcessor/`).  
The app is the golden master; the template pack just wraps it.

```
apps/EventProcessor/           ← live app AND template source
    .template.config/
        template.json          ← template definition (params, exclusions)

KoreForge.Templates/
    KoreForge.Templates.csproj ← NuGet pack project (references EventProcessor files)
    Directory.Build.props      ← version
    bin/
        install-local.ps1      ← install template directly from source folder
        uninstall-local.ps1
        pack.ps1               ← produce .nupkg → artifacts/
```

### Improve and release a new version

1. Improve `apps/EventProcessor/` (fix, add feature, improve dashboard…)
2. Bump `PackageVersion` in `Directory.Build.props`
3. Run `bin/pack.ps1` → produces `artifacts/KoreForge.Templates.<version>.nupkg`
4. Publish to NuGet: `dotnet nuget push artifacts/*.nupkg --source nuget.org --api-key <key>`
5. Commit, tag, push

### Local development install (no NuGet publish required)

```powershell
# Install directly from the source folder — picks up live changes
./bin/install-local.ps1

# Test scaffolding
dotnet new kf-kafka-processor -n TestApp -o /tmp/TestApp

# Uninstall when done
./bin/uninstall-local.ps1
```
