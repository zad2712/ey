using SeedDataCosmosDb.Enums;

namespace SeedDataCosmosDb.Constants
{
    internal static class ContainerActionConstants
    {
        public static readonly Dictionary<string, string> Action = new()
        {
            { "pluginDirectory", ActionType.insert.ToString()},
            { "apiAgents", ActionType.insert.ToString()}
        };
    }
}