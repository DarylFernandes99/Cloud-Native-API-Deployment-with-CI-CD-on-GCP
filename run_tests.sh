#!/usr/bin/env python3
python3 -m venv venv
source venv/bin/activate
python3 -m pip install -r requirements.txt
python3 create_database.py
flask db init
flask db migrate
flask db upgrade
python3 -m pytest
