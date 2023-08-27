@description('Provide a name for the resource group for all resources')
param resourceGroupName string = 'customizemvcidentitylogin'

@description('Choose a region on your subscription where you can deploy the resources such as East US, West US, etc.')
param location string = 'eastus'

@description('Provide a unique datetime and initials string to make your instances unique. Use only lower case letters and numbers')
@minLength(11)
@maxLength(11)
param yourUniqueDateAndInitialsString string = '20230831blg'

@allowed([
  'Workshop'
  'Demo'
])
param tagEnvironmentValue string = 'Demo'

@description('Name of the SQL Db Server')
param serverName string = 'dbserver'

@description('Name of the Sql Database')
param dbName string = 'db'

@description('Admin UserName for the SQL Server')
param sqlServerAdminLogin string = 'demouser'

@description('Admin Password for the SQL Server')
@secure()
param sqlServerAdminPassword string = 'demodb#54321!'

@description('Service Bus Tier [Basic, Standard, Premium]. Use Basic unless you need pub/sub topics.')
@allowed([
  'Basic'
])
param dbSKU string = 'Basic'

@description('The number of DTUs for a DTU-Based SQL Server')
param dbCapacity int = 5

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

targetScope = 'subscription'

resource demoRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: {
    Environment: tagEnvironmentValue
  }
  properties: {}
}

module deployDatabase 'database.bicep' = {
  name: 'database_deployment'
  scope: demoRG
  params: {
    location: location
    dbCapacity: dbCapacity
    dbName: dbName
    dbSKU: dbSKU
    serverName: serverName
    sqlServerAdminLogin: sqlServerAdminLogin
    sqlServerAdminPassword: sqlServerAdminPassword
    tagEnvironmentValue: tagEnvironmentValue
    uniqueNameTagString: yourUniqueDateAndInitialsString
  }
}

module deployWeb 'webapp.bicep' = {
  name: 'website_deployment'
  scope: demoRG
  params: {
    location: location
    appName: appName
    tagEnvironmentValue: tagEnvironmentValue
    uniqueNameTagString: yourUniqueDateAndInitialsString
    webAppHostingPlan: webAppHostingPlan
    workerRuntime: workerRuntime
  }
}
