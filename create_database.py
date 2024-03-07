from sqlalchemy import create_engine
from sqlalchemy_utils import database_exists, create_database
import os
from dotenv import load_dotenv

# loading environment variables
load_dotenv()

database_uri = os.environ.get("SQLALCHEMY_DATABASE_URI_DEV")

engine = create_engine(database_uri)
if not database_exists(engine.url):
    create_database(engine.url)
