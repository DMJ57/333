param factoryName string
param location string = resourceGroup().location

// Parameters for the arrays of file paths
param linkedServiceFiles array
param datasetFiles array
param pipelineFiles array

// Define the Azure Data Factory resource
resource factory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: location
}

// Deploy Linked Services
resource linkedServiceDeployments 'Microsoft.Resources/deployments@2021-04-01' = [for linkedServiceFile in linkedServiceFiles: {
  name: 'linkedServiceDeployment-${linkedServiceFile}'
  properties: {
    mode: 'Incremental'
    template: json(loadTextContent(linkedServiceFile))
  }
}]

// Deploy Datasets
resource datasetDeployments 'Microsoft.Resources/deployments@2021-04-01' = [for datasetFile in datasetFiles: {
  name: 'datasetDeployment-${datasetFile}'
  properties: {
    mode: 'Incremental'
    template: json(loadTextContent(datasetFile))
  }
}]

// Deploy Pipelines
resource pipelineDeployments 'Microsoft.Resources/deployments@2021-04-01' = [for pipelineFile in pipelineFiles: {
  name: 'pipelineDeployment-${pipelineFile}'
  properties: {
    mode: 'Incremental'
    template: json(loadTextContent(pipelineFile))
  }
}]
