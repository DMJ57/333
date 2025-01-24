param dataFactoryName 

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

var dataFlows = [
  {
    name: 'DataFlow1'
    description: 'Data flow for processing customer data'
    sourceLinkedServiceName: 'AzureBlobStorageLinkedService'
    sourceFileName: 'customers.csv'
    sourceFolderPath: 'customerdata/'
    sinkLinkedServiceName: 'AzureSqlLinkedService'
    sinkTableName: 'CustomerTable'
    type: 'MappingDataFlow'
  }
  {
    name: 'DataFlow2'
    description: 'Data flow for processing transaction data'
    sourceLinkedServiceName: 'AzureBlobStorageLinkedService'
    sourceFileName: 'transactions.csv'
    sourceFolderPath: 'transactiondata/'
    sinkLinkedServiceName: 'AzureSqlLinkedService'
    sinkTableName: 'TransactionTable'
    type: 'MappingDataFlow'
  }
]

resource dataFlowsResources 'Microsoft.DataFactory/factories/dataflows@2018-06-01' = [for dataFlow in dataFlows: {
  parent: dataFactory
  name: dataFlow.name
  properties: {
    type: dataFlow.type
    description: dataFlow.description
    activities: [
      {
        name: 'SourceActivity'
        type: 'Source'
        linkedServiceName: {
          referenceName: dataFlow.sourceLinkedServiceName
          type: 'LinkedServiceReference'
        }
        typeProperties: {
          source: {
            type: 'DelimitedText'
            fileName: dataFlow.sourceFileName
            folderPath: dataFlow.sourceFolderPath
          }
        }
      }
      {
        name: 'SinkActivity'
        type: 'Sink'
        linkedServiceName: {
          referenceName: dataFlow.sinkLinkedServiceName
          type: 'LinkedServiceReference'
        }
        typeProperties: {
          sink: {
            type: 'AzureSqlSink'
            tableName: dataFlow.sinkTableName
          }
        }
      }
    ]
  }
}]
