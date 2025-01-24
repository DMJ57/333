param dataFactoryName string
param dataflows array

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource jsonDataset 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: 'Json1'
  properties: {
    linkedServiceName: {
      referenceName: 'TestLinkedService'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'Json'
    typeProperties: {
      location: {
        type: 'AzureBlobStorageLocation'
        fileName: 'TestInput.json'
        container: 'demokoma'
      }
    }
    schema: {
      type: 'object'
      properties: {
        Name: {
          type: 'string'
        }
        Company: {
          type: 'string'
        }
      }
    }
  }
}

resource json2Dataset 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: 'Json2'
  properties: {
    linkedServiceName: {
      referenceName: 'TestLinkedService'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'Json'
    typeProperties: {
      location: {
        type: 'AzureBlobStorageLocation'
        container: 'demokoma'
      }
    }
    schema: {
      type: 'object'
      properties: {
        Name: {
          type: 'string'
        }
        Company: {
          type: 'string'
        }
      }
    }
  }
}

var dataFlows = [
  {
    name: 'dataflow1'
    description: 'Data flow for processing JSON data'
    sourceDatasetName: 'Json1' // Source Dataset Name
    sinkDatasetName: 'Json2' // Sink Dataset Name
    type: 'MappingDataFlow'
  }
]

resource dataFlowsResources 'Microsoft.DataFactory/factories/dataflows@2018-06-01' = [for dataFlow in dataFlows: {
  parent: dataFactory
  name: dataFlow.name
  properties: {
    type: dataFlow.type
    description: dataFlow.description
    typeProperties: {
      sources: [
        {
          name: 'source1'
          dataset: {
            referenceName: dataFlow.sourceDatasetName
            type: 'DatasetReference'
          }
        }
      ]
      sinks: [
        {
          name: 'sink1'
          dataset: {
            referenceName: dataFlow.sinkDatasetName
            type: 'DatasetReference'
          }
        }
      ]
      transformations: [] // No transformations defined in this example
      scriptLines: []
    }
  }
}]
