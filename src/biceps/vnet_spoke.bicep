//---------vnet_spoke.bicep-------------------

param location string = resourceGroup().location
param name string
var name_spoke = '${name}-spoke'


module vnet './network_spoke.bicep' = {
  name: name_spoke
  params: {
    networkName: name_spoke
    sbnt1_addressPrefix: '10.0.0.0/24'
    sbnt2_addressPrefix: '10.0.1.0/24'
    location: location
  }
} 
 
  
 

