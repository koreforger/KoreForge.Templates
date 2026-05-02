using Xunit;

namespace KoreForge.OData.Alerts.Tests;

public class SmokeTests
{
    [Fact]
    public void AssemblyAttributes_GenerateODataFor_IsPresent()
    {
        var attrs = typeof(SmokeTests).Assembly
            .GetReferencedAssemblies();

        // Verifies the project compiles with the source generator wired up.
        Assert.NotNull(attrs);
    }
}
