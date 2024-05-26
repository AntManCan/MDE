import paho.mqtt.client as mqtt_client
import random
import time

# MQTT broker details
broker_address = "127.0.0.1"                  
port = 1883  

# Defining topics
topic_1 = "shellies/shellyplug-16A631/relay/0/power"
# add with other topics

def connect_mqtt():
    def on_connect(client, userdata, flags, reason_code, properties):
        if reason_code == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", reason_code)
    # Set Connecting Client ID
    client = mqtt_client.Client(mqtt_client.CallbackAPIVersion.VERSION2)
    client.on_connect = on_connect
    client.connect(broker_address, port)
    return client

# Function to generate random floats
def randomFloats(min=0.0, max=100.0):
    random_float = random.uniform(min, max)  # Generate a random float between min and max
    payload = "{:.2f}".format(random_float)   # Format the float to have 2 decimal places
    return payload

def publish(client):
    # Publish random floats to the MQTT topics every 5 seconds
    while True:
        payload_1 = randomFloats(0.0, 45.0)
        print(f"Topic: {topic_1} Publishing: {payload_1}")
        client.publish(topic_1, payload_1)  # Publish the payload to the topic_1
        # add the other topics publishing...

        time.sleep(5)  # Wait for 5 second before publishing the next float

def run():
    client = connect_mqtt()
    client.loop_start()
    publish(client)

if __name__ == '__main__':
    run()