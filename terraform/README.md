# Infrastructure Deployment with Terraform on Google Cloud Platform
This project utilizes Terraform for the dynamic construction of infrastructure on the Google Cloud Platform (GCP). Key components include the creation of a Virtual Private Cloud (VPC), subnets, routes, firewalls, Virtual Machine (VM) instances, Private Services Access for VPC, and a Cloud SQL instance. Configuration details are conveniently provided through a variable file, ensuring flexibility and ease of customization.

# Install Google Cloud CLI
Follow this URL to find the installer steps for your machine https://cloud.google.com/sdk/docs/install

`Note: Add the bin directory of gcloud-sdk to PATH variable, else you would have to run the commands with "<path-to-bin of gcloud sdk>/" prefix`

## Setup Google Cloud CLI

```
$ gcloud auth login
$ gcloud auth application-default login
```

## Setup default project

```
$ gcloud config set project <project_id>
```

## To revoke access to Google Cloud CLI

```
$ gcloud auth revoke
$ gcloud auth application-default revoke
```

## Enable APIs in Google Cloud Platform
<ol>
    <li>Navigate to google cloud dashboard: <a href="https://console.cloud.google.com/welcome/new">https://console.cloud.google.com/welcome/new</a></li>
    <li>From the Navigation Menu > APIs and services > Library</li>
    <li>Enable the following APIs:</li>
        <ul>
            <li>Compute Engine API</li>
            <li>Cloud SQL Admin API</li>
            <li>Service Networking API</li>
            <li>Cloud Source Repositories API</li>
            <li>Identity and Access Management (IAM) API</li>
        </ul>
    <li>After enabling the APIs it may take about 10-15 mins to be activated</li>
</ol>

## Create Service account and give permissions
<ol>
    <li>Navigate to google cloud dashboard: <a href="https://console.cloud.google.com/welcome/new">https://console.cloud.google.com/welcome/new</a></li>
    <li>From the Navigation Menu > IAM and admin > Service accounts</li>
    <li>Create a new / modify the permissions of existing service account with the following permissions</li>
    
    Service Account User
    IAP-secured Tunnel User
    Compute Instance Admin v1
    Service Account Token Creator
    Cloud SQL Editor
    Storage Object Viewer
</ol>

# Install terraform
Follow this URL to find the installer steps for your machine https://developer.hashicorp.com/terraform/install

## Create a input variable file

