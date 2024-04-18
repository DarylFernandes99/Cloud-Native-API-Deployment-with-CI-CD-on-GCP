#!/bin/bash
echo -e "SQLALCHEMY_DATABASE_URI_DEV = \"mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:3306/${DB_DATABASE}\"\nSQLALCHEMY_TRACK_MODIFICATIONS = False\nDEV_HOST = \"0.0.0.0\"\nDEV_PORT = 8080\nPROD_HOST = \"0.0.0.0\"\nPROD_PORT = 8080\nPYTHON_ENV = \"development\"\nGOOGLE_PROJECT_ID = \"csye-6225-dev-414900\"\nGOOGLE_TOPIC_NAME = ${TOPIC_NAME}" > /tmp/.env
sudo mv -f /tmp/.env /home/webapp-main/.env
sudo chown -R csye6225:csye6225 /home/webapp-main
sudo systemctl restart csye6225
