package Datos;

import Modelo.Maestros;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaestrosDAO {

    private static final String INSERT_MAESTRO = "INSERT INTO maestros (n_control, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo, contrasena) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_MAESTRO = "UPDATE maestros SET nombre = ?, segundo_nombre = ?, apellido_paterno = ?, apellido_materno = ?, correo = ?, contrasena = ? WHERE n_control = ?";
    private static final String DELETE_MAESTRO_BY_NCONTROL = "UPDATE maestros SET estado = FALSE WHERE n_control = ?";
    private static final String SELECT_MAESTRO_BY_NCONTROL = "SELECT * FROM maestros WHERE n_control = ?";
    private static final String SELECT_ALL_MAESTROS = "SELECT * FROM maestros WHERE estado = TRUE";
    private static final String SELECT_LOGIN = "SELECT * FROM maestros WHERE n_control = ? and contrasena = ?";


    public List<Maestros> loginMaestros(String n_control, String contrasena) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Maestros> listaMaestros = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_LOGIN);
            ps.setString(1, n_control);
            ps.setString(2, contrasena);
            rs = ps.executeQuery();

            while (rs.next()) {
                Maestros maestro = new Maestros(
                        rs.getString("n_control"),
                        rs.getString("nombre"),
                        rs.getString("segundo_nombre"),
                        rs.getString("apellido_paterno"),
                        rs.getString("apellido_materno"),
                        rs.getString("correo"),
                        rs.getString("contrasena")
                );
                listaMaestros.add(maestro);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener datos para login: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return listaMaestros;
    }

    public List<Maestros> obtenerTodosLosMaestros() {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Maestros> listaMaestros = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_ALL_MAESTROS);
            rs = ps.executeQuery();

            while (rs.next()) {
                Maestros maestro = new Maestros(
                        rs.getString("n_control"),
                        rs.getString("nombre"),
                        rs.getString("segundo_nombre"),
                        rs.getString("apellido_paterno"),
                        rs.getString("apellido_materno"),
                        rs.getString("correo"),
                        rs.getString("contrasena")
                );
                listaMaestros.add(maestro);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener todos los maestros: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return listaMaestros;
    }

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

    public void actualizarMaestro(Maestros maestro) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(UPDATE_MAESTRO);
            ps.setString(1, maestro.getNombre());
            ps.setString(2, maestro.getSegundo_nombre());
            ps.setString(3, maestro.getApellido_paterno());
            ps.setString(4, maestro.getApellido_materno());
            ps.setString(5, maestro.getCorreo());
            ps.setString(6, maestro.getContrasena());
            ps.setString(7, maestro.getN_control());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al actualizar maestro: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }

    public void eliminarMaestro(String nControl) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(DELETE_MAESTRO_BY_NCONTROL);
            ps.setString(1, nControl);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al eliminar maestro: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }
}
