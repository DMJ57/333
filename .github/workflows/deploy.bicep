# This is a basic workflow to help you get started with Actions

name: CI-Azure Bicep Deployment

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the "main" branch
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel

variables:
  # Define Azure Resource Group and other constants
  resourceGroup: 'komatsu'
  location: 'eastus'  # Adjust to your region
  factoryName: 'ADF033'


jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v4

      - name: Login to Azure
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      # Step 3: Install Bicep CLI
      - name: Install Bicep CLI
        run: |
          az bicep install
          az bicep upgrade



    # Step to find all .json files in the relevant folders
  - script: |
      # Find all linked service .json files
      linkedServiceFiles=$(find $(Build.SourcesDirectory)/linkedServices -name "*.json")
      # Find all dataset .json files
      datasetFiles=$(find $(Build.SourcesDirectory)/datasets -name "*.json")
      # Find all pipeline .json files
      pipelineFiles=$(find $(Build.SourcesDirectory)/pipelines -name "*.json")

      # Convert the file lists to comma-separated values
      linkedServiceFilesStr=$(echo "$linkedServiceFiles" | tr '\n' ',' | sed 's/,$//')
      datasetFilesStr=$(echo "$datasetFiles" | tr '\n' ',' | sed 's/,$//')
      pipelineFilesStr=$(echo "$pipelineFiles" | tr '\n' ',' | sed 's/,$//')

      # Set the variables for the pipeline
      echo "##vso[task.setvariable variable=linkedServiceFiles]$linkedServiceFilesStr"
      echo "##vso[task.setvariable variable=datasetFiles]$datasetFilesStr"
      echo "##vso[task.setvariable variable=pipelineFiles]$pipelineFilesStr"
    displayName: 'Find JSON Files for Linked Services, Datasets, Pipelines'

  # Step to deploy the Bicep template to Azure
  - task: AzureCLI@2
    displayName: 'Deploy Bicep Template to Azure'
    inputs:
      azureSubscription: '<your-azure-subscription>'  # Azure Service Connection
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        # Deploy the Bicep template with the found JSON files
        az deployment group create \
          --resource-group $(resourceGroup) \
          --template-file $(Build.SourcesDirectory)/main.bicep \
          --parameters factoryName=$(factoryName) \
                       location=$(location) \
                       linkedServiceFiles=$(linkedServiceFiles) \
                       datasetFiles=$(datasetFiles) \
                       pipelineFiles=$(pipelineFiles)
    displayName: 'Deploy ADF Resources'
