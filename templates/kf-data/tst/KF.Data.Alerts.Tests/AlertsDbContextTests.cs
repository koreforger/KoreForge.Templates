using Microsoft.EntityFrameworkCore;
using Xunit;

namespace KF.Data.Alerts.Tests;

public class AlertsDbContextTests
{
    [Fact]
    public void Context_CanBeCreated_WithSqlite()
    {
        var options = new DbContextOptionsBuilder<AlertsDbContext>()
            .UseSqlite("DataSource=:memory:")
            .Options;

        using var context = new AlertsDbContext(options);
        Assert.NotNull(context);
    }

    [Fact]
    public void Options_HasCorrectSectionName()
    {
        Assert.Equal("AlertsDb", AlertsDbOptions.SectionName);
    }
}
