package Datos;

import Modelo.Alumnos;
import java.sql.*;

public class AlumnosDAO {

    private static final String INSERT_ALUMNO = "INSERT INTO alumnos (matricula, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo, contrasena) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_ALUMNO_BY_MATRICULA = "SELECT * FROM alumnos WHERE matricula = ?";

    public Alumnos obtenerAlumnoPorMatricula(String matricula) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Alumnos alumno = null;
        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_ALUMNO_BY_MATRICULA);
            ps.setString(1, matricula);
            rs = ps.executeQuery();
            if (rs.next()) {
                alumno = new Alumnos(
                        rs.getString("matricula"),
                        rs.getString("nombre"),
                        rs.getString("segundo_nombre"),
                        rs.getString("apellido_paterno"),
                        rs.getString("apellido_materno"),
                        rs.getString("correo"),
                        rs.getString("contrasena")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener alumno: " + e.getMessage());
        } finally {
            Conexion.cerrarResultSet(rs);
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return alumno;
    }

    public int insertarAlumno(Alumnos alumno) {
        Connection connection = null;
        PreparedStatement ps = null;
        int resultado = 0;
        try {
            if (obtenerAlumnoPorMatricula(alumno.getMatricula()) == null) {
                connection = Conexion.getConexion();
                ps = connection.prepareStatement(INSERT_ALUMNO);
                ps.setString(1, alumno.getMatricula());
                ps.setString(2, alumno.getNombre());
                ps.setString(3, alumno.getSegundo_nombre());
                ps.setString(4, alumno.getApellido_paterno());
                ps.setString(5, alumno.getApellido_materno());
                ps.setString(6, alumno.getCorreo());
                ps.setString(7, alumno.getContrasena());
                ps.executeUpdate();
                resultado = 1;
            }
        } catch (SQLException e) {
            System.out.println("Error al insertar alumno: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
        return resultado;
    }
}
