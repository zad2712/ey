param (
    [string]$resourceGroupName,
    [string]$accountName,
    [string]$databaseName
)

# Define variables
# $resourceGroupName = 'USEDCXS05HRSG05'
# $accountName = 'usedcxs05hcdb05'
# $databaseName = 'EYX-Copilot'

# Define containers as an array of hashtables
$containers = @(
    @{ Name = 'aiAcceleratorCourse'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'acceptanceGateCondition'; PartitionKey = '/id'; MaxThroughput = 4000 },    
    @{ Name = 'agent'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'agentCategories'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'agentCategoryTypes'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'agentMetadata'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'agentRoleBasedActions'; PartitionKey = '/role'; MaxThroughput = 4000 },
    @{ Name = 'agentStates'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'agentTags'; PartitionKey = '/id'; MaxThroughput = 4000 },    
    @{ Name = 'apiAgents'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'chatArchive'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'chatDocumentDetails'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'chatmemorysources'; PartitionKey = '/chatid'; MaxThroughput = 4000 },
    @{ Name = 'chatmessages'; PartitionKey = '/chatid'; MaxThroughput = 8000 },
    @{ Name = 'chatparticipants'; PartitionKey = '/userId'; MaxThroughput = 4000 },
    @{ Name = 'chatsessions'; PartitionKey = '/id'; MaxThroughput = 10000 },
    @{ Name = 'documentAgents'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'documentDataMigration'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'documentDetails'; PartitionKey = '/chatid'; MaxThroughput = 10000 },
    @{ Name = 'knowledgeMasters'; PartitionKey = '/chatid'; MaxThroughput = 4000 },
    @{ Name = 'menuItem'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'noticePrompts'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'notifications'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'openAIModels'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'pluginDirectory'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'certifiedCodes'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'mcpserverdirectory'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'processedDocumentPages'; PartitionKey = '/documentId'; MaxThroughput = 4000 },
    @{ Name = 'roleBasedPermissions'; PartitionKey = '/role'; MaxThroughput = 8000 }
    @{ Name = 'users'; PartitionKey = '/role'; MaxThroughput = 4000 },
    @{ Name = 'WorkspaceDetails'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'remoteLibraryDetails'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'notificationTemplates'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'agentEnvironmentSteps'; PartitionKey = '/id'; MaxThroughput = 4000 }
    @{ Name = 'agentGroup'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'agentSteps'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'agentReasoning'; PartitionKey = '/id'; MaxThroughput = 4000 },
    @{ Name = 'headlessApplications'; PartitionKey = '/id'; MaxThroughput = 4000 }
)

# Loop through each container and create it with autoscale
foreach ($container in $containers) {
    az cosmosdb sql container create `
        -a $accountName `
        -g $resourceGroupName `
        -d $databaseName `
        -n $($container.Name) `
        -p $($container.PartitionKey) `
        --max-throughput $($container.MaxThroughput)
}
