import json
from google.cloud import pubsub_v1

class Pub_Sub:
    def __init__(self, project_id, topic_name):
        # # Set your Google Cloud project ID
        # self.project_id = "your_project_id"

        # # Set your Pub/Sub topic name
        # self.topic_name = "your_topic_name"

        # Create a publisher client
        self.publisher = pubsub_v1.PublisherClient()

        # Define the topic path
        self.topic_path = self.publisher.topic_path(project_id, topic_name)
    
    def publish_message(self, message) -> str:
        # Publish the message
        data = json.dumps(message).encode("utf-8")
        print(data)
        future = self.publisher.publish(self.topic_path, data=data)
        # print(f"Published message ID: {future.result()}")
        # print(message)
        return future.result()
