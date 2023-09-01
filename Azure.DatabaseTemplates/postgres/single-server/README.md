# PostgreSQL Single Server

## Retirement warning
In March 2023, Microsoft announced that it will begin retiring the single server SKU.

You are advised to avoid deploying new single server SKU instances and to start deploying flexible server SKU instances instead.

## Template parameters

| Parameter | Description | Type | Default |
| --- | --- | --- | --- |
| `adminPassword` | Server admin password | string (secure) |  |
| `adminUsername` | Server admin username | string |  |
| `customTags` | Optional. Provide any additional/custom tags that should be applied on the PostgreSQL server | string | '' |
| `databaseCollection` | Optional. An array of one or more databases to be created inside the server | array | [] |
| `privateEndpointSubnetId` | The fully qualified resource ID of the subnet the private endpoint should be placed in | string |  |
| `serverLocation` | Region to use for deployments. Recommended region is "eastus2". | string |  |
| `serverName` | Name of PostgreSQL server. This must be globally unique. | string |  |
| `serverSkuName` | Size/SKU of PostgreSQL server | string |  |
| `serverVersion` | The version of Postgres to be used on the server | [serverVersionAllow](#serverversionallow) |  |
| `storageBackupRetentionInDays` | How many days storage backups should be retained for | int |  |
| `storageGeoRedundantBackup` | Determines whether backups should be geo-redundant or not | 'Disabled' \| 'Enabled' |  |
| `storageMaxCapacityInMb` | Maximum capacity of storage on the server, expressed in Mb | int |  |

## Example parameters
Refer to `example-parameters-01.jsonc` for an example with all parameters populated.

Remember, any parameters which are marked as optional do not have to be set, and can be removed from your parameters file.

## Resources

- [Microsoft.DBforPostgreSQL/servers@2017-12-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.dbforpostgresql/2017-12-01/servers)
- [Microsoft.DBforPostgreSQL/servers/databases@2017-12-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.dbforpostgresql/2017-12-01/servers/databases)
- [Microsoft.Network/privateEndpoints@2021-03-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/2021-03-01/privateendpoints)
- [Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-03-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/2021-03-01/privateendpoints/privatednszonegroups)

## References

### serverVersionAllow

- 10
- 10.0
- 10.2
- 11
