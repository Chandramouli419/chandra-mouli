# PostgreSQL Flexible Server

## Template parameters

| Parameter | Description | Type | Default |
| --- | --- | --- | --- |
| `adminPassword` | The local admin password for the server | string (secure) |  |
| `adminUsername` | The local admin username for the server | string |  |
| `backupsGeoRedundant` | Whether server backups should be geo-redundant or not | bool |  |
| `backupsRetentionInDays` | Optional. Number of day to store backups for. Defaults to 7 days if no value is specified. | int <br/> <br/>Accepted values: from 7 to 35. | 7 |
| `enablePasswordAuthentication` | Optional. Whether password-based local authentication should be permitted | bool | true |
| `highAvailabilityType` | Whether the standby server should reside in the same zone as your primary server, or whether the standby server should be in multiple zones | 'MultiZone' \| 'SameZone' |  |
| `serverLocation` | The location of the server | [serverLocationAllow](#serverlocationallow) |  |
| `serverName` | The name of the server - must be globally unique | string |  |
| `serverSku` | Quantity of CPU vCores and RAM to allocate to the server | [serverSkuAllow](#serverskuallow) |  |
| `serverVersion` | Optional. The version of Postgres to use. Defaults to version 14 if no value is specified. | [serverVersionAllow](#serverversionallow) | '14' |
| `storageMaxCapacityInGb` | Optional. Maximum storage capacity in GB. Defaults to 256GB if no value is specified. | int | 256 |
| `subnetId` | The ID of the subnet to deploy the server into | string |  |

## Example parameters
Refer to `example-parameters-01.jsonc` for an example with all parameters populated.

Remember, any parameters which are marked as optional do not have to be set, and can be removed from your parameters file.

## Resources

- [Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.dbforpostgresql/2022-12-01/flexibleservers)

## Outputs

| Name | Type | Description |
| --- | --- | --- |
| `id` | string | Fully qualified resource ID |

## References

### serverLocationAllow

- centralus
- eastus
- eastus2
- uksouth
- westeurope

### serverSkuAllow

- Burstable_12Core_24GBMemory
- Burstable_1Core_2GBMemory
- Burstable_2Core_4GBMemory
- Burstable_4Core_8GBMemory
- Burstable_8Core_16GBMemory
- GeneralPurpose_16Core_64GBMemory
- GeneralPurpose_2Core_8GBMemory
- GeneralPurpose_4Core_16GBMemory
- GeneralPurpose_8Core_32GBMemory
- MemoryOptimised_16Core_128GBMemory
- MemoryOptimised_2Core_16GBMemory
- MemoryOptimised_4Core_32GBMemory
- MemoryOptimised_8Core_64GBMemory

### serverVersionAllow

- 11
- 12
- 13
- 14