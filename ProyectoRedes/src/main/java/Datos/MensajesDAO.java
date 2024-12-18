package Datos;

import Modelo.Mensajes;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MensajesDAO {

    private static final String INSERT_MENSAJE = "INSERT INTO mensajes (fk_maestros, fk_grupos, texto, imagen_url, fecha_envio) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_MENSAJES_POR_GRUPO = "SELECT * FROM mensajes WHERE fk_grupos = ? ORDER BY fecha_envio DESC";

    public List<Mensajes> obtenerMensajesPorGrupo(int idGrupo) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Mensajes> listaMensajes = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_MENSAJES_POR_GRUPO);
            ps.setInt(1, idGrupo);
            rs = ps.executeQuery();

            while (rs.next()) {
                Mensajes mensaje = new Mensajes(
                        rs.getInt("id_mensajes"),
                        rs.getString("fk_maestros"),
                        rs.getInt("fk_grupos"),
                        rs.getString("texto"),
                        rs.getString("imagen_url"),
                        rs.getTimestamp("fecha_envio")
                );
                listaMensajes.add(mensaje);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener mensajes por grupo: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return listaMensajes;
    }

    public void insertarMensaje(Mensajes mensaje) {
        Connection connection = null;
        PreparedStatement ps = null;
        boolean verificacion = false;

        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(INSERT_MENSAJE);
            ps.setString(1, mensaje.getFk_maestros());
            ps.setInt(2, mensaje.getFk_grupos());

            // Si el texto es nulo se inserta como null
            if (mensaje.getTexto() != null && !mensaje.getTexto().isEmpty()) {
                ps.setString(3, mensaje.getTexto());
                verificacion = true;
            } else {
                ps.setNull(3, Types.VARCHAR);
            }

            // Si la imagen es nula se inserta como null
            if (mensaje.getImagen_url() != null && !mensaje.getImagen_url().isEmpty()) {
                ps.setString(4, mensaje.getImagen_url());
                verificacion = true;
            } else {
                ps.setNull(4, Types.VARCHAR);
            }

            ps.setTimestamp(5, mensaje.getFecha_envio());

            if (verificacion) {
                ps.executeUpdate();
            } else {
                System.out.println("\nNo se puede mandar mensaje sin texto o imagen");
            }

        } catch (SQLException e) {
            System.out.println("Error al insertar mensaje: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }
}
