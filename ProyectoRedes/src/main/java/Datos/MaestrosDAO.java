package Datos;

import Modelo.Maestros;

import java.sql.*;

public class MaestrosDAO {

    private static final String INSERT_MAESTRO = "INSERT INTO maestros (n_control, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo, contrasena) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_MAESTRO_BY_NCONTROL = "SELECT * FROM maestros WHERE n_control = ?";

    public Maestros obtenerMaestroPorNControl(String nControl) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Maestros maestro = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_MAESTRO_BY_NCONTROL);
            ps.setString(1, nControl);
            rs = ps.executeQuery();
            if (rs.next()) {
                maestro = new Maestros(
                        rs.getString("n_control"),
                        rs.getString("nombre"),
                        rs.getString("segundo_nombre"),
                        rs.getString("apellido_paterno"),
                        rs.getString("apellido_materno"),
                        rs.getString("correo"),
                        rs.getString("contrasena")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener maestro: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return maestro;
    }

    public int insertarMaestro(Maestros maestro) {
        Connection connection = null;
        PreparedStatement ps = null;
        int veri = 0;
        try {
            if (obtenerMaestroPorNControl(maestro.getN_control()) == null) {
                connection = Conexion.getConexion();
                ps = connection.prepareStatement(INSERT_MAESTRO);
                ps.setString(1, maestro.getN_control());
                ps.setString(2, maestro.getNombre());
                ps.setString(3, maestro.getSegundo_nombre());
                ps.setString(4, maestro.getApellido_paterno());
                ps.setString(5, maestro.getApellido_materno());
                ps.setString(6, maestro.getCorreo());
                ps.setString(7, maestro.getContrasena());
                ps.executeUpdate();
                veri = 1;
            }
        } catch (SQLException e) {
            System.out.println("Error al insertar maestro: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return veri;
    }
}
