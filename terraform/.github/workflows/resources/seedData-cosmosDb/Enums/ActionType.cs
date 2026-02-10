namespace SeedDataCosmosDb.Enums
{
    internal enum ActionType
    {
        upsert = 0,
        insert = 1,
        deleteAndLoad = 2,
        ignore = 3,
    }
}