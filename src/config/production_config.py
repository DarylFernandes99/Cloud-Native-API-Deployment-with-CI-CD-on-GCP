import os
from dotenv import load_dotenv

# loading environment variables
load_dotenv()

class ProductionConfig:
    def __init__(self):
        self.ENV = "production"
        self.DEBUG = False
        self.PORT = os.environ.get('PROD_PORT')
        self.HOST = os.environ.get('PROD_HOST')
