package Datos;

import java.sql.*;

public class Main {
    public static void main(String[] args) throws SQLException {
        Connection connection = null;
        connection = Conexion.getConexion();
        Conexion.cerrarConexion(connection);

    }
}
