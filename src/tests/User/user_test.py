import json
from src.tests.base import BaseTestCase
from src import db
from src.models.users_model import Users

class UsersTest(BaseTestCase):
    def test_create_account(self):
        data = {
            "first_name": "abcd",
            "last_name": "abcd",
            "username": "abcd1@gmail.com",
            "password": "Abcd@1234"
        }

        response = self.client.post('/v1/user', data=json.dumps(data), content_type="application/json")
        assert response.status_code == 201
        
        # Verify account
        user_data = Users.query.filter_by(username = data["username"]).first()
        user_data.is_verified = True
        db.session.commit()

        auth_token = self.get_basic_auth_token(data['username'], data['password'])
        get_response = self.client.get('/v1/user/self', headers={'Authorization': f'Basic {auth_token}'})
        assert get_response.status_code == 200

        user_data = json.loads(get_response.data.decode('utf-8'))
        assert user_data["username"] == data["username"]
    
    def test_update_account(self):
        data = {
            "first_name": "abcdef",
            "last_name": "abcdghi",
            "password": "Abcd@12345"
        }
        
        old_password = "Abcd@1234"
        username = "abcd1@gmail.com"
        auth_token = self.get_basic_auth_token(username, old_password)

        response = self.client.put('/v1/user/self', data=json.dumps(data), content_type='application/json', headers={'Authorization': f'Basic {auth_token}'})
        assert response.status_code == 200
        
        auth_token = self.get_basic_auth_token(username, data['password'])
        get_response = self.client.get('/v1/user/self', headers={'Authorization': f'Basic {auth_token}'})
        assert get_response.status_code == 200

        user_data = json.loads(get_response.data.decode('utf-8'))
        assert user_data["first_name"] == data["first_name"]
        assert user_data["last_name"] == data["last_name"]
