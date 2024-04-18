# Google Serverless function (Cloud Function)
This project involves the deployment of a cloud function that activates upon the publishing of a message in a Pub/Sub topic. This function is responsible for dispatching a unique verification link to a newly registered user through email. The delivery of emails to users is facilitated by Mailgun.

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

Mailgun setup - https://documentation.mailgun.com/docs/mailgun/quickstart-guide/quickstart/
```
MAILGUN_VERSION = "<mailgun_api_version>"
MAILGUN_API_KEY = "<mailgun_api_key>"
DOMAIN_NAME     = "<domain_name>"
DOMAIN_NAME_URL = "<complete_domain_name (including port and protocol)>"
```