<ol>
    <li>Create a file named *.tfvars</li>
    <li>Add the data in the format shown below (expected variables are mentioned in the variables.tf file):</li>
    
    name       = "<project_name>"
    project_id = "<project_id>"
    region     = "<project_region>"
    zone       = "<project_zone>"

    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
    vpc_config = (optional) {
        <vpc_name> = {
            name                            = "<vpc_name>"
            auto_create_subnetworks         = true or false
            routing_mode                    = "REGIONAL" or "GLOBAL"
            delete_default_routes_on_create = true or false
            mtu                             = (number) 1460

            # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
            subnets = {
                <subnet1_name> = {
                    name          = "<subnet1_name>"
                    ip_cidr_range = "ip_range"
                },
                <subnet2_name> = {
                    name          = "<subnet2_name>"
                    ip_cidr_range = "ip_range"
                },
            }

            # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route
            routes = {
                <route1_name> = {
                    name       = "<route1_name>"
                    dest_range = "dest_range"
                    tags       = (optional) [ <subnet_name to which this route is applicable > ]
                },
                <route2_name> = {
                    name       = "<route2_name>"
                    dest_range = "dest_range"
                    tags       = (optional) [ <subnet_name to which this route is applicable > ]
                }
            }
            
            # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
            firewalls = {
                <firewall1_name> = {
                    name          = "<firewall1_name>"
                    source_tags   = [ "<tag>", "<tag>" ]
                    source_ranges = (optional) [ "<range>", "<range>" ]
                    allow         = (optional) [
                        {
                            protocol = "<protocol_name>"
                            ports    = [ "<port>", "<port>" ]
                        }
                    ]
                    deny          = (optional) [
                        {
                            protocol = "<protocol_name>"
                            ports    = [ "<port>", "<port>" ]
                        }
                    ]
                },
                <firewall2_name> = {
                    name          = "<firewall2_name>"
                    source_tags   = [ "<tag>", "<tag>" ]
                    source_ranges = (optional) [ "<range>", "<range>" ]
                    allow         = (optional) [
                        {
                            protocol = "<protocol_name>"
                            ports    = (optional) [ "<port>", "<port>" ]
                        }
                    ]
                    deny          = (optional) [
                        {
                            protocol = "<protocol_name>"
                            ports    = (optional) [ "<port>", "<port>" ]
                        }
                    ]
                }
            }
            
            # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
            private_access = (optional) {
                <private_access1_name> = {
                    name          = "<private_access1_name>"
                    purpose       = "<purpose>"
                    address_type  = "<addres_type>"
                    prefix_length = (number) <prefix_length>

                    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection
                    peering_connection = (optional) {
                        <peering_connection1> = {
                            service         = "<service>"
                            deletion_policy = "<deletion_policy>"
                        }
                    }
                },
                <private_access2_name> = {
                    name          = "<private_access2_name>"
                    purpose       = "<purpose>"
                    address_type  = "<addres_type>"
                    prefix_length = (number) <prefix_length>

                    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection
                    peering_connection = (optional) {
                        <peering_connection1> = {
                            service         = "<service>"
                            deletion_policy = "<deletion_policy>"
                        }
                    }
                }
            }

            sql_instance = (optional) {
                # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
                sql_instance1 = {
                    # Note - Upon deletion of this instance the name, GCP will fail to recreate the instance with the same name for 7 days
                    name                = "<sql_instance_name>"
                    database_version    = "<sql_instance_database_version>"
                    deletion_protection = true or false

                    settings = {
                        tier              = "<sql_instance_tier>"
                        disk_type         = (optional) "<sql_instance_disk_type>"
                        # Size in GBs
                        disk_size         = (number) 10
                        availability_type = (optional) "<sql_instance_availability_type>"

                        ip_configuration = {
                            ipv4_enabled                                  = true or false
                            enable_private_path_for_google_cloud_services = (optional) true or false
                        }

                        # In case of MySQL databse version both should be true
                        backup_configuration = {
                            enabled            = true or false
                            binary_log_enabled = true or false
                        }
                    }

                    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
                    sql_database = {
                        name = "<sql_database_name>"
                    }

                    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user
                    sql_user = {
                        name               = "<sql_user_name>"
                        host_instance_name = "<compute_vm_name>"
                    }
                }
            }
        }
    }

    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
    instance_properties = (optional) {
        instance1 = {
            can_ip_forward      = true or false, default is false
            deletion_protection = true or false, default is false
            enable_display      = true or false, default is false
            machine_type        = "<machine_type>"
            name                = "<machine_name>"
            zone                = "<zone to create in>"
            tags                = [ "<tag>", "<tag>" ]

            boot_disk           = {
                boot_disk1 = {
                    auto_delete = true or false, default is true
                    device_name = "<device_name>"
                    mode        = "<disk_mode>", default is "READ_WRITE"

                    initialize_params = {
                        image = "<custom_image_name>"
                        size  = (optional) (number) 20
                        type  = (optional) "<machine_config_type>", default is "pd-balanced"
                    }
                }
            }

            labels = {
                goog-ec-src = optional(string, "vm_add-tf")
            }

            network_interface = {
                network_interface1 = {
                    access_config = {
                        network_tier = (optional) "<network_tier>", default is "PREMIUM"
                    }

                    queue_count = (optional) (number) <queue_count>, default is 0
                    stack_type  = (optional) "<stack_type>", default is "IPV4_ONLY"
                    subnetwork  = (optional) "<subnetwork>", default is ""
                }
            }

            scheduling = {
                scheduling1 = {
                    automatic_restart   = (optional) "<automatic_restart>", default is true
                    on_host_maintenance = (optional) "<on_host_maintenance>", default is "MIGRATE"
                    preemptible         = (optional) "<preemptible>", default is false
                    provisioning_model  = (optional) "<provisioning_model>", default is "STANDARD"
                }
            }

            service_account = {
                service_account1 = {
                    email  = "<service_account_email>"
                    scopes = [ "<account_permission>", "<account_permission>" ]
                }
            }

            shielded_instance_config = map(object({
                enable_integrity_monitoring = (optional) true or false
                enable_secure_boot          = (optional) true or false
                enable_vtpm                 = (optional) true or false
            }))
        }
    }
</ol>

`Note: If the variable file is named terraform.tfvars or terraform.tfvars.json it will automatically be picked up by terraform. The --var-file="*.tfvars" is not required to be passed to create or apply the plan`

## Initialize and validate the terraform files

 Run the initialize_terraform.sh file

```
# To convert the file to be executable
$ chmod 755 initialize_terraform.sh

# Execute bash script
$ ./initialize_terraform.sh
```


#### `Note: Make sure to initialize and setup default project on gcloud cli before running the below commands`

## Create a plan before building the infrastructure
Check and validate the plan created by terraform.

```
$ terraform plan -var-file="*.tfvars"
```

## Creating the infrastructure
Creates a plan to be reviewed before applying the changes, once the plan is verified type in `yes` to apply the plan.

```
$ terraform apply -var-file="*.tfvars"
```

## Creating the infrastructure
Destroys the reesources that have been created.

`Note: To destroy the resources it uses the terraform.tfstate file`

```
# To generate the destroy plan
$ terraform plan -destroy

# To destroy plan
$ terraform apply -destory
or
$ terraform destroy
```
