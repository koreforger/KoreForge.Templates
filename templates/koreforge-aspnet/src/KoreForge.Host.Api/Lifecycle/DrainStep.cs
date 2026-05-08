using KoreForge.AppLifecycle.Flows;
using KoreForge.AppLifecycle.Hosting;

namespace KoreForge.Host.Api.Lifecycle;

public sealed class DrainStep : IFlowStep<ShutdownContext>
{
    public Task<FlowOutcome> ExecuteAsync(ShutdownContext context, CancellationToken cancellationToken)
    {
        return Task.FromResult(FlowOutcome.Success);
    }
}
