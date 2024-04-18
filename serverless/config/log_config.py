import logging
import google.cloud.logging

# Initialize the logger
class Logger:
    def __init__(self) -> None:
        self.client = google.cloud.logging.Client()
        self.client.setup_logging()
        self.logging = logging
