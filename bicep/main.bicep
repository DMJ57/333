targetScope = 'resourceGroup'  // Set targetScope to resourceGroup

param dataFactoryName string
param linkedsServices array
param datasets array

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: 'East US'
}
@description('Name of the Azure Storage Account that contains I/O & O/P data')
param storageAccountName string = 'demokomatsu'


param storageAccount1 string = 'Y4Fo0vh4xap7U+VravqaJftr++ToUycBATaNeOJ1eLNJZkKyU3e9qZZCIPeLoP03xZmwO/s8gHCc+ASt9ejhfw=='


// resource LinkedService 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = [for linkedService in linkedServices: {
//   parent: dataFactory
//   name: '${dataFactory}/${linkedService}'
//   properties: linkedService.definition
// }]

resource linkedService 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = [for linkedService in linkedServices: {
  parent: dataFactory
  name: linkedService.name  // Removed the ${dataFactory.name}/ part
  properties: {
    type: 'AzureBlobStorage'
    typeProperties: {
      connectionString: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount1};EndpointSuffix=core.windows.net;'
    }
  }
}]

resource dataset 'Microsoft.DataFactory/factories/datasets@2018-06-01' = [for dataset in datasets: {
  parent: dataFactory
  name: dataset.name  // The dataset name (without full path, as we use parent)
  properties: {
    type: 'AzureBlob'  // You can change this depending on the dataset type
    typeProperties: {
      fileName: dataset.fileName  // Example property
      folderPath: dataset.folderPath  // Example property
      linkedServiceName: {
        referenceName: dataset.linkedServiceName  // Reference to the linked service
        type: 'LinkedServiceReference'
      }
    }
  }
}]
