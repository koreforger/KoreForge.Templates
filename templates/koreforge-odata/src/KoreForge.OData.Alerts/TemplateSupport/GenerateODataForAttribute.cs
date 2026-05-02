namespace KoreForge.OData.TemplateSupport;

[System.AttributeUsage(System.AttributeTargets.Assembly, AllowMultiple = true)]
public sealed class GenerateODataForAttribute : System.Attribute
{
    public GenerateODataForAttribute(System.Type contextType) => ContextType = contextType;

    public System.Type ContextType { get; }
}