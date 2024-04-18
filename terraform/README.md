# Infrastructure Deployment with Terraform on Google Cloud Platform
This project utilizes Terraform for the dynamic construction of infrastructure on the Google Cloud Platform (GCP). Configuration details are conveniently provided through a variable file, ensuring flexibility and ease of customization.

## Resources used
<style>
    .grid-container {
        display: grid;
        /* gap: 10px; */
    }
    @media (min-width: 600px) {
        .grid-container {
            grid-template-columns: repeat(2, 1fr);
        }
    }
    @media (min-width: 800px) {
        .grid-container {
            grid-template-columns: repeat(3, 1fr);
        }
    }
    @media (min-width: 1024px) {
        .grid-container {
            grid-template-columns: repeat(4, 1fr);
        }
    }
    @media (min-width: 1280px) {
        .grid-container {
            grid-template-columns: repeat(5, 1fr);
        }
    }
</style>
<div class="grid-container">
    <div>
        <ul>
            <li>VPC [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network">Link</a>]</li>
            <li>Global Address [<a href="https://registry.terraform.io/providers/hashicorp/docs/resources/compute_global_address">Link</a>]</li>
            <li>SQL Database [<a href="https://registry.terraform.io/providers/latest/docs/resources/sql_database">Link</a>]</li>
            <li>KMS Crypto Key [<a href="https://registry.terraform.io/providers/latest/docs/resources/kms_crypto_key">Link</a>]</li>
            <li>Google Secret Manager Version [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version">Link</a>]</li>
            <li>Storage Bucket [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket">Link</a>]</li>
            <li>Cloud Function V2 [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions2_function">Link</a>]</li>
            <li>Global Forwarding Rule [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule">Link</a>]</li>
            <li>Backend Service [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service">Link</a>]</li>
            <li>Random Password [<a href="https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password">Link</a>]</li>
        </ul>
    </div>
    <div>
        <ul>
            <li>Subnet [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork">Link</a>]</li>
            <li>Peering Connection [<a href="https://registry.terraform.io/providers/latest/docs/resources/service_networking_connection">Link</a>]</li>
            <li>SQL User [<a href="https://registry.terraform.io/providers/latest/docs/resources/sql_user">Link</a>]</li>
            <li>Service Account [<a href="https://registry.terraform.io/providers/latest/docs/resources/sql_user">Link</a>]</li>
            <li>VM Instance [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance">Link</a>]</li>
            <li>Storage Bucket Object [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object">Link</a>]</li>
            <li>SSL Certificate [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate">Link</a>]</li>
            <li>Regional Instance Template [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_template">Link</a>]</li>
            <li>Regional Autoscaler [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_autoscaler">Link</a>]</li>
            <li>Network Peering Routes Config [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering_routes_config">Link</a>]</li>
        </ul>
    </div>
    <div>
        <ul>
            <li>Routes [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_route">Link</a>]</li>
            <li>Serverless VPC Access connector [<a href="https://registry.terraform.io/providers/latest/docs/resources/vpc_access_connector">Link</a>]</li>
            <li>KMS Key Ring [<a href="https://registry.terraform.io/providers/latest/docs/resources/kms_key_ring">Link</a>]</li>
            <li>IAM Policy [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam">Link</a>]</li>
            <li>DNS Managed Zone [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone">Link</a>]</li>
            <li>Pub/Sub Topic [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic">Link</a>]</li>
            <li>URL Map [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map">Link</a>]</li>
            <li>Health Check [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check">Link</a>]</li>
            <li>Template File [<a href="https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file">Link</a>]</li>
            <li>Firewall [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall">Link</a>]</li>
        </ul>
    </div>
    <div>
        <ul>
            <li>SQL Database Instance [<a href="https://registry.terraform.io/providers/latest/docs/resources/sql_database_instance">Link</a>]</li>
            <li>KMS Crypto Key [<a href="https://registry.terraform.io/providers/latest/docs/resources/kms_crypto_key">Link</a>]</li>
            <li>Google Secret Manager [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret">Link</a>]</li>
            <li>DNS Records Set [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set">Link</a>]</li>
            <li>Pub/Sub Topic Schema [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_schema">Link</a>]</li>
            <li>Target HTTPS Proxy [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy">Link</a>]</li>
            <li>Region Instance Group Manager [<a href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager">Link</a>]</li>
            <li>Random ID [<a href="https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id">Link</a>]</li>
        </ul>
    </div>
</div>


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
    <div class="grid-container">
        <div>
            <ul>
                <li>Compute Engine API</li>
                <li>Cloud SQL Admin API</li>
                <li>Service Networking API</li>
            </ul>
        </div>
        <div>
            <ul>
                <li>Cloud Source Repositories API</li>
                <li>Identity and Access Management (IAM) API</li>
                <li>Cloud Monitoring API</li>
            </ul>
        </div>
        <div>
            <ul>
                <li>Cloud Logging API</li>
                <li>Serverless VPC Access API</li>
                <li>Eventarc API</li>
            </ul>
        </div>
        <div>
            <ul>
                <li>Cloud Deployment Manager V2 API</li>
                <li>Cloud DNS API</li>
                <li>Cloud Functions API</li>
            </ul>
        </div>
        <div>
            <ul>
                <li>Artifact Registry API</li>
                <li>Cloud Pub/Sub API</li>
                <li>Cloud Build API</li>
            </ul>
        </div>
        <div>
            <ul>
                <li>Service Usage API</li>
                <li>Secret Manager API</li>
                <li>Certificate Manager API</li>
            </ul>
        </div>
        <div>
            <ul>
                <li>Cloud Key Management Service (KMS) API</li>
            </ul>
        </div>
    </div>
    <li>After enabling the APIs it may take about 10-15 mins to be activated</li>
</ol>

## Create Service account and give permissions
<ol>
    <li>Navigate to google cloud dashboard: <a href="https://console.cloud.google.com/welcome/new">https://console.cloud.google.com/welcome/new</a></li>
    <li>From the Navigation Menu > IAM and admin > Service accounts</li>
    <li>Create a new / modify the permissions of existing service account with the following permissions</li>
    
    Cloud SQL Editor
    Compute Instance Admin (v1)
    Compute Network Admin
    Compute Security Admin
    IAP-secured Tunnel User
    OSPolicyAssignment Editor
    Pub/Sub Publisher
    Secret Manager Secret Accessor
    Service Account Token Creator
    Service Account User
    Storage Object Viewer
</ol>

# Install terraform
Follow this URL to find the installer steps for your machine https://developer.hashicorp.com/terraform/install

## Create a input variable file

<ol>
    <li>Create a file named *.tfvars</li>
    <li>Add the data in the correct format (expected variables are mentioned in the variables.tf file)</li>
</ol>

`Note: If the variable file is named terraform.tfvars or terraform.tfvars.json it will automatically be picked up by terraform. The --var-file="*.tfvars" is not required to be passed to create or apply the plan`

## Initialize, format and validate the terraform files

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
