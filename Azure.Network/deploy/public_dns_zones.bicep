
var zones_to_manage = [
  'stonex.me'
  'corp.stonex.com'
]


@batchSize(1) // optional decorator for serial deployment
module createPublicDns 'modules/res_create_public_dnz_zone.bicep' = [for zonename in zones_to_manage: {
  name: '${zonename}'
  params: {
    zoneName: zonename
  }
}]

