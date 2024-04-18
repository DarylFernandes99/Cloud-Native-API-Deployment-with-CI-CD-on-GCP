# Cloud-Native API Deployment with CI/CD on Google Cloud Platform (GCP)
This repository encompasses a web application backend utilizing Python 3.8 and MySQL, performing a series of tasks: health check **(GET - /healthz)**, user creation **(POST - /v1/user)** with a subsequent verification email sent to the user, retrieval of user details **(GET - /v1/user/self)**, and user details update **(PUT - /v1/user/self)**. Upon user creation, a message is dispatched to GCP Pub/Sub, triggering a serverless function responsible for emailing the user with a unique verification link. Terraform is utilized to configure all necessary resources for the app setup.

Several GitHub workflows are established for Continuous Integration and Continuous Deployment. These workflows activate upon pull request creation, executing functional tests on the webapp backend to detect failures and examining the packer code formatting. Post successful workflow execution and code merging, packer is employed to generate a golden image of the application, configuring all essential libraries/dependencies. Subsequently, the existing instances in the GCP project are replaced with the updated packer image.

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

## Add Service Account key to the environment vairable
### Create JSON key for the service account
<ol>
    <li>Navigate to google cloud dashboard: <a href="https://console.cloud.google.com/welcome/new">https://console.cloud.google.com/welcome/new</a></li>
    <li>From the Navigation Menu > IAM and admin > Service accounts</li>
    <li>Click on the service account to be used</li>
    <li>Under "KEYS" tab, click on "ADD KEY" dropdown and select "Create new key"</li>
</ol>

```
# After downloading the JSON key file, run the following
$ export GOOGLE_APPLICATION_CREDENTIALS="<path to key>/<file_name>.json"
```

# Install packer
Follow this URL to find the installer steps for your machine https://developer.hashicorp.com/packer/install

## Choosing the OS family
https://cloud.google.com/compute/docs/images/os-details

## Create a input variable file

<ol>
    <li>Create a file named *.pkrvars.hcl</li>
    <li>Add the data in the format shown below (expected variables are mentioned in the variables.tf file):</li>
    
    project_id          = "<project_id>"
    zone                = "<project_zone>"
    machine_type        = "<machine_type>"
    ssh_username        = "<name_of_the_service_account>"
    use_os_login        = false or true
    source_image_family = "<os_family>"
    webapp_version      = <webapp_version>
    mysql_root_password = <mysql_password to be created for 'root' user>
</ol>

`Note: If the variable file is named *.auto.pkrvars.hcl it will automatically be picked up by packer. The --var-file="*.pkrvars.hcl" is not required to be passed to validate or build the image`

## Formatting packer code
Formatting the packer code

```
$ packer fmt <file_name or .>
```

## Validate packer config
Check and validate the packer config to be created created

```
$ packer validate -var-file="*.pkrvars.hcl" <file_name or .>
```

## Building image by packer
Building the image using packer

```
$ packer build -var-file="*.pkrvars.hcl" <file_name or .>
```

# Starting the application

## Create and activate python3 environment using the following command

```
# Create environment
$ python -m venv <env_name>

# Activating environment
## For mac and linux os users
$ source <env_name>/bin/activate

## For windows users
$ <env_name>/Scripts/activate
```

## Install required packages from the requirements file

```
$ pip install -r requirements.txt
```

## Create .env file in with the following key value pairs</h3>

``Note: Update the DEV_HOST, DEV_PORT, PROD_HOST, PROD_PORT based on the requirement``
```
SQLALCHEMY_DATABASE_URI_DEV = "mysql://<USERNAME>:<PASSWORD>@<HOST>:<PORT>/<DBNAME>"
# The following flag can toggle on/off the tracking of inserts, updates, and deletes for models
SQLALCHEMY_TRACK_MODIFICATIONS = False
DEV_HOST = "0.0.0.0"
DEV_PORT = 8080
PROD_HOST = "0.0.0.0"
PROD_PORT = 8080
PYTHON_ENV = "development"
GOOGLE_PROJECT_ID = "<gcp_project_id>"
GOOGLE_TOPIC_NAME = "<pub/sub_topic_name>"
```

## Run the create_databse.py to create the database if it does not exists</h3>

```
$ python create_database.py
```


## Run the following scripts to create table schema in the database</h3>

```
$ flask db init
$ flask db migrate
$ flask db upgrade
```


## To run the tests</h3>

```
# Run the following command to run the tests
$ python -m pytest
```

## To run the app</h3>

```
# Run the following command to start the server
$ python ./app.py
```

# To run GitHub Workflows
### Add the secrets to the Repository secrets</li>
<ol>
    <li>Go to repository settings</li>
    <li>Under "Secrets and variables", select "Actions"</li>
    <li>Create "New repository secrets" for the following:</li>
    
    # To run integration tests workflow
    DB_PASSWORD: <password of the database> ('root' works in most cases)
    DB_USER: <user of the database> ('root' works in most cases)
    ENV_FILE: Add the contents of the webapp .env file with the above user and password for databse URI
    
    # To run packer workflows
    GCP_CREDENTIALS_JSON: Add the contents of the JSON key file created for the service account
    PACKER_CONFIG: Add the content of the *.pkrvars.hcl or *.auto.pkrvars.hcl file
</ol>
