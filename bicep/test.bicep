param dataflows string

resource dataFlowDeployment 'Microsoft.Resources/deployments@2021-04-01' = {
  name: 'dataflow-deployment'
  properties: {
    mode: 'Incremental'
    template: json(dataflows)  // Passing the JSON content as string
  }
}
