import java.sql.*;

public class MySQL_Integration {

    static Connection createConnection(String url, String username, String password) throws SQLException {
        return DriverManager.getConnection(url,username,password);
    }

    static void closeConnection(Connection conn) throws SQLException {
        conn.close();
    }

    //For SELECT
    static ResultSet executeQuery(Connection conn, String query) throws SQLException {
        Statement stmt = conn.createStatement();
        return stmt.executeQuery(query);
    }

    //For INSERT, UPDATE and DELETE
    static int executeUpdate(Connection conn, String query) throws SQLException {
        Statement stmt = conn.createStatement();
        return stmt.executeUpdate(query);
    }
}

