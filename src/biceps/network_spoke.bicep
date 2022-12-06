param networkName string 
param vnetPrefix string = '10.0.0.0/16'
param sbnt1_addressPrefix string
param sbnt2_addressPrefix string
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
        name: 'appsrv-subnet'
        properties: {
          addressPrefix: sbnt1_addressPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: 'backend-subnet'
        properties: {
          addressPrefix: sbnt2_addressPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
     ]
   }
 }
 output appSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', networkName, 'appsrv-subnet')
