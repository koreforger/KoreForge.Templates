using KoreForge.AppLifecycle.Flows;
using KoreForge.AppLifecycle.Hosting;

namespace KoreForge.Host.Api.Lifecycle;

public sealed class BootstrapStep : IFlowStep<StartupContext>
{
    public Task<FlowOutcome> ExecuteAsync(StartupContext context, CancellationToken cancellationToken)
    {
        return Task.FromResult(FlowOutcome.Success);
    }
}
