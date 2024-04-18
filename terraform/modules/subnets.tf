# To test output value => terraform console => module.gcp.test
# output "test" {
#   value = {
#     for subnet in flatten([
#       for vpc_name, vpc_config in var.vpc_config : [
#         for subnet_name, subnet_config in vpc_config.subnets: {
#           subnet_name = subnet_name
#           subnet_config = subnet_config
#         }
#       ]
#     ]) : subnet.subnet_name => subnet.subnet_config
#   }
# }

resource "google_compute_subnetwork" "subnets" {
  for_each = {
    for idx, config in flatten([
      for vpc_name, vpc_config in var.vpc_config: flatten([
        for subnet_name, subnet_config in vpc_config.subnets : {
          "name"         : subnet_config.name
          "ip_cidr_range": subnet_config.ip_cidr_range
          "purpose": subnet_config.purpose
          "role": subnet_config.role
          "network"      : google_compute_network.vpc_network[vpc_name].id
        }
      ])
    ]) : idx => config
  }

  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  network       = each.value.network
  purpose = each.value.purpose
  role = each.value.role
  depends_on = [
    google_compute_network.vpc_network
  ]
}
