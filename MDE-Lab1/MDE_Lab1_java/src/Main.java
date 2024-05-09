import org.eclipse.paho.client.mqttv3.MqttMessage;

import com.mysql.cj.protocol.a.MysqlBinaryValueDecoder;

import java.sql.*;

public class Main {
    private static String url = "jdbc:mysql://localhost/smart_buildingsdb?useSSL=false";
    private static String username = "mysql";          //Replace with your database username
    private static String password = "mysql";          //Replace with user password
    public static void main(String[] args) throws SQLException {
        System.out.println("MDE Lab1 - Welcome to the Java Project");
        try {
            //Start Connection
            Connection conn = MySQL_Integration.createConnection(url,username,password);
            
            //RF1 - Insert clients and delete from client where NIF=321
            MySQL_Integration.executeUpdate(conn, """
                insert into client(NIF, name, address, phone)
                    values(999, 'Marcos', 'Rua 123, Lx', 999999999),
                          (123, 'Ton', 'Av. 123, Lx', 999999991),
                          (456, 'Rod', 'City 123, Lx', 999999992),
                          (789, 'Jonh', 'Ass 123, Lx', 999999994),
                          (321, 'Ggg', 'ugh 123, Lx', 999999993);
                """);
            MySQL_Integration.executeUpdate(conn, "delete from client where NIF=321;");
            ResultSet RF1 = MySQL_Integration.executeQuery(conn, "Select * from client");
            System.out.println("RF1:");
            while(RF1.next()) {
                System.out.println(RF1.getString("NIF") + "\t" + RF1.getString("name") + "\t" + RF1.getString("address") + "\t" + RF1.getString("phone"));
            }
        
            //RF2 & RF3  
            MySQL_Integration.executeUpdate(conn, "call delete_everything");
            
            MySQL_Integration.executeUpdate(conn, "call insert_client(291093019, 'António Augusto Sousa', 'Travessa Padrão Repetitivo Nº2', 912313212);");
            MySQL_Integration.executeUpdate(conn, "call insert_instalation(165,'Rua da Industria 14', 291093019, 'Industrial');");
            MySQL_Integration.executeUpdate(conn, "call insert_contract(165,   '2022-01-01', '2026-01-01', 1200, 3);");
            MySQL_Integration.executeUpdate(conn, "call insert_receipt(1);");
            MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-01-01',   'IND-709',                                   'Sensor Luz',   'Luminosidade');");
            MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-01-01',   'IND-809',                                   'Lamps',        'Actuator');");
            //Lab Devices
            MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-04-15',   'shellies/shellyplug-16A631/relay/0/power',  'Fridge',       'Sensor');");
            MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-04-15',   'shellies/shellyplug-16DC5E/relay/0/power',  'Plug',         'Sensor');");
            MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-04-15',   'shellies/shellyplug-s-6F3275/relay/0/power','PlugS',        'Sensor');");
            MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-04-15',   'DS18B20/192.168.250.20',                    'Temperature',  'Sensor');");
            MySQL_Integration.executeUpdate(conn, "call install_device(165,    '2024-04-15',   'MQ9/192.168.250.20',                        'Air quality',  'Sensor');");
            //Automations
            MySQL_Integration.executeUpdate(conn, "call insert_automation(165, 'Temperature Control' ,    'DS18B20/192.168.250.20',  '<', 75,        'IND-809', 'ON');");
            MySQL_Integration.executeUpdate(conn, "call insert_automation(165, 'Air-Quality Control',     'MQ9/192.168.250.20',  '<', 150,       'IND-809', 'OFF');");            
            MySQL_Integration.executeUpdate(conn, """
                UPDATE device_info
                SET value=70
                WHERE manufacturer_ref='IND-709' AND instalations_idInstalations=165;
            """);
            //RF4 - View data from clients whose installation follow a certain topology
            MySQL_Integration.executeUpdate(conn, "call view_clients_with_installation_type('Industrial');");
            
            //RF5 - View data from clients that purchased a certain package type
            MySQL_Integration.executeUpdate(conn, "call view_clients_with_service('pro');");

            //RF6 - View all devices installed within a time frame
            MySQL_Integration.executeUpdate(conn, "call view_installations_with_auto_in_time('2024-01-01','2026-01-01');");
            
            
            
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
        
        //String broker = "tcp://192.168.250.201:1883";

        //Start Subscription
        //ATTENTION!!!
        //Comment the following line for testing WITHOUT real data
        
        //MQTTLibrary.createSubscriber(broker);
        
        
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
                