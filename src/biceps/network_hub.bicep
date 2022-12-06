param networkName string 
param vnetPrefix string = '10.1.0.0/16'
param sbnt1_addressPrefix string

param location string

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01'= {
  name: networkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets:[
      {
        name: 'gateway-subnet'
        properties: {
          addressPrefix: sbnt1_addressPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
     
     ]
   }
 }
