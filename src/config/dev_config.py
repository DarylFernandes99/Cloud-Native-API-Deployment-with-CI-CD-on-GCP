import os
from dotenv import load_dotenv

# loading environment variables
load_dotenv()

class DevConfig:
    def __init__(self):
        self.ENV = "development"
        self.DEBUG = True
        self.PORT = os.environ.get('DEV_PORT')
        self.HOST = os.environ.get('DEV_HOST')
