@description('Server admin username')
param adminUsername string

@secure()
@description('Server admin password')
param adminPassword string

@description('Name of MariaDB server - must be globally unique')
param serverName string

@description('Region to use for deployments - recommended region is "eastus2"')
param serverLocation string

@description('Server SKU')
@allowed([
  // General Purpose
  '2CoresWith10GbMemory'
  '4CoresWith20GbMemory'
  '8CoresWith40GbMemory'
  '16CoresWith80GbMemory'
  '32CoresWith160GbMemory'
  '64CoresWith320GbMemory'

  // Memory optimised
  '2CoresWith20GbMemory'
  '4CoresWith40GbMemory'
  '8CoresWith80GbMemory'
  '16CoresWith160GbMemory'
  '32CoresWith320GbMemory'
])
param sku string

@description('Optional. How many days backups should be kept for. By default, backups will only be kept for 7 days.')
@minValue(7)
@maxValue(35)
param backupRetentionInDays int = 7

@description('Optional. Whether backups should be single region or multi region. By default, backups will be SingleRegion')
@allowed([
  'SingleRegion'
  'MultiRegion'
])
param backupRedundancy string = 'SingleRegion'

@description('Optional. Size of storage in GB. By default, 100GB of storage is allocated.')
@minValue(5)
@maxValue(16384)
param storageSizeInGb int = 100

@description('The fully qualified resource ID of the subnet the private endpoint should be placed in')
param privateEndpointSubnetId string

@description('Optional. A string array of names of databases that should be created')
param databaseNames array = []

var skuMap = {
  '2CoresWith10GbMemory' : {
    skuName: 'GP_Gen5_2'
  } 
  '4CoresWith20GbMemory' : {
    skuName: 'GP_Gen5_4'
  } 
  '8CoresWith40GbMemory' : {
    skuName: 'GP_Gen5_8'
  }
  '16CoresWith80GbMemory' : {
    skuName: 'GP_Gen5_16'
  } 
  '32CoresWith160GbMemory' : {
    skuName: 'GP_Gen5_32'
  } 
  '64CoresWith320GbMemory' : {
    skuName: 'GP_Gen5_64'
  }
  '2CoresWith20GbMemory' : {
    skuName: 'MO_Gen5_2'
  }
  '4CoresWith40GbMemory' : {
    skuName: 'MO_Gen5_4'
  }
  '8CoresWith80GbMemory' : {
    skuName: 'MO_Gen5_8'
  }
  '16CoresWith160GbMemory' : {
    skuName: 'MO_Gen5_16'
  }
  '32CoresWith320GbMemory' : {
    skuName: 'MO_Gen5_32'
  }        
}

resource mariaDb 'Microsoft.DBforMariaDB/servers@2018-06-01' = {
  name: serverName
  location: serverLocation
  sku: {
    name: skuMap[sku].skuName
  }
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    createMode: 'Default'
    minimalTlsVersion: 'TLS1_2'
    publicNetworkAccess: 'Disabled'
    sslEnforcement: 'Enabled'
    storageProfile: {
      backupRetentionDays: backupRetentionInDays
      geoRedundantBackup: (backupRedundancy == 'SingleRegion') ? 'Disabled' : 'Enabled'
      storageAutogrow: 'Enabled'
      storageMB: storageSizeInGb * 1024
    }
    version: '10.3'
  }
}

resource databases 'Microsoft.DBforMariaDB/servers/databases@2018-06-01' = [for (databaseName, i) in databaseNames: {
  parent: mariaDb
  name: databaseName
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}]

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: 'pe-${toLower(serverName)}-mariadbserver'
  location: serverLocation
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'pe-${toLower(serverName)}-mariadbserver'
        properties: {
          privateLinkServiceId: mariaDb.id
          groupIds: [
            'mariadbserver'
          ]
        }
      }
    ]
    subnet: {
      id: privateEndpointSubnetId
    }
  }
}

resource privateEndpointDnsRegistration 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-03-01' = {
  name: 'default'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: replace('privatelink.mariadb.database.azure.com', '.', '-')
        properties: {
          privateDnsZoneId: resourceId('af5a7fea-0566-4934-a07a-4f15556064d9', 'PrivateDnsZones-RG', 'Microsoft.Network/privateDnsZones', 'privatelink.mariadb.database.azure.com')
        }
      }
    ]
  }
}

@description('Fully qualified resource ID')
output id string = mariaDb.id
