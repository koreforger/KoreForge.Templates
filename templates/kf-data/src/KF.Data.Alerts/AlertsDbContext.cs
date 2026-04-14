using Microsoft.EntityFrameworkCore;

namespace KF.Data.Alerts;

/// <summary>
/// EF Core context for the AlertsDB database.
/// Scaffold-generated entities will extend this partial class.
/// Run <c>scripts/scaffold-db.ps1</c> after configuring your database.
/// </summary>
public partial class AlertsDbContext : DbContext
{
    public AlertsDbContext(DbContextOptions<AlertsDbContext> options)
        : base(options)
    {
    }

    // DbSet<T> properties and OnModelCreating will be added by scaffold output
    // in the Generated/ folder. Add custom partial-method overrides here.
}
