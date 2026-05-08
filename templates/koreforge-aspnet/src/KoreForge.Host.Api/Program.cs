using KoreForge.AppLifecycle;
using KoreForge.Logging.Serilog;
using KoreForge.Metrics;
using KoreForge.Metrics.AspNet;
using KoreForge.Web.HealthChecks;
using KoreForge.Host.Api.Lifecycle;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddKFSerilogLogging();
builder.Services.AddKoreForgeMetrics();

builder.Services.AddApplicationLifecycleManager(opts =>
{
    opts.Startup
        .Flow("Bootstrap")
        .BeginWith<BootstrapStep>()
        .EndFlow();

    opts.Shutdown
        .Flow("Drain")
        .BeginWith<DrainStep>()
        .EndFlow();
});

builder.Services.AddHealthChecks();
builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();

app.UseApplicationLifecycleManager();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.MapKfHealthEndpoints();
app.MapMonitoringEndpoints();
app.MapControllers();

app.Run();

public partial class Program { }
