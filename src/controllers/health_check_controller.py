from flask import request, Response, json, Blueprint
from src import db
from sqlalchemy.sql import text
import logging

logger = logging.getLogger(__name__)

# user controller blueprint to be registered with api blueprint
health_check = Blueprint("", __name__)

# updating headers after completion
@health_check.after_app_request
def add_header(response: Response) -> Response:
    response.headers["Cache-control"] = "no-cache, no-store, must-revalidate"
    # Pragma cache is depreciated and only used for backward compatibility  HTTP/1.0
    response.headers["Pragma"] = "no-cache"
    # X-Content-Type-Options is used to indicate the content-type
    response.headers["X-Content-Type-Options"] = "nosniff"
    logger.info("Request completed for {}".format(request.url_rule))
    return response

# removing body data from 405 method response
@health_check.app_errorhandler(405)
def special_exception_handler(error: Response) -> Response:
    return Response(status=405)

@health_check.route('/healthz', methods = ["GET"])
def handle_check_health() -> Response:
    logger.info("Request started for {}".format(request.url_rule))
    try:
        # Check if payload or query params are present in request body
        if request.data or request.args:
            logger.info("Terminating due to paylod/arguments")
            return Response(status=400)
        else:
            # Check if database connection is established
            try:
                db.session.execute(text('SELECT 1 LIMIT 1'))
                logger.error("Database connected successfully")
                return Response(status=200)
            except Exception as e:
                logger.error("Falied to connect to database: {}".format(e))
                return Response(status=503)

    except Exception as e:
        logger.error("Error in completing request: {}".format(e))
        return Response(status=500)
