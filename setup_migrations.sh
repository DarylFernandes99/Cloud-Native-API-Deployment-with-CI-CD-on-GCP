#!/usr/bin/env python3.8
if [ -d /home/webapp-main/migrations ]; then
    echo "Database Migrations exists"
else
    source venv/bin/activate
    python3.8 create_database.py
    flask db init
    flask db migrate
    flask db upgrade
fi
