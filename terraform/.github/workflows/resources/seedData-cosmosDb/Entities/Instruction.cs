namespace SeedDataCosmosDb.Entities
{
    internal class Instruction
    {
        public string? ContainerName { get; set; }
        public string? PartitionKey { get; set; }
        public string? Action { get; set; }
    }
}