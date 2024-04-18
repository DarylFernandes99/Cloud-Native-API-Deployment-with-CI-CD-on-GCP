import json
import base64
import functions_framework
from config.mailgun_config import MailgunConfig
from config.log_config import Logger

# Initialize the logger
logger = Logger()

# Triggered from a message on a Cloud Pub/Sub topic.
@functions_framework.cloud_event
def send_email(cloud_event):
    mailgun_config = MailgunConfig()
    
    # Get message published
    message_data = json.loads(base64.b64decode(cloud_event.data["message"]["data"]).decode())
    logger.logging.info("Received published message")

    try:
        mailgun_config.send_verification_mail(message_data)
    except Exception as e:
        logger.logging.error("Failed to send verification email - {}".format(str(e)))
