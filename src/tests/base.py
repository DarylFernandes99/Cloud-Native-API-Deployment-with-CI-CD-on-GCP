from flask_testing import TestCase
from src import app
from base64 import b64encode

class BaseTestCase(TestCase):
    def create_app(self):
        app.config['TESTING'] = True
        self.client = app.test_client()
        return app
    
    def get_basic_auth_token(self, username, password):
        credentials = f"{username}:{password}"
        credentials_bytes = credentials.encode('ascii')
        auth_token = b64encode(credentials_bytes).decode('ascii')
        return auth_token
