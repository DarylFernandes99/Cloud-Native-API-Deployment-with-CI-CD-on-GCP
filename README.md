# Cloud-Native API Deployment with CI/CD on Google Cloud Platform

[![Integration Tests](https://github.com/DarylFernandes99/Cloud-Native-API-Deployment-with-CI-CD-on-GCP/actions/workflows/integration_test.yml/badge.svg)](https://github.com/DarylFernandes99/Cloud-Native-API-Deployment-with-CI-CD-on-GCP/actions/workflows/integration_test.yml)
[![Packer Build](https://github.com/DarylFernandes99/Cloud-Native-API-Deployment-with-CI-CD-on-GCP/actions/workflows/packer_build_image.yml/badge.svg)](https://github.com/DarylFernandes99/Cloud-Native-API-Deployment-with-CI-CD-on-GCP/actions/workflows/packer_build_image.yml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## 📑 Table of Contents

- [🚀 Project Overview](#-project-overview)
  - [✨ Key Features](#-key-features)
- [🏗️ Architecture](#️-architecture)
  - [Infrastructure Components](#infrastructure-components)
  - [Event-Driven Workflow](#event-driven-workflow)
- [📁 Project Structure](#-project-structure)
- [🚦 Getting Started](#-getting-started)
  - [📋 Prerequisites](#-prerequisites)
  - [🔧 Installation & Setup](#-installation--setup)
- [🔐 API Configuration](#-api-configuration)
- [👤 Service Account Configuration](#-service-account-configuration)
  - [Create Service Account](#create-service-account)
  - [Generate Service Account Key](#generate-service-account-key)
- [🏗️ Infrastructure Deployment](#️-infrastructure-deployment)
  - [Building VM Images with Packer](#building-vm-images-with-packer)
  - [Deploying Infrastructure with Terraform](#deploying-infrastructure-with-terraform)
- [🧪 Local Development](#-local-development)
  - [Initialize Database](#initialize-database)
  - [Run Tests](#run-tests)
  - [Start Development Server](#start-development-server)
  - [API Testing](#api-testing)
- [📊 API Documentation](#-api-documentation)
  - [Authentication](#authentication)
  - [Endpoints](#endpoints)
  - [Data Models](#data-models)
  - [Validation Rules](#validation-rules)
- [🚀 CI/CD Pipeline](#-cicd-pipeline)
  - [GitHub Actions Workflows](#github-actions-workflows)
  - [Required GitHub Secrets](#required-github-secrets)
- [📧 Email Verification System](#-email-verification-system)
  - [Serverless Function Architecture](#serverless-function-architecture)
  - [Mailgun Configuration](#mailgun-configuration)
  - [Deployment](#deployment)
- [📈 Monitoring & Logging](#-monitoring--logging)
  - [Google Cloud Operations](#google-cloud-operations)
  - [Log Configuration](#log-configuration)
- [🔒 Security Features](#-security-features)
  - [Encryption](#encryption)
  - [Network Security](#network-security)
  - [Identity & Access Management](#identity--access-management)
- [🔧 Troubleshooting](#-troubleshooting)
  - [Common Issues](#common-issues)
  - [Health Checks](#health-checks)
- [🤝 Contributing](#-contributing)
  - [Development Guidelines](#development-guidelines)
- [📝 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)
- [📞 Support](#-support)

## 🚀 Project Overview

This project demonstrates a production-ready, cloud-native REST API deployment with a comprehensive CI/CD pipeline on Google Cloud Platform. It showcases modern DevOps practices, infrastructure automation, and cloud-native architecture patterns.

### ✨ Key Features

**🔹 RESTful API Endpoints:**
- Health Check (`GET /healthz`) - Application health monitoring
- User Registration (`POST /v1/user`) - Account creation with email verification
- User Profile (`GET /v1/user/self`) - Authenticated user information retrieval
- User Profile Update (`PUT /v1/user/self`) - Profile modification
- Email Verification (`GET /v1/user/self/verify`) - Account verification workflow

**🔹 Cloud-Native Architecture:**
- **Backend**: Python 3.8 Flask application with SQLAlchemy ORM
- **Database**: Google Cloud SQL (MySQL) with encryption at rest
- **Infrastructure**: Terraform for Infrastructure as Code (IaC)
- **Images**: Packer for immutable VM image creation
- **Messaging**: Pub/Sub for event-driven architecture
- **Serverless**: Cloud Functions for email processing
- **Security**: Customer-Managed Encryption Keys (CMEK), IAM, and Secret Manager

**🔹 CI/CD Pipeline:**
- **Testing**: Automated unit and integration tests
- **Validation**: Infrastructure and configuration validation
- **Building**: Automated artifact and image building
- **Deployment**: Immutable infrastructure deployment with rolling updates

**🔹 Production Features:**
- Auto-scaling VM instances with health checks
- Load balancing with SSL termination
- Comprehensive logging and monitoring
- Email verification via Mailgun integration
- Secure secrets management
- Network isolation and firewall rules

## 🏗️ Architecture

![GCP Infrastructure Architecture](architecture.png)

### Infrastructure Components

| Component | Service | Purpose |
|-----------|---------|---------|
| **Compute** | Google Compute Engine | Auto-scaled VM instances hosting the Flask application |
| **Database** | Google Cloud SQL | Managed MySQL database with automatic backups |
| **Messaging** | Google Pub/Sub | Event-driven messaging for user registration events |
| **Functions** | Google Cloud Functions | Serverless email verification processing |
| **Storage** | Google Cloud Storage | Application artifacts and logs |
| **Security** | Google Secret Manager | Secure credential and configuration storage |
| **Encryption** | Google Cloud KMS | Customer-managed encryption keys |
| **Networking** | Google VPC | Private networking with custom subnets and routing |
| **DNS** | Google Cloud DNS | Domain name management and resolution |
| **Load Balancing** | Google Cloud Load Balancer | Traffic distribution with health checks |
| **Monitoring** | Google Cloud Operations | Comprehensive logging, monitoring, and alerting |

### Event-Driven Workflow

1. **User Registration** → Flask API validates and stores user data
2. **Event Publishing** → User creation triggers Pub/Sub message
3. **Serverless Processing** → Cloud Function processes verification email
4. **Email Delivery** → Mailgun sends verification email to user
5. **Verification** → User clicks link to verify account

## 📁 Project Structure

```
cloud-native-api/
├── 📁 .github/workflows/           # GitHub Actions CI/CD workflows
│   ├── integration_test.yml        # Automated testing pipeline
│   ├── packer_build_image.yml      # VM image building pipeline
│   ├── packer_validate.yml         # Packer configuration validation
│   ├── terraform_validate.yml      # Terraform configuration validation
│   └── test_pull.yml               # Pull request testing
├── 📁 gcloud_cli/                  # GCP CLI automation scripts
│   └── create_instance_template.sh # VM instance template creation
├── 📁 packer/                      # Packer VM image configuration
│   ├── 📁 files/                   # Configuration files for VM setup
│   │   ├── cloud_ops_agent_config.yaml
│   │   └── csye6225.service
│   ├── 📁 scripts/                 # VM provisioning scripts
│   │   ├── enable_csye6225_service.sh
│   │   ├── install_ops_agent.sh
│   │   ├── install_python3.sh
│   │   ├── setup_logs.sh
│   │   ├── setup_user.sh
│   │   ├── setup_webapp.sh
│   │   ├── unzip_artifact.sh
│   │   └── update_centos.sh
│   ├── packer_build.pkr.hcl        # Main Packer build configuration
│   ├── packer_plugin.pkr.hcl       # Packer plugin requirements
│   ├── packer_source.pkr.hcl       # VM source configuration
│   └── variables.pkr.hcl           # Packer variables
├── 📁 serverless/                  # Cloud Function for email verification
│   ├── 📁 config/                  # Serverless configuration
│   │   ├── db_config.py            # Database connection config
│   │   ├── log_config.py           # Logging configuration
│   │   ├── mailgun_config.py       # Email service configuration
│   │   └── mail_template.py        # Email template definitions
│   ├── 📁 models/                  # Data models for serverless function
│   │   └── users_model.py          # User data model
│   ├── main.py                     # Cloud Function entry point
│   ├── requirements.txt            # Serverless dependencies
│   └── README.md                   # Serverless deployment guide
├── 📁 src/                         # Main Flask application source code
│   ├── 📁 config/                  # Application configuration
│   │   ├── config.py               # Main configuration handler
│   │   ├── dev_config.py           # Development environment config
│   │   ├── production_config.py    # Production environment config
│   │   ├── pub_sub_config.py       # Pub/Sub integration config
│   │   └── log_formatter.py        # Custom log formatting
│   ├── 📁 controllers/             # API request handlers
│   │   ├── health_check_controller.py
│   │   └── users_controller.py
│   ├── 📁 middlewares/             # Request/response middleware
│   │   ├── auth_middleware.py      # Authentication middleware
│   │   └── format_user_data.py     # Data formatting utilities
│   ├── 📁 models/                  # SQLAlchemy data models
│   │   └── users_model.py          # User database model
│   ├── 📁 services/                # Business logic services
│   ├── 📁 tests/                   # Unit and integration tests
│   │   ├── 📁 User/                # User-specific tests
│   │   │   └── user_test.py
│   │   └── base.py                 # Test base classes
│   ├── routes.py                   # API route definitions
│   └── utils.py                    # Utility functions
├── 📁 static/                      # Static files
│   └── swagger.json                # API documentation
├── 📁 terraform/                   # Infrastructure as Code
│   ├── 📁 modules/                 # Terraform modules for GCP resources
│   │   ├── autoscaler.tf           # Auto-scaling configuration
│   │   ├── cloud_dns_zone.tf       # DNS zone management
│   │   ├── cloud_function2.tf      # Cloud Functions setup
│   │   ├── cmek_key_ring.tf        # Encryption key management
│   │   ├── compute_instance_template.tf
│   │   ├── compute_vm.tf           # VM instance configuration
│   │   ├── firewall.tf             # Network security rules
│   │   ├── locals.tf               # Local values and calculations
│   │   ├── managed_ssl.tf          # SSL certificate management
│   │   ├── private_access.tf       # Private service access
│   │   ├── pub_sub.tf              # Pub/Sub topic and subscriptions
│   │   ├── route.tf                # Network routing configuration
│   │   ├── secret_manager.tf       # Secrets management
│   │   ├── serverless_vpc_connector.tf
│   │   ├── service_account.tf      # IAM service accounts
│   │   ├── sql_instance.tf         # Cloud SQL database
│   │   ├── startup_script.sh       # VM startup automation
│   │   ├── storage_bucket.tf       # Cloud Storage buckets
│   │   ├── subnets.tf              # VPC subnet configuration
│   │   ├── variables.tf            # Module variables
│   │   └── vpc.tf                  # Virtual Private Cloud setup
│   ├── main.tf                     # Main Terraform configuration
│   ├── provider.tf                 # GCP provider configuration
│   ├── variables.tf                # Root module variables
│   └── README.md                   # Infrastructure deployment guide
├── app.py                          # Flask application entry point
├── create_database.py              # Database initialization script
├── requirements.txt                # Python dependencies
├── run_tests.sh                    # Test execution script
├── architecture.png                # Architecture diagram
└── LICENSE                         # GNU GPL v3 license
```

## 🚦 Getting Started

### 📋 Prerequisites

Before setting up the project, ensure you have the following installed and configured:

**Required Tools:**
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (latest version)
- [Terraform](https://developer.hashicorp.com/terraform/install) (>= 1.0)
- [Packer](https://developer.hashicorp.com/packer/install) (>= 1.7)
- [Python 3.8+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

**GCP Requirements:**
- Google Cloud Platform account with billing enabled
- GCP project with Owner or Editor permissions
- Enabled APIs (see [API Configuration](#-api-configuration))

### 🔧 Installation & Setup

#### 1. Clone the Repository

```bash
git clone https://github.com/DarylFernandes99/Cloud-Native-API-Deployment-with-CI-CD-on-GCP.git
cd cloud-native-api
```

#### 2. Configure Google Cloud SDK

```bash
# Authenticate with your Google account
gcloud auth login
gcloud auth application-default login

# Set your default project
gcloud config set project YOUR_PROJECT_ID

# Verify configuration
gcloud config list
```

#### 3. Set Up Python Environment

```bash
# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

#### 4. Configure Environment Variables

Create a `.env` file in the project root:

```bash
# Database Configuration
SQLALCHEMY_DATABASE_URI_DEV="mysql://username:password@localhost:3306/webapp"
SQLALCHEMY_TRACK_MODIFICATIONS=False

# Application Configuration
DEV_HOST="0.0.0.0"
DEV_PORT=8080
PROD_HOST="0.0.0.0"
PROD_PORT=8080
PYTHON_ENV="development"

# GCP Configuration
GOOGLE_PROJECT_ID="your-gcp-project-id"
GOOGLE_TOPIC_NAME="verify_email"
```

For the serverless function, create `serverless/.env`:

```bash
# Mailgun Configuration
MAILGUN_VERSION="v3"
MAILGUN_API_KEY="your-mailgun-api-key"
DOMAIN_NAME="yourdomain.com"
DOMAIN_NAME_URL="https://yourdomain.com"
```

## 🔐 API Configuration

### Enable Required Google Cloud APIs

Navigate to the [Google Cloud Console API Library](https://console.cloud.google.com/apis/library) and enable the following APIs:

```bash
# Enable APIs via CLI
gcloud services enable compute.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable sourcerepo.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable vpcaccess.googleapis.com
gcloud services enable eventarc.googleapis.com
gcloud services enable deploymentmanager.googleapis.com
gcloud services enable dns.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable pubsub.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable serviceusage.googleapis.com
gcloud services enable secretmanager.googleapis.com
gcloud services enable certificatemanager.googleapis.com
gcloud services enable cloudkms.googleapis.com
```

**⚠️ Note:** API activation may take 10-15 minutes to become fully effective.

## 👤 Service Account Configuration

### Create Service Account

1. Navigate to [IAM & Admin > Service accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
2. Click "Create Service Account"
3. Assign the following roles:

**Required IAM Roles:**
- Cloud SQL Editor
- Compute Instance Admin (v1)
- Compute Network Admin
- Compute Security Admin
- IAP-secured Tunnel User
- OSPolicyAssignment Editor
- Pub/Sub Publisher
- Secret Manager Secret Accessor
- Service Account Token Creator
- Service Account User
- Storage Object Viewer

### Generate Service Account Key

```bash
# Create and download service account key
gcloud iam service-accounts keys create ~/gcp-key.json \
    --iam-account=YOUR_SERVICE_ACCOUNT@YOUR_PROJECT.iam.gserviceaccount.com

# Set environment variable
export GOOGLE_APPLICATION_CREDENTIALS="~/gcp-key.json"
```

## 🏗️ Infrastructure Deployment

### Building VM Images with Packer

#### 1. Create Packer Variables File

Create `packer/variables.auto.pkrvars.hcl`:

```hcl
project_id          = "your-gcp-project-id"
zone                = "us-central1-a"
machine_type        = "e2-medium"
ssh_username        = "packer"
use_os_login        = false
source_image_family = "centos-stream-8"
webapp_version      = "1.0.0"
mysql_root_password = "your-secure-mysql-password"
```

#### 2. Validate and Build Image

```bash
cd packer/

# Initialize Packer
packer init .

# Validate configuration
packer validate .

# Build VM image
packer build .
```

### Deploying Infrastructure with Terraform

#### 1. Create Terraform Variables

Create `terraform/terraform.tfvars` with your specific configuration:

```hcl
# Basic Configuration
name       = "webapp"
project_id = "your-gcp-project-id"
region     = "us-central1"
zone       = "us-central1-a"

# VPC Configuration
vpc_config = {
  main = {
    name                            = "webapp-vpc"
    auto_create_subnetworks         = false
    routing_mode                    = "REGIONAL"
    delete_default_routes_on_create = false
    mtu                             = 1460

    subnets = {
      webapp = {
        name          = "webapp-subnet"
        ip_cidr_range = "10.0.1.0/24"
      }
    }

    # Additional VPC configuration...
  }
}

# Add other required variables...
```

#### 2. Deploy Infrastructure

```bash
cd terraform/

# Initialize Terraform
terraform init

# Format and validate
terraform fmt
terraform validate

# Plan deployment
terraform plan

# Apply changes
terraform apply
```

## 🧪 Local Development

### Initialize Database

```bash
# Create database if it doesn't exist
python create_database.py

# Set up Flask migrations
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
```

### Run Tests

```bash
# Run all tests
chmod +x run_tests.sh
./run_tests.sh

# Or run tests manually
python -m pytest src/tests/ -v

# Run specific test
python -m pytest src/tests/User/user_test.py::TestUser::test_create_user -v
```

### Start Development Server

```bash
# Run the Flask application
python app.py

# Or with Flask CLI
export FLASK_APP=app.py
export FLASK_ENV=development
flask run --host=0.0.0.0 --port=8080
```

The API will be available at `http://localhost:8080`

### API Testing

```bash
# Health check
curl -X GET http://localhost:8080/healthz

# Create user
curl -X POST http://localhost:8080/v1/user \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "John",
    "last_name": "Doe",
    "username": "john.doe@example.com",
    "password": "SecurePass123!"
  }'

# Get user profile (with basic auth)
curl -X GET http://localhost:8080/v1/user/self \
  -u "john.doe@example.com:SecurePass123!"
```

## 📊 API Documentation

### Authentication

The API uses HTTP Basic Authentication for protected endpoints. Include credentials in the Authorization header:

```
Authorization: Basic base64(username:password)
```

### Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| `GET` | `/healthz` | Health check endpoint | No |
| `POST` | `/v1/user` | Create new user account | No |
| `GET` | `/v1/user/self` | Get authenticated user profile | Yes |
| `PUT` | `/v1/user/self` | Update user profile | Yes |
| `GET` | `/v1/user/self/verify` | Verify email address | No |

### Data Models

**User Model:**
```json
{
  "id": "uuid",
  "first_name": "string",
  "last_name": "string", 
  "username": "email",
  "account_created": "datetime",
  "account_updated": "datetime"
}
```

### Validation Rules

- **Names**: 2+ characters, letters and spaces only
- **Email**: Valid email format
- **Password**: 8+ characters with uppercase, lowercase, number, and special character

## 🚀 CI/CD Pipeline

### GitHub Actions Workflows

The project includes several automated workflows:

#### 1. Integration Tests (`integration_test.yml`)
- **Trigger**: Pull requests to main branch
- **Actions**: 
  - Sets up MySQL database
  - Installs Python dependencies
  - Runs database migrations
  - Executes pytest test suite

#### 2. Packer Image Build (`packer_build_image.yml`)
- **Trigger**: Push to main branch
- **Actions**:
  - Creates application artifact
  - Builds VM image with Packer
  - Deploys new instance template
  - Performs rolling update

#### 3. Configuration Validation
- **Packer Validation**: Validates Packer configurations
- **Terraform Validation**: Validates Terraform configurations

### Required GitHub Secrets

Configure the following secrets in your GitHub repository:

**For Integration Tests:**
```
DB_PASSWORD=your-test-db-password
DB_USER=your-test-db-user  
ENV_FILE=contents-of-env-file
```

**For Packer Workflows:**
```
GCP_CREDENTIALS_JSON=contents-of-service-account-json
PACKER_CONFIG=contents-of-packer-variables-file
PACKER_ENV_FILE=contents-of-packer-env-file
```

**For Continuous Deployment:**
```
webapp-cd-config=deployment-configuration
webapp-kms-key=encryption-key-configuration
webapp-startup-script=vm-startup-script
```

## 📧 Email Verification System

### Serverless Function Architecture

The email verification system uses Google Cloud Functions triggered by Pub/Sub messages:

1. **User Registration** triggers a Pub/Sub message
2. **Cloud Function** processes the message
3. **Mailgun API** sends verification email
4. **User clicks** verification link
5. **API endpoint** validates and activates account

### Mailgun Configuration

1. Sign up for [Mailgun](https://www.mailgun.com/)
2. Add your domain and verify DNS records
3. Get your API key from the dashboard
4. Configure environment variables in `serverless/.env`

### Deployment

```bash
# Deploy serverless function
gcloud functions deploy send_email \
  --runtime python39 \
  --trigger-topic verify_email \
  --source ./serverless/ \
  --entry-point send_email
```

## 📈 Monitoring & Logging

### Google Cloud Operations

The application integrates with Google Cloud Operations for comprehensive monitoring:

**Logging:**
- Application logs via Cloud Logging API
- Structured JSON logging with correlation IDs
- Custom log filters and alerts

**Monitoring:**
- Custom metrics for API performance
- Health check monitoring
- Resource utilization tracking
- Auto-scaling metrics

**Alerting:**
- High error rate alerts
- Database connection failures
- Infrastructure health alerts

### Log Configuration

Application logs are automatically collected by the Cloud Operations agent and include:

- Request/response logging
- Database query logging  
- Error tracking with stack traces
- Performance metrics

## 🔒 Security Features

### Encryption
- **Data at Rest**: Customer-Managed Encryption Keys (CMEK)
- **Data in Transit**: TLS 1.2+ for all connections
- **Database**: Cloud SQL encryption with customer keys

### Network Security
- **VPC**: Private networking with custom subnets
- **Firewall Rules**: Restrictive ingress/egress rules
- **SSL Termination**: Managed SSL certificates
- **Private Access**: Database accessible only from VPC

### Identity & Access Management
- **Service Accounts**: Principle of least privilege
- **IAM Roles**: Granular permission control
- **Secrets Management**: Centralized secret storage
- **Authentication**: Basic Auth with bcrypt password hashing

## 🔧 Troubleshooting

### Common Issues

**Database Connection Errors:**
```bash
# Check Cloud SQL instance status
gcloud sql instances describe INSTANCE_NAME

# Verify network connectivity
gcloud compute ssh VM_NAME --command="nc -zv DB_IP 3306"
```

**Packer Build Failures:**
```bash
# Enable detailed logging
export PACKER_LOG=1
packer build .

# Check service account permissions
gcloud projects get-iam-policy PROJECT_ID
```

**Terraform Deployment Issues:**
```bash
# Check Terraform state
terraform show

# Refresh state
terraform refresh

# Import existing resources
terraform import google_compute_instance.default projects/PROJECT/zones/ZONE/instances/INSTANCE
```

### Health Checks

**Application Health:**
```bash
curl -f http://YOUR_DOMAIN/healthz || echo "Health check failed"
```

**Database Health:**
```bash
# Test database connection
python -c "
from sqlalchemy import create_engine
engine = create_engine('YOUR_DB_URI')
print('Connected!' if engine.connect() else 'Failed!')
"
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow PEP 8 style guidelines
- Add tests for new features
- Update documentation for changes
- Ensure all CI/CD checks pass

## 📝 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Google Cloud Platform for infrastructure services
- Mailgun for email delivery services
- The Flask and SQLAlchemy communities
- HashiCorp for Terraform and Packer

## 📞 Support

For support and questions:

1. Check the [Issues](https://github.com/DarylFernandes99/Cloud-Native-API-Deployment-with-CI-CD-on-GCP/issues) section
2. Review the [Troubleshooting](#-troubleshooting) guide
3. Create a new issue with detailed information

---

**Built with ❤️ for the cloud-native community**
