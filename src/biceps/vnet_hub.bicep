//---------vnet_spoke.bicep-------------------

param location string = resourceGroup().location
param name string
var name_hub = '${name}-hub'


module vnet './network_hub.bicep' = {
  name: name_hub
  params: {
    networkName: name_hub
    sbnt1_addressPrefix: '10.1.0.0/24'

    location: location
  }
} 



