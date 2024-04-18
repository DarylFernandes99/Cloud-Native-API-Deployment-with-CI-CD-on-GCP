import os
import uuid
import requests
from dotenv import load_dotenv
from .mail_template import MailTemplate
from .db_config import DB
from models.users_model import Users
from datetime import datetime
from base64 import b64encode
from urllib.parse import quote
from config.log_config import Logger

load_dotenv()
# Initialize the logger
logger = Logger()

class MailgunConfig:
    def __init__(self) -> None:
        self.domain_name = os.environ.get("DOMAIN_NAME")
        self.domain_name_url = os.environ.get("DOMAIN_NAME_URL")
        self.mailgun_version = os.environ.get("MAILGUN_VERSION")
        self.mailgun_api_key = os.environ.get("MAILGUN_API_KEY")
        self.mailgun_sender_email = f"support@{self.domain_name}"
        self.mail_template = MailTemplate()
        self.db = DB()
        self.conn = self.db.create_connection()
        self.users = Users().users_schema
        self.logging = logger.logging
    
    def configure_message(self, to: str, subject: str, message: str) -> dict:
        self.logging.info("Configured message payload")
        return {
            "from": self.mailgun_sender_email,
            "to": to,
            "subject": subject,
            "html": message
        }

    def send_verification_mail(self, user_data: dict) -> None:
        try:
            verification_token = str(uuid.uuid4())
            data = f'{user_data["username"]}:{verification_token}'
            data = quote(b64encode(data.encode()).decode("utf-8"))
            verification_link = f"/v1/user/self/verify?data={data}"
            self.logging.info("Generated verification link")

            user_data_fetched = self.users.select().where(self.users.c.username == user_data["username"])
            result = self.conn.execute(user_data_fetched)
            result = result.all()
            if len(result) == 0:
                self.logging.warning("Could not find the user")
                print("User not found")
            else:
                response = requests.post(
                    f"https://api.mailgun.net/{self.mailgun_version}/{self.domain_name}/messages",
                    auth = ("api", self.mailgun_api_key),
                    data = self.configure_message(user_data["username"], "Verification Email", self.mail_template.default_template(verification_link, self.domain_name_url, user_data))
                )
                if response.status_code == 200:
                    self.logging.info("Verification email sent successfully")
                    update_user = self.users.update().where(self.users.c.username == user_data["username"]).values({"verification_token": verification_token, "mail_sent_time": datetime.now()})
                    self.conn.execute(update_user)
                    self.conn.commit()
                    self.logging.info("Updated verification token and time in database")
                else:
                    self.logging.warning("Failed to send verification email")
                    print("Failed to send verification email")
        except Exception as e:
            self.logging.error("Failed - {}".format(str(e)))
