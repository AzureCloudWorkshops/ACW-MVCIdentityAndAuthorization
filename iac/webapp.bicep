@description('Resource Location - choose a valid Azure region for your deployment')
param location string = resourceGroup().location

@allowed([
  'Workshop'
  'Demo'
])
param tagEnvironmentValue string = 'Demo'

@description('Provide a unique datetime and initials string to make your instances unique. Use only lower case letters and numbers')
@minLength(11)
@maxLength(11)
param uniqueNameTagString string = '20991231abc'

@description('The language worker runtime to load in the web app.')
@allowed([
  'dotnet'
])
param workerRuntime string = 'dotnet'

@description('The name of the web app that you wish to create.')
@minLength(20)
@maxLength(50)
param appName string = 'CustomizingASPNETIdentityAndThirdPartySignIn'

@description('The SKU/Name of the hosting plan that you wish to create.')
@allowed([
  'B1'
  'F1'
  'S1'
])
param webAppHostingPlan string = 'F1'

var webAppName = concat('${appName}${uniqueNameTagString}')
var hostingPlanName = concat('ASP-${appName}${uniqueNameTagString}')
var logAnalyticsName = concat('LA-${appName}${uniqueNameTagString}')
var applicationInsightsName = concat('AI-${appName}${uniqueNameTagString}')

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: hostingPlanName
  location: location
  tags: {
    Environment: tagEnvironmentValue
  }
  sku: {
    name: webAppHostingPlan
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsName
  location: location
  tags: {
    Environment: tagEnvironmentValue
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  tags: {
    Environment: tagEnvironmentValue
  }
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource webApplication 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      metadata :[
        {
          name:'CURRENT_STACK'
          value:workerRuntime
        }
      ]
      linuxFxVersion: 'DOTNETCORE|7.0'
      appSettings: [
          {
            name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
            value: applicationInsights.properties.InstrumentationKey
          }
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: applicationInsights.properties.ConnectionString
          }
        ]
        ftpsState: 'FtpsOnly'
        minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}
