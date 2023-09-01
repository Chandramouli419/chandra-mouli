# MariaDB server

## Template parameters

| Parameter | Description | Type | Default |
| --- | --- | --- | --- |
| `adminPassword` | Server admin password | string (secure) |  |
| `adminUsername` | Server admin username | string |  |
| `backupRedundancy` | Optional. Whether backups should be single region or multi region. By default, backups will be SingleRegion | 'MultiRegion' \| 'SingleRegion' | 'SingleRegion' |
| `backupRetentionInDays` | Optional. How many days backups should be kept for. By default, backups will only be kept for 7 days. | int <br/> <br/>Accepted values: from 7 to 35. | 7 |
| `databaseNames` | Optional. A string array of names of databases that should be created | array | [] |
| `privateEndpointSubnetId` | The fully qualified resource ID of the subnet the private endpoint should be placed in | string |  |
| `serverLocation` | Region to use for deployments - recommended region is "eastus2" | string |  |
| `serverName` | Name of MariaDB server - must be globally unique | string |  |
| `sku` | Server SKU | [skuAllow](#skuallow) |  |
| `storageSizeInGb` | Optional. Size of storage in GB. By default, 100GB of storage is allocated. | int <br/> <br/>Accepted values: from 5 to 16384. | 100 |

## Example parameters
Refer to `example-parameters-01.jsonc` for an example with all parameters populated.

Refer to `example-parameters-02.jsonc` for a 'minimal example' with only mandatory parameters populated.

## Resources

- [Microsoft.DBforMariaDB/servers@2018-06-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.dbformariadb/2018-06-01/servers)
- [Microsoft.DBforMariaDB/servers/databases@2018-06-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.dbformariadb/2018-06-01/servers/databases)
- [Microsoft.Network/privateEndpoints@2021-03-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/2021-03-01/privateendpoints)
- [Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-03-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/2021-03-01/privateendpoints/privatednszonegroups)

## Outputs

| Name | Type | Description |
| --- | --- | --- |
| `id` | string | Fully qualified resource ID |

## References

### skuAllow

- 16CoresWith160GbMemory
- 16CoresWith80GbMemory
- 2CoresWith10GbMemory
- 2CoresWith20GbMemory
- 32CoresWith160GbMemory
- 32CoresWith320GbMemory
- 4CoresWith20GbMemory
- 4CoresWith40GbMemory
- 64CoresWith320GbMemory
- 8CoresWith40GbMemory
- 8CoresWith80GbMemory