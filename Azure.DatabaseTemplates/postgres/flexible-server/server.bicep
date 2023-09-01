@description('The local admin username for the server')
param adminUsername string

@secure()
@description('The local admin password for the server')
param adminPassword string

@description('The name of the server - must be globally unique')
param serverName string

@description('The location of the server')
@allowed([
  'eastus'
  'eastus2'
  'centralus'
  'westeurope'
  'uksouth'
])
param serverLocation string

@allowed([
  '11'
  '12'
  '13'
  '14'
])
@description('Optional. The version of Postgres to use. Defaults to version 14 if no value is specified.')
param serverVersion string = '14'

@allowed([
  'Burstable_1Core_2GBMemory'
  'Burstable_2Core_4GBMemory'
  'Burstable_4Core_8GBMemory'
  'Burstable_8Core_16GBMemory'
  'Burstable_12Core_24GBMemory'

  'MemoryOptimised_2Core_16GBMemory'
  'MemoryOptimised_4Core_32GBMemory'
  'MemoryOptimised_8Core_64GBMemory'
  'MemoryOptimised_16Core_128GBMemory'

  'GeneralPurpose_2Core_8GBMemory'
  'GeneralPurpose_4Core_16GBMemory'
  'GeneralPurpose_8Core_32GBMemory'
  'GeneralPurpose_16Core_64GBMemory'
])
@description('Quantity of CPU vCores and RAM to allocate to the server')
param serverSku string

@allowed([ 
  'SameZone'
  'MultiZone'
])
@description('Whether the standby server should reside in the same zone as your primary server, or whether the standby server should be in multiple zones')
param highAvailabilityType string

@description('Optional. Whether password-based local authentication should be permitted')
param enablePasswordAuthentication bool = true

@description('Optional. Maximum storage capacity in GB. Defaults to 256GB if no value is specified.')
param storageMaxCapacityInGb int = 256

@description('Whether server backups should be geo-redundant or not')
param backupsGeoRedundant bool

@maxValue(35)
@minValue(7)
@description('Optional. Number of day to store backups for. Defaults to 7 days if no value is specified.')
param backupsRetentionInDays int = 7

@description('The ID of the subnet to deploy the server into')
param subnetId string

var skuMap = {
  Burstable_1Core_2GBMemory: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  Burstable_2Core_4GBMemory: {
    name: 'Standard_B2ms'
    tier: 'Burstable'
  }
  Burstable_4Core_8GBMemory: {
    name: 'Standard_B4ms'
    tier: 'Burstable'
  }
  Burstable_8Core_16GBMemory: {
    name: 'Standard_B8ms'
    tier: 'Burstable'
  }
  Burstable_12Core_24GBMemory: {
    name: 'Standard_B12ms'
    tier: 'Burstable'
  }
  MemoryOptimised_2Core_16GBMemory: {
    name: 'Standard_E2ds_v4'
    tier: 'MemoryOptimized'
  }
  MemoryOptimised_4Core_32GBMemory: {
    name: 'Standard_E4ds_v4'
    tier: 'MemoryOptimized'
  }
  MemoryOptimised_8Core_64GBMemory: {
    name: 'Standard_E8ds_v4'
    tier: 'MemoryOptimized'
  }
  MemoryOptimised_16Core_128GBMemory: {
    name: 'Standard_E16ds_v4'
    tier: 'MemoryOptimized'
  }
  GeneralPurpose_2Core_8GBMemory: {
    name: 'Standard_D2ds_v4'
    tier: 'GeneralPurpose'
  }
  GeneralPurpose_4Core_16GBMemory: {
    name: 'Standard_D4ds_v4'
    tier: 'GeneralPurpose'
  }
  GeneralPurpose_8Core_32GBMemory: {
    name: 'Standard_D8ds_v4'
    tier: 'GeneralPurpose'
  }
  GeneralPurpose_16Core_64GBMemory: {
    name: 'Standard_D16ds_v4'
    tier: 'GeneralPurpose'
  }
}

resource postgresqlServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: serverName
  location: serverLocation
  sku: {
    name: skuMap[serverSku].name
    tier: skuMap[serverSku].tier
  }
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    authConfig: {
      activeDirectoryAuth: enablePasswordAuthentication == true ? 'Disabled' : 'Enabled'
      passwordAuth: enablePasswordAuthentication == true ? 'Enabled' : 'Disabled'
      tenantId: tenant().tenantId
    }
    availabilityZone: ''
    backup: {
      backupRetentionDays: backupsRetentionInDays
      geoRedundantBackup: backupsGeoRedundant == true ? 'Enabled' : 'Disabled'
    }
    createMode: 'Create'
    highAvailability: {
      mode: highAvailabilityType == 'SameZone' ? 'SameZone' : 'ZoneRedundant'
      standbyAvailabilityZone: ''
    }
    maintenanceWindow: {
      customWindow: 'Enabled'
      dayOfWeek: 0
      startHour: 4
      startMinute: 0
    }
    network: {
      delegatedSubnetResourceId: subnetId
      privateDnsZoneArmResourceId: resourceId('af5a7fea-0566-4934-a07a-4f15556064d9', 'PrivateDnsZones-RG', 'Microsoft.Network/privateDnsZones', 'privatelink.postgres.database.azure.com')
    }
    replicaCapacity: 5
    replicationRole: 'Primary'
    storage: {
      storageSizeGB: storageMaxCapacityInGb
    }
    version: serverVersion
  }
}

@description('Fully qualified resource ID')
output id string = postgresqlServer.id
