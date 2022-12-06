

param sku string  // The SKU of App Service Plan
param location string = resourceGroup().location // Location for all resources
param appPlanName string
var appServicePlanName = toLower('AppServicePlan-${appPlanName}')
param appSubnetId string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}


// params for app service 

param linuxFxVersion string // The runtime stack of web app
param webAppName string 

var webSiteName = toLower('wapp-${webAppName}')

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: appSubnetId
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}



