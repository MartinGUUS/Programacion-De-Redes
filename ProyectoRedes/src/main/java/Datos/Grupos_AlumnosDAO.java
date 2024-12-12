package Datos;

import Modelo.Alumnos;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Grupos_AlumnosDAO {

    private static final String INSERT_GRUPO_ALUMNO = "INSERT INTO grupos_alumnos (fk_grupos, fk_alumnos, fk_maestros) VALUES (?, ?, ?)";
    private static final String SELECT_BY_ALUMNO = "SELECT * FROM grupos_alumnos WHERE fk_alumnos = ? and fk_grupos=?";
    private static final String SELECT_ALUMNOS_POR_GRUPO =
            "SELECT a.matricula, a.nombre, a.segundo_nombre, a.apellido_paterno, a.apellido_materno, a.correo " +
                    "FROM grupos_alumnos ga " +
                    "JOIN alumnos a ON ga.fk_alumnos = a.matricula " +
                    "WHERE ga.fk_grupos = ?";

    private static final String DELETE_ALUMNO_DEL_GRUPO =
            "DELETE FROM grupos_alumnos WHERE fk_alumnos = ? AND fk_grupos = ?";

    private static final String COUNT_ALUMNOS_EN_GRUPO =
            "SELECT COUNT(*) FROM grupos_alumnos WHERE fk_alumnos = ? AND fk_grupos = ?";

    private static final String COUNT_MAESTRO_EN_GRUPO =
            "SELECT COUNT(*) FROM grupos_alumnos WHERE fk_maestros = ? AND fk_grupos = ?";

    public int contarMaestrosEnGrupo(String matricula, int grupo) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;

        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(COUNT_MAESTRO_EN_GRUPO);
            ps.setString(1, matricula);
            ps.setInt(2, grupo);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error al contar los Maestros en el grupo: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }

        return count;
    }


    public int contarAlumnosEnGrupo(String matricula, int grupo) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;

        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(COUNT_ALUMNOS_EN_GRUPO);
            ps.setString(1, matricula);
            ps.setInt(2, grupo);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error al contar los alumnos en el grupo: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }

        return count;
    }


    public boolean eliminarAlumnoDeGrupo(String matricula, int grupo) {
        Connection connection = null;
        PreparedStatement ps = null;
        boolean eliminado = false;

        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(DELETE_ALUMNO_DEL_GRUPO);
            ps.setString(1, matricula);
            ps.setInt(2, grupo);
            ps.executeUpdate();
            eliminado = true;
        } catch (SQLException e) {
            System.out.println("Error al eliminar el alumno del grupo: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }

        return eliminado;
    }


    public List<Alumnos> obtenerTodosLosAlumnosPorGrupo(int grupo) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Alumnos> listaAlumnos = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_ALUMNOS_POR_GRUPO);
            ps.setInt(1, grupo);
            rs = ps.executeQuery();

            while (rs.next()) {
                Alumnos alumno = new Alumnos(
                        rs.getString("matricula"),
                        rs.getString("nombre"),
                        rs.getString("segundo_nombre"),
                        rs.getString("apellido_paterno"),
                        rs.getString("apellido_materno"),
                        rs.getString("correo"),
                        ""
                );
                listaAlumnos.add(alumno);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener todos los alumnos: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return listaAlumnos;
    }


    public int obtenerGruposPorAlumno(String matricula, int idGrupo) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int cont = 0;

        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_BY_ALUMNO);
            ps.setString(1, matricula);
            ps.setInt(2, idGrupo);
            rs = ps.executeQuery();

            while (rs.next()) {
                cont++;

            }
        } catch (SQLException e) {
            System.out.println("Error al obtener grupos por alumno: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return cont;
    }


    public void insertarGrupoAlumno(int idgrupo, String matricula, String ncontrol) {
        Connection connection = null;
        PreparedStatement ps = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(INSERT_GRUPO_ALUMNO);
            ps.setInt(1, idgrupo);
            ps.setString(2, matricula);
            ps.setString(3, ncontrol);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al insertar grupo-alumno: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }
}
