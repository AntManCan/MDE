import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;


public class MQTTLibrary {

    static void createSubscriber(String broker){
        try {
            String clientId = "MDE_Lab1_JavaApp_Subscriber";
            MqttClient client = new MqttClient(broker, clientId);
            MqttConnectOptions connOpts = new MqttConnectOptions();
            connOpts.setCleanSession(true);

            client.setCallback(new MqttCallback() {
                @Override
                public void connectionLost(Throwable cause) {
                    System.out.println("Connection lost!");
                }

                @Override
                public void messageArrived(String topic, MqttMessage message) throws Exception {
                    Main.messageReceived(topic, message);
                }

                @Override
                public void deliveryComplete(IMqttDeliveryToken iMqttDeliveryToken) {

                }

            });

            client.connect(connOpts);
            //Energy consumption
            //Fridge
            client.subscribe("shellies/shellyplug-16A631/relay/0/power");
            //Plug
            client.subscribe("shellies/shellyplug-16DC5E/relay/0/power");
            //PlugS
            client.subscribe("shellies/shellyplug-s-6F3275/relay/0/power");

            //Temperature
            client.subscribe("DS18B20/192.168.250.20");
            //Air quality
            client.subscribe("MQ9/192.168.250.20");

        } catch (MqttException me) {
            System.out.println("reason " + me.getReasonCode());
            System.out.println("msg " + me.getMessage());
            System.out.println("loc " + me.getLocalizedMessage());
            System.out.println("cause " + me.getCause());
            System.out.println("excep " + me);
            me.printStackTrace();
        }
    }

    static void sendMessage(String broker, String stringMessage, String topic){
        MemoryPersistence persistence = new MemoryPersistence();

        try {
            String clientId = "MDE_Lab1_JavaApp_Publisher";
            MqttClient client = new MqttClient(broker, clientId, persistence);
            MqttConnectOptions connOpts = new MqttConnectOptions();
            connOpts.setCleanSession(true);
            System.out.println("Connecting to broker: " + broker);
            client.connect(connOpts);
            System.out.println("Connected");

            System.out.println("Publishing message: " + stringMessage);
            MqttMessage message = new MqttMessage(stringMessage.getBytes());
            message.setQos(2);
            client.publish(topic, message);
            System.out.println("Message published");

            client.disconnect();
            System.out.println("Disconnected");
        } catch (MqttException me) {
            System.out.println("reason " + me.getReasonCode());
            System.out.println("msg " + me.getMessage());
            System.out.println("loc " + me.getLocalizedMessage());
            System.out.println("cause " + me.getCause());
            System.out.println("excep " + me);
            me.printStackTrace();
        }
    }

}
