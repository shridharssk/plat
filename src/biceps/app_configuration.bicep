
@description('Specifies the name of the App Configuration store.')
param configStoreName string



@description('Specifies the Azure location where the app configuration store should be created.')
param location string = 'eastus'


@description('Specifies the SKU of the app configuration store.')
param skuName string = 'standard'



resource configStore 'Microsoft.AppConfiguration/configurationStores@2021-10-01-preview' = {
  name: configStoreName
  location: location
  sku: {
    name: skuName
  }
}



  
