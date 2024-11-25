package Datos;

import Modelo.Grupos_Alumnos;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Grupos_AlumnosDAO {

    private static final String INSERT_GRUPO_ALUMNO = "INSERT INTO grupos_alumnos (fk_grupos, fk_alumnos, fk_maestros) VALUES (?, ?, ?)";
    private static final String SELECT_BY_MAESTRO = "SELECT * FROM grupos_alumnos WHERE fk_maestros = ?";
    private static final String SELECT_BY_ALUMNO = "SELECT * FROM grupos_alumnos WHERE fk_alumnos = ?";


    public void insertarGrupoAlumno(Grupos_Alumnos gruposAlumnos) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(INSERT_GRUPO_ALUMNO);
            ps.setInt(1, gruposAlumnos.getFk_grupos());
            ps.setString(2, gruposAlumnos.getFk_alumnos());
            ps.setString(3, gruposAlumnos.getFk_maestros());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al insertar grupo-alumno: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }


    public List<Grupos_Alumnos> obtenerPorMaestro(String fk_maestros) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Grupos_Alumnos> lista = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_BY_MAESTRO);
            ps.setString(1, fk_maestros);
            rs = ps.executeQuery();
            while (rs.next()) {
                Grupos_Alumnos grupoAlumno = new Grupos_Alumnos(
                        rs.getInt("fk_grupos"),
                        rs.getString("fk_alumnos"),
                        rs.getString("fk_maestros")
                );
                lista.add(grupoAlumno);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener grupos por maestro: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }

        return lista;
    }


    public List<Grupos_Alumnos> obtenerPorAlumno(String fk_alumnos) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Grupos_Alumnos> lista = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_BY_ALUMNO);
            ps.setString(1, fk_alumnos);
            rs = ps.executeQuery();

            while (rs.next()) {
                Grupos_Alumnos grupoAlumno = new Grupos_Alumnos(
                        rs.getInt("fk_grupos"),
                        rs.getString("fk_alumnos"),
                        rs.getString("fk_maestros")
                );
                lista.add(grupoAlumno);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener grupos por alumno: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return lista;
    }
}
