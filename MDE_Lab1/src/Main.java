import org.eclipse.paho.client.mqttv3.MqttMessage;

import com.mysql.cj.protocol.a.MysqlBinaryValueDecoder;

import java.sql.*;

public class Main {
    private static String url = "jdbc:mysql://localhost/smart_buildingsdb?useSSL=false";
    private static String username = "mysql";          //Replace with your database username
    private static String password = "mysql";          //Replace with user password
    public static void main(String[] args) throws SQLException {
        System.out.println("MDE Lab1 - Welcome to the Java Project");

        //Database information

        //For testing only the MQTT connection, comment until start the MQTT part
        //Test database integration
        try {
            //Start Connection
            Connection conn = MySQL_Integration.createConnection(url,username,password);
            //RF13 - Simulate a client 
                MySQL_Integration.executeUpdate(conn, "call delete_everything");
            
                MySQL_Integration.executeUpdate(conn, "call insert_client(291093019, 'António Augusto Sousa', 'Travessa Padrão Repetitivo Nº2', 912313212);");
                MySQL_Integration.executeUpdate(conn, "call insert_instalation(165,'Rua da Industria 14', 291093019, 'Industrial');");
                MySQL_Integration.executeUpdate(conn, "call insert_contract(165,   '2022-01-01', '2026-01-01', 1200, 3);");
                ResultSet resultSet = MySQL_Integration.executeQuery(conn, "SELECT * FROM contracts");
                while(resultSet.next()) {
                    System.out.println(resultSet.getString("idContracts") + "\t" + resultSet.getString("Service_Package_idService_Package"));
                }

                //MySQL_Integration.executeUpdate(conn, "call insert_receipt(11);");
                MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-01-01',   'IND-709',                                   'Sensor Luz',   'Luminosidade');");
                MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-01-01',   'IND-809',                                   'Lamps',        'Actuator');");
                MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-04-15',   'shellies/shellyplug-16A631/relay/0/power',  'Fridge',       'Sensor');");
                MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-04-15',   'shellies/shellyplug-16DC5E/relay/0/power',  'Plug',         'Sensor');");
                MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-04-15',   'shellies/shellyplug-s-6F3275/relay/0/power','PlugS',        'Sensor');");
                MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-04-15',   'DS18B20/192.168.250.20',                    'Temperature',  'Sensor');");
                MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-04-15',   'MQ9/192.168.250.20',                        'Air quality',  'Sensor');");
                
                MySQL_Integration.executeUpdate(conn, "call insert_automation(165, 'Temperature Control' ,    'DS18B20/192.168.250.20',  '<', 75,        'IND-809', 'ON');");
                MySQL_Integration.executeUpdate(conn, "call insert_automation(165, 'Air-Quality Control',     'MQ9/192.168.250.20',  '<', 150,       'IND-809', 'OFF');");
                
            //Execute Query
            //    ResultSet resultSet = MySQL_Integration.executeQuery(conn, "SELECT * FROM client");
            //Process Result
            //    while (resultSet.next()) {
            //Process the result set
            //      System.out.println(resultSet.getString("NIF") + "\t" + resultSet.getString("name"));
            //    }
            //Close Connection
            MySQL_Integration.closeConnection(conn);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        //MQTT Broker information
        //ATTENTION!!!
        //Comment the following line for testing WITHOUT real data
        
        String broker = "tcp://192.168.250.201:1883";

        //Start Subscription
        //ATTENTION!!!
        //Comment the following line for testing WITHOUT real data
        
        MQTTLibrary.createSubscriber(broker);
        
        
    }

    public static void messageReceived(String topic, MqttMessage message) {
        //RF14 - Real-time data
        try {
            Connection conn = MySQL_Integration.createConnection(url, username, password);
            MySQL_Integration.executeUpdate(conn, "UPDATE device_info SET value = " + message + " WHERE manufacturer_ref = '" + topic + "'");
            System.out.println("Message arrived. Topic: " + topic + " Message: " + message.toString());
            MySQL_Integration.closeConnection(conn);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }   
    }
}