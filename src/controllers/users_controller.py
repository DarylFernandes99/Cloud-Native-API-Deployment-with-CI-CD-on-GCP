from flask import request, Response, json, Blueprint
from src import db
from src.middlewares.auth_middleware import authorization_required
from src.middlewares.format_user_data import format_data
from src.models.users_model import Users
from sqlalchemy import exc
import logging

logger = logging.getLogger(__name__)

# user controller blueprint to be registered with api blueprint
user = Blueprint("user", __name__)

user_columns = ["first_name", "last_name", "username", "password"]

@user.route('', methods=['POST'])
def create_user() -> Response:
    try:
        data = request.json
        if set(user_columns) == set(data.keys()):
            user_data_obj = Users(data["first_name"], data["last_name"], data["password"], data["username"])
            logger.info("Created user object")
            db.session.add(user_data_obj)
            db.session.commit()
            logger.info("Inserted user object data to database")
            return Response(status=201)
            # return Response(
            #     response=json.dumps(format_data(user_data_obj)),
            #     status=201,
            #     mimetype="application/json"
            # )
        logger.info("Found missing fields: {}".format(', '.join(list(filter(lambda x: x not in data.keys(), user_columns)))))
        return Response(
            response=json.dumps({
                "status": "failed",
                "message": f"Missing fields {', '.join(list(filter(lambda x: x not in data.keys(), user_columns)))}"
            }),
            status=400,
            mimetype="application/json"
        )
    except exc.IntegrityError as e:
        logger.error(str(e.orig))
        db.session.rollback()
        logger.info("Database rollback completed")
        return Response(
            response=json.dumps({
                "status": "failed",
                "message": str(e.orig)
            }),
            status=400,
            mimetype="application/json"
        )
    except Exception as e:
        logger.error(str(e))
        return Response(
            response=json.dumps({
                "status": "failed",
                "message": str(e)
            }),
            status=500,
            mimetype="application/json"
        )

@user.route('/self', methods=['GET', 'PUT'])
@authorization_required
def get_update_controller(current_user: Users) -> Response:
    try:
        if request.method == 'PUT':
            data = request.json
            user_columns = ["first_name", "last_name", "password"]
            data_columns = list(filter(lambda x: x not in user_columns, data.keys()))
            if len(data_columns) == 0:
                if 'first_name' in data.keys(): current_user.first_name = data["first_name"]
                if 'last_name' in data.keys(): current_user.last_name = data["last_name"]
                if 'password' in data.keys(): current_user.password = data["password"]
                db.session.commit()
                logger.info("Updated data for {}".format(current_user.username))
                return Response(status=204)
            logger.info("Found additional fields: ".format(', '.join(data_columns)))
            return Response(status=400)
        else:
            logger.info("Fetched data for {}".format(current_user.username))
            return Response(
                response=json.dumps(format_data(current_user)),
                status=200,
                mimetype="application/json"
            )
    except exc.IntegrityError as e:
        logger.error(str(e.orig))
        db.session.rollback()
        logger.info("Database rollback completed")
        return Response(
            response=json.dumps({
                "status": "failed",
                "message": str(e.orig)
            }),
            status=400,
            mimetype="application/json"
        )
    except Exception as e:
        logger.error(str(e))
        return Response(
            response=json.dumps({
                "status": "failed",
                "message": str(e)
            }),
            status=500,
            mimetype="application/json"
        )
