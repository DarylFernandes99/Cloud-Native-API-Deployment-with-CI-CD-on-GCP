#!/usr/bin/env python3.8
python3.8 -m venv venv
source venv/bin/activate
python3.8 -m pip install -r requirements.txt
python3.8 create_database.py
flask db init
flask db migrate
flask db upgrade
