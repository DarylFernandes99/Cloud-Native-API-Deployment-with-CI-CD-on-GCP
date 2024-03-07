from src import db, bcrypt
import uuid
from sqlalchemy.orm import validates
import re

class Users(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.String(36), primary_key = True, unique=True, default=uuid.uuid4)
    first_name = db.Column(db.String(60), nullable=False)
    last_name = db.Column(db.String(60), nullable=False)
    password = db.Column(db.String(80), nullable=False)
    username = db.Column(db.String(70), nullable=False, unique=True)
    account_created = db.Column(db.DateTime, default=db.func.now())
    account_updated = db.Column(db.DateTime, default=db.func.now(), onupdate=db.func.now())
    
    def __init__(self, *args):
        if (args):
            self.first_name = args[0]
            self.last_name = args[1]
            self.password = args[2]
            self.username = args[3]

    @validates('first_name', 'last_name', 'username', 'password')
    def validate_fields(self, key, value):
        name_regexp = r'^[A-Za-z ]{2,}$'
        email_regexp = r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$'
        password_regexp = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%#*?&]{8,}$'
        
        if key == "first_name":
            if not re.match(name_regexp, value):
                raise ValueError("Incorrect name format")
        elif key == "last_name":
            if not re.match(name_regexp, value):
                raise ValueError("Incorrect name format")
        elif key == "username":
            if not re.match(email_regexp, value):
                raise ValueError("Incorrect email format")
        elif key == "password":
            if not re.match(password_regexp, value):
                raise ValueError("Password should contain at least 8 characters, upper case, lower case, number and a special character")
            value = bcrypt.generate_password_hash(value).decode('utf-8')
        
        return value
