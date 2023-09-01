@description('Server admin username')
param adminUsername string

@secure()
@description('Server admin password')
param adminPassword string

@description('Name of Postgres server. This must be globally unique.')
param serverName string

@description('Region to use for deployments. Recommended region is "eastus2".')
param serverLocation string

@description('Size/SKU of Postgres server')
param serverSkuName string

@allowed([
  '10'
  '10.0'
  '10.2'
  '11'
])
@description('The version of Postgres to be used on the server')
param serverVersion string

@description('Optional. An array of one or more databases to be created inside the server')
param databaseCollection array = []

@description('How many days storage backups should be retained for')
param storageBackupRetentionInDays int

@allowed([
  'Enabled'
  'Disabled'
])
@description('Determines whether backups should be geo-redundant or not')
param storageGeoRedundantBackup string

@description('Maximum capacity of storage on the server, expressed in Mb')
param storageMaxCapacityInMb int

@description('The fully qualified resource ID of the subnet the private endpoint should be placed in')
param privateEndpointSubnetId string

@description('Optional. Provide any additional/custom tags that should be applied on the PostgreSQL server')
param customTags string = ''
var customTagsObject = customTags == '' ? {} : json(customTags)

resource postgresServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: serverName
  location: serverLocation
  sku: {
    name: serverSkuName
  }
  tags: customTagsObject
  properties: {
    infrastructureEncryption: 'Enabled'
    minimalTlsVersion: 'TLS1_2'
    sslEnforcement: 'Enabled'
    storageProfile: {
      backupRetentionDays: storageBackupRetentionInDays
      geoRedundantBackup: storageGeoRedundantBackup
      storageAutogrow: 'Enabled'
      storageMB: storageMaxCapacityInMb
    }
    version: serverVersion
    createMode: 'Default'
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    publicNetworkAccess: 'Disabled'
  }
}

resource postgresDatabases 'Microsoft.DBforPostgreSQL/servers/databases@2017-12-01' = [for (database, i) in databaseCollection: {
  parent: postgresServer
  name: database.name
  properties: {
    charset: database.charset
    collation: database.collation
  }
}]

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: 'pe-${toLower(serverName)}-postgresqlserver'
  location: serverLocation
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'pe-${toLower(serverName)}-postgresqlserver'
        properties: {
          privateLinkServiceId: postgresServer.id
          groupIds: [
            'postgresqlServer'
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
        name: replace('privatelink.postgres.database.azure.com', '.', '-')
        properties: {
          privateDnsZoneId: resourceId('af5a7fea-0566-4934-a07a-4f15556064d9', 'PrivateDnsZones-RG', 'Microsoft.Network/privateDnsZones', 'privatelink.postgres.database.azure.com')
        }
      }
    ]
  }
}
