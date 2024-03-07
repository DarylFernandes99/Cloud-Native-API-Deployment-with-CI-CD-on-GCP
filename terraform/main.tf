module "gcp" {
  source              = "./modules"
  name                = var.name
  region              = var.region
  zone                = var.zone
  project_id          = var.project_id
  vpc_config          = var.vpc_config
  instance_properties = var.instance_properties
}
