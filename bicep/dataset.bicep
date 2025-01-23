targetScope = 'resourceGroup'  // Set targetScope to resourceGroup

param dataFactoryName string
param datasets array

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: 'East US'
}
@description('Name of the Azure Storage Account that contains I/O & O/P data')
param storageAccountName string = 'demokomatsu'


resource dataset 'Microsoft.DataFactory/factories/datasets@2018-06-01' = [for dataset in datasets: {
  parent: dataFactory
  name: dataset.name
  properties: {
    type: 'AzureBlob'
    linkedServiceName: {
      referenceName: 'TestLinkedService'  // Ensure you define the linked service properly
      type: 'LinkedServiceReference'
    }
    typeProperties: {
     fileName: dataset.definition.properties.typeProperties.fileName
      folderPath: dataset.definition.properties.typeProperties.folderPath
      // Remove linkedServiceName as it's not allowed
    }
  }
}]
