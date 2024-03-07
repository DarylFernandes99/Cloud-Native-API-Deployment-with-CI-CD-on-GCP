from flask import json
from src.models.users_model import Users

# session.query(*[c for c in User.__table__.c if c.name != 'password'])
def format_data(data: Users) -> json:
    return {
        "id": data.id,
        "first_name": data.first_name,
        "last_name": data.last_name,
        "username": data.username,
        "account_created": data.account_created,
        "account_updated": data.account_updated,
    }
