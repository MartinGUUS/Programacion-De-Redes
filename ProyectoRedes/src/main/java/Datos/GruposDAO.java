package Datos;

import java.sql.*;

public class GruposDAO {

    private static final String INSERT_GRUPO = "INSERT INTO grupos (nombre, fk_maestros) VALUES (?,?)";
    private static final String UPDATE_GRUPO = "UPDATE grupos SET nombre = ? WHERE id_grupos = ?";
    private static final String DESACTIVAR_GRUPO = "UPDATE grupos SET estado = false WHERE id_grupos = ?";

    public void insertarGrupo(String nombre, String fkMaestro) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(INSERT_GRUPO);
            ps.setString(1, nombre);
            ps.setString(2, fkMaestro);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al insertar grupo: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }

    public void actualizarNombre(String nombre, int idgrupo) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(UPDATE_GRUPO);
            ps.setString(1, nombre);
            ps.setInt(2, idgrupo);
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
}
