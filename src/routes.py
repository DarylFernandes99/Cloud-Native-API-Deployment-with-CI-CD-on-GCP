from flask import request, Response, Blueprint
from src.controllers.users_controller import user
from src import db
from sqlalchemy.sql import text
import logging

logger = logging.getLogger(__name__)

# main blueprint to be registered with application
api = Blueprint('', __name__)
# # register new routes with api blueprint
api.register_blueprint(user, url_prefix="/v1/user")

@api.before_app_request
def before_request():
    logger.info("Request started for {}: {}".format(request.method, request.url_rule))

# updating headers after completion
@api.after_app_request
def add_header(response: Response) -> Response:
    response.headers["Cache-control"] = "no-cache, no-store, must-revalidate"
    # Pragma cache is depreciated and only used for backward compatibility  HTTP/1.0
    response.headers["Pragma"] = "no-cache"
    # X-Content-Type-Options is used to indicate the content-type
    response.headers["X-Content-Type-Options"] = "nosniff"
    logger.info("Request completed for {}: {}".format(request.method, request.url_rule))
    return response

# removing body data from 405 method response
@api.app_errorhandler(405)
def special_exception_handler(error: Response) -> Response:
    logger.warning("Method not allowed")
    return Response(status=405)

@api.route('/healthz', methods = ["GET"])
def handle_check_health() -> Response:
    try:
        # Check if payload or query params are present in request body
        if request.data or request.args:
            logger.info("Terminating due to paylod/arguments")
            return Response(status=400)
        else:
            # Check if database connection is established
            try:
                db.session.execute(text('SELECT 1 LIMIT 1'))
                logger.info("Database connected successfully")
                return Response(status=200)
            except Exception as e:
                logger.error("Falied to connect to database: {}".format(e))
                return Response(status=503)

    except Exception as e:
        logger.error("Error in completing request: {}".format(e))
        return Response(status=500)
