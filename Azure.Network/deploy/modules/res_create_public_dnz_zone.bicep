
param zoneName string

// resource name in module
resource pubdnszone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: zoneName
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}
