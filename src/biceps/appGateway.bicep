param applicationGateWayName string
param location string = resourceGroup().location
param vnetname string 
param subnetname string = 'gateway-subnet'
var publicIPAddressName = 'public_ip'
param backendappservice string

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2021-05-01' = [for i in range(0, 1): {
  name: '${publicIPAddressName}${i}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}]


resource appGw 'Microsoft.Network/applicationGateways@2021-02-01' = {
  name: applicationGateWayName
  location: location
  properties: {
    sku: {
     
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }
    
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets',vnetname , subnetname)
          }
        }
      }
    ]
     frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', '${publicIPAddressName}0')
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    
     backendAddressPools: [
      {
        name: 'myBackendPool'
        properties: {
          backendAddresses: [
            {
              fqdn: backendappservice
              
            }
          ]

        }
      }
    ]
    
   backendHttpSettingsCollection: [
      {
        name: 'myHTTPSetting'
        id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection',applicationGateWayName,'myhttp-settings')
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          requestTimeout: 20
          probe:{
            id: resourceId('Microsoft.Network/applicationGateways/probes',applicationGateWayName,'myhttp-settings')
          }
        }
      }
    ]
    
     httpListeners: [
      {
        name: 'myListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGateWayName, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGateWayName, 'port_80')
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    
     requestRoutingRules: [
      {
        name: 'myRoutingRule'
        properties: {
          ruleType: 'Basic'
          priority: 300
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGateWayName, 'myListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGateWayName, 'myBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGateWayName, 'myHTTPSetting')
          }
        }
      }
    ]
    probes: [
      {
           name: 'myhttp-settings'
           properties: {
               protocol: 'Http'
               path: '/'
               interval: 30
               timeout: 30
               unhealthyThreshold: 3
               pickHostNameFromBackendHttpSettings: true
               minServers: 0
               match: {}
             }
       }
     
   ]
    autoscaleConfiguration: { // Autoscale
      minCapacity: 0
      maxCapacity: 2
    }
    
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Prevention'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.2'
    }
  }
}
