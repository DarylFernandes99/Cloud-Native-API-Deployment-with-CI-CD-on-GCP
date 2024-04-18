import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

load_dotenv()

class DB:
    def __init__(self) -> None:
        self.connection_string = os.environ.get("SQLALCHEMY_DATABASE_URI_DEV")
        self.engine = create_engine(self.connection_string)

    def create_connection(self):
        return self.engine.connect()

    def create_session(self) -> sessionmaker:
        return sessionmaker(bind=self.engine)
