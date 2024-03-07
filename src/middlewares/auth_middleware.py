from functools import wraps
from flask import request, Response, json
from src import bcrypt
from src.models.users_model import Users
import base64
from sqlalchemy import exc

def authorization_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth_data = None
        if "Authorization" in request.headers:
            auth_data = base64.b64decode(request.headers["Authorization"].split(" ")[1]).decode('utf-8')
        if not auth_data:
            return Response(
                response=json.dumps({
                    "status": "failed",
                    "message": "Could not validate user"
                }),
                status=401,
                mimetype="application/json"
            )
        try:
            auth_data = auth_data.split(":")
            user = Users.query.filter_by(username = auth_data[0]).first()
            if not user:
                return Response(
                    response=json.dumps({
                        "status": "failed",
                        "message": "Could not validate user"
                    }),
                    status=401,
                    mimetype="application/json"
                )
            is_valid = bcrypt.check_password_hash(user.password, auth_data[1])
            if not is_valid:
                return Response(
                    response=json.dumps({
                        "status": "failed",
                        "message": "Incorrect credentials provided"
                    }),
                    status=401,
                    mimetype="application/json"
                )
        except exc.IntegrityError as e:
            return Response(
                response=json.dumps({
                    "status": "failed",
                    "message": str(e.orig)
                }),
                status=400,
                mimetype="application/json"
            )
        except Exception as e:
            return Response(
                response=json.dumps({
                    "status": "failed",
                    "message": str(e)
                }),
                status=500,
                mimetype="application/json"
            )

        return f(user, *args, **kwargs)

    return decorated
