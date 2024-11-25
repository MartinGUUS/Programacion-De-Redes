package Datos;

import Modelo.Grupos;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GruposDAO {

    private static final String INSERT_GRUPO = "INSERT INTO grupos (nombre) VALUES (?)";
    private static final String UPDATE_GRUPO = "UPDATE grupos SET nombre = ? WHERE id_grupos = ?";
    private static final String DESACTIVAR_GRUPO = "UPDATE grupos SET estado = false WHERE id_grupos = ?";
    private static final String ACTIVAR_GRUPO = "UPDATE grupos SET estado = true WHERE id_grupos = ?";
    private static final String SELECT_GRUPO_BY_ID = "SELECT * FROM grupos WHERE id_grupos = ?";
    private static final String SELECT_ALL_GRUPOS = "SELECT * FROM grupos WHERE estado = true";


    public List<Grupos> obtenerTodosLosGrupos() {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Grupos> listaGrupos = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_ALL_GRUPOS);
            rs = ps.executeQuery();
            while (rs.next()) {
                Grupos grupo = new Grupos(
                        rs.getInt("id_grupos"),
                        rs.getString("nombre"),
                        rs.getBoolean("estado")
                );
                listaGrupos.add(grupo);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener todos los grupos: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return listaGrupos;
    }


    public List<Grupos> obtenerGrupoPorId(int id_grupos) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Grupos> listaGrupos = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_GRUPO_BY_ID);
            ps.setInt(1, id_grupos);
            rs = ps.executeQuery();
            if (rs.next()) {
                Grupos grupo = new Grupos(
                        rs.getInt("id_grupos"),
                        rs.getString("nombre"),
                        rs.getBoolean("estado")
                );
                listaGrupos.add(grupo);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener el grupo por ID: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }

        return listaGrupos;
    }


    public void insertarGrupo(Grupos grupo) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(INSERT_GRUPO);
            ps.setString(1, grupo.getNombre());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al insertar grupo: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }


    public void actualizarNombre(Grupos grupo) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(UPDATE_GRUPO);
            ps.setString(1, grupo.getNombre());
            ps.setInt(2, grupo.getId_grupos());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al actualizar grupo: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }


    public void desactivarGrupo(int id_grupos) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(DESACTIVAR_GRUPO);
            ps.setInt(1, id_grupos);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al desactivar grupo: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }


    public void activarGrupo(int id_grupos) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(ACTIVAR_GRUPO);
            ps.setInt(1, id_grupos);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al activar grupo: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }
}
