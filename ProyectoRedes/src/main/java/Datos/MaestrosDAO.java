package Datos;

import Modelo.Maestros;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaestrosDAO {

    private static final String INSERT_MAESTRO = "INSERT INTO maestros (n_control, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_MAESTRO = "UPDATE maestros SET nombre = ?, segundo_nombre = ?, apellido_paterno = ?, apellido_materno = ?, correo = ? WHERE n_control = ?";
    private static final String DELETE_MAESTRO_BY_NCONTROL = "DELETE FORM maestros WHERE n_control = ?";
    private static final String SELECT_MAESTRO_BY_NCONTROL = "SELECT * FROM maestros WHERE n_control = ?";
    private static final String SELECT_ALL_MAESTROS = "SELECT * FROM maestros";


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
                        rs.getString("correo")
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


    public List<Maestros> obtenerMaestroPorNControl(String nControl) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Maestros> listaMaestros = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_MAESTRO_BY_NCONTROL);
            ps.setString(1, nControl);
            rs = ps.executeQuery();
            while (rs.next()) {
                Maestros maestro = new Maestros(
                        rs.getString("n_control"),
                        rs.getString("nombre"),
                        rs.getString("segundo_nombre"),
                        rs.getString("apellido_paterno"),
                        rs.getString("apellido_materno"),
                        rs.getString("correo")
                );
                listaMaestros.add(maestro);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener maestro: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return listaMaestros;
    }


    public void insertarMaestro(Maestros maestro) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(INSERT_MAESTRO);
            ps.setString(1, maestro.getN_control());
            ps.setString(2, maestro.getNombre());
            ps.setString(3, maestro.getSegundo_nombre());
            ps.setString(4, maestro.getApellido_paterno());
            ps.setString(5, maestro.getApellido_materno());
            ps.setString(6, maestro.getCorreo());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al insertar maestro: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
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
            ps.setString(6, maestro.getN_control());
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
