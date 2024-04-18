from flask import Flask
from flask_cors import CORS
import os
from src.config.config import Config
from src.config.log_formatter import LogFormatter
from dotenv import load_dotenv
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
import logging
from flask_swagger_ui import get_swaggerui_blueprint

# loading environment variables
load_dotenv()

# declaring flask application
app = Flask(__name__, static_url_path='/static', static_folder='../static')

# Setting up CORS
CORS(app)

# calling the dev configuration
config = Config().production_config if os.environ.get("PYTHON_ENV") == "production" else Config().dev_config

# making our application to use env
app.env = config.ENV

# Configure Google Pub/Sub
from src.config.pub_sub_config import Pub_Sub
project_id = os.environ.get("GOOGLE_PROJECT_ID")
topic_name = os.environ.get("GOOGLE_TOPIC_NAME")
pub_sub_config = Pub_Sub(project_id, topic_name)

# Configure Flask logging
app.logger.setLevel(config.LOG_LEVEL)  # Set log level to INFO
logger_path = "./logs"
if not os.path.exists(logger_path):
    os.makedirs(logger_path)
handler = logging.FileHandler(logger_path + "/logfile.log")  # Log to a file
# adding timestamp formatter
formatter = logging.Formatter('{"timestamp":"%(asctime)s", "level":"%(levelname)s", "logger":"%(module)s", "message":"%(message)s"}')
handler.setFormatter(formatter)
handler.format = LogFormatter.custom_formatter
app.logger.addHandler(handler)

# Setting up Bcrypt
from flask_bcrypt import Bcrypt
bcrypt = Bcrypt(app)

app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get("SQLALCHEMY_DATABASE_URI_DEV")
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = os.environ.get("SQLALCHEMY_TRACK_MODIFICATIONS")

# sql alchemy instance
db = SQLAlchemy(app)
# Flask Migrate instance to handle migrations
migrate = Migrate(app, db)
# import models to let the migrate tool know
from src.models.users_model import Users

# import api blueprint to register it with app
from src.routes import api
app.register_blueprint(api, url_prefix = "/")

# Creating swagger documentation of APIs
SWAGGER_URL="/docs"
API_URL="/static/swagger.json"

swagger_ui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={
        'app_name': 'Health API'
    }
)
app.register_blueprint(swagger_ui_blueprint, url_prefix=SWAGGER_URL)
