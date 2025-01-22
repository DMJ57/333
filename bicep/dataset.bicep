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
