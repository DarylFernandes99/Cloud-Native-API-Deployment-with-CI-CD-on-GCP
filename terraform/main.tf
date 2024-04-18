module "gcp" {
  source                       = "./modules"
  name                         = var.name
  region                       = var.region
  zone                         = var.zone
  project_id                   = var.project_id
  vpc_config                   = var.vpc_config
  dns_name                     = var.dns_name
  ssl_details                  = var.ssl_details
  service_account              = var.service_account
  instance_properties          = var.instance_properties
  bucket_name                  = var.bucket_name
  key_rings                    = var.key_rings
  secrets                      = var.secrets
  bucket_object_path           = var.bucket_object_path
  pub_sub_cloud_function       = var.pub_sub_cloud_function
  instance_template_properties = var.instance_template_properties
}
