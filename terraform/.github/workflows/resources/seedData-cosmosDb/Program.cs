using Microsoft.Azure.Cosmos;
using SeedDataCosmosDb.Constants;
using SeedDataCosmosDb.Entities;
using SeedDataCosmosDb.Enums;
using System.Net;
using System.Text.Json;
using Container = Microsoft.Azure.Cosmos.Container;

namespace SeedDataCosmosDb
{
    public class Program
    {
        static async Task Main(string[] args)
        {
            string connectionString = args[0];
            string databaseName = args[1];
            string jsonFolderPath = args[2];
            //string jsonFilePath = args[3];
            //string containerInput = File.ReadAllText(jsonFilePath);

            CosmosClient client = new CosmosClient(connectionString);
            Database database = await client.CreateDatabaseIfNotExistsAsync(databaseName);
            var containerProfile = new List<Instruction>();

            var containerInstructions = JsonSerializer.Deserialize<List<Instruction>>(File.ReadAllText($"{jsonFolderPath}/instructions.json")) ?? [];

            foreach (var filePath in Directory.GetFiles(jsonFolderPath, "*.json").Where(file => !Path.GetFileName(file).Equals("instructions.json", StringComparison.OrdinalIgnoreCase)))
            {
                string fileName = Path.GetFileNameWithoutExtension(filePath);
                ContainerActionConstants.Action.TryGetValue(fileName, out string? value);

                containerProfile.Add(new Instruction
                {
                    ContainerName = fileName,
                    PartitionKey = containerInstructions.FirstOrDefault(i => i.ContainerName == fileName)?.PartitionKey ?? "/id",
                    Action = value ?? containerInstructions.FirstOrDefault(i => i.ContainerName == fileName)?.Action ?? ActionType.deleteAndLoad.ToString()
                });
            }

            await ProcessContainersAsync(database, jsonFolderPath, containerProfile);
        }

        private static async Task ProcessContainersAsync(Database database, string jsonFolderPath, List<Instruction> containerProfile)
        {
            foreach (var profile in containerProfile)
            {
                try
                {
                    Container? container = null;
                    if (profile != null)
                    {
                        if (profile.Action.ToLower() != ActionType.ignore.ToString().ToLower())
                        {

                            ContainerProperties containerProperties = new()
                            {
                                Id = profile.ContainerName,
                                PartitionKeyPath = profile.PartitionKey
                            };

                            ThroughputProperties throughputProperties = ThroughputProperties.CreateAutoscaleThroughput(4000);

                            container = await database.CreateContainerIfNotExistsAsync(containerProperties, throughputProperties);
                        }
                        if (container != null)
                        {
                            string filePath = Path.Combine(jsonFolderPath, $"{profile.ContainerName}.json");
                            if (File.Exists(filePath))
                            {
                                switch (profile.Action.ToLower())
                                {
                                    case var action when action.Equals(ActionType.deleteAndLoad.ToString(), StringComparison.CurrentCultureIgnoreCase):
                                        await BulkDeleteAsync(container, profile.PartitionKey);
                                        await ImportDataAsync(container, filePath);
                                        break;

                                    case var action when action.Equals(ActionType.upsert.ToString(), StringComparison.CurrentCultureIgnoreCase):
                                        await ImportDataAsync(container, filePath);
                                        break;

                                    case var action when action.Equals(ActionType.insert.ToString(), StringComparison.CurrentCultureIgnoreCase):
                                        await InsertDataAsync(container, filePath, profile.PartitionKey);
                                        break;
                                }
                            }
                            else
                            {
                                Console.WriteLine($"File not found for container: {profile.ContainerName}");
                            }
                        }
                        else
                        {
                            Console.WriteLine($"Failed to create or get container: {profile.ContainerName}");
                        }
                    }
                }
                catch (Exception ex)
                {

                    Console.WriteLine($"Failed to process request of container: {profile.ContainerName} Exception: {ex.Message}");
                }
            }
        }

        private static async Task<Container> GetOrCreateContainerAsync(Database database, string containerName, string partitionKey, bool createContainerIfNotExist)
        {
            Container container;
            if (createContainerIfNotExist)
            {
                container = await database.CreateContainerIfNotExistsAsync(containerName, partitionKey);
            }
            else
            {
                container = database.GetContainer(containerName);
                try
                {
                    await container.ReadContainerAsync();
                }
                catch (CosmosException ex) when (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
                {
                    container = null;
                }
            }
            return container;
        }

        private static async Task ImportDataAsync(Container container, string filePath)
        {
            string jsonData = await File.ReadAllTextAsync(filePath);
            dynamic? data = Newtonsoft.Json.JsonConvert.DeserializeObject(jsonData);

            if (data != null)
            {
                foreach (var item in data)
                {
                    await container.UpsertItemAsync(item);
                }

                Console.WriteLine($"Data imported successfully into container: {container.Id}");
            }
        }

        private static async Task BulkDeleteAsync(Container container, string partitionKey)
        {
            var query = new QueryDefinition("SELECT * FROM c");
            using FeedIterator<dynamic> resultSetIterator = container.GetItemQueryIterator<dynamic>(query);
            while (resultSetIterator.HasMoreResults)
            {
                FeedResponse<dynamic> response = await resultSetIterator.ReadNextAsync();

                foreach (var item in response)
                {
                    try
                    {
                        string partitionKeyValue = item[partitionKey[1..]]?.ToString() ?? item.id;
                        await container.DeleteItemAsync<dynamic>(item.id.ToString(), new Microsoft.Azure.Cosmos.PartitionKey(partitionKeyValue));
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Could not delete the item from Container - {container.Id} because of an incorrect Partition Key - {partitionKey}.");
                        return; // if an error occurs, exit the loop
                    }
                }
            }
        }

        private static async Task InsertDataAsync(Container container, string filePath, string partitionKey)
        {
            string jsonData = await File.ReadAllTextAsync(filePath);
            dynamic? data = Newtonsoft.Json.JsonConvert.DeserializeObject(jsonData);

            if (data != null)
            {
                foreach (var item in data)
                {
                    try
                    {
                        string partitionKeyValue = item[partitionKey[1..]]?.ToString() ?? item.id;
                        await container.CreateItemAsync(item, new Microsoft.Azure.Cosmos.PartitionKey(partitionKeyValue));
                    }

                    catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.Conflict)
                    {
                    }

                }

                Console.WriteLine($"Data imported successfully into container: {container.Id}");
            }
        }
    }
}