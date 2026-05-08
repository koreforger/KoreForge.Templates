using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

namespace KoreForge.Host.Api.Tests;

public sealed class HealthEndpointTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public HealthEndpointTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task Health_live_returns_ok()
    {
        var client = _factory.CreateClient();
        var response = await client.GetAsync("/health/live");
        ((int)response.StatusCode).Should().Be(200);
    }

    [Fact]
    public async Task Health_ready_returns_ok()
    {
        var client = _factory.CreateClient();
        var response = await client.GetAsync("/health/ready");
        ((int)response.StatusCode).Should().Be(200);
    }
}
