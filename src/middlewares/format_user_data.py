from flask import json
from src.models.users_model import Users

# session.query(*[c for c in User.__table__.c if c.name != 'password'])
def format_data(data: Users, convert_datetime: bool = False) -> dict:
    return {
        "id": str(data.id) if convert_datetime else data.id,
        "first_name": data.first_name,
        "last_name": data.last_name,
        "username": data.username,
        "account_created": str(data.account_created) if convert_datetime else data.account_created,
        "account_updated": str(data.account_updated) if convert_datetime else data.account_updated,
    }
