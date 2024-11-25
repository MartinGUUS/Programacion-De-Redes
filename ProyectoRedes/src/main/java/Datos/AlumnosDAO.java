package Datos;

import Modelo.Alumnos;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlumnosDAO {

    private static final String INSERT_ALUMNO = "INSERT INTO alumnos (matricula, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_ALUMNO = "UPDATE alumnos SET nombre = ?, segundo_nombre = ?, apellido_paterno = ?, apellido_materno = ?, correo = ? WHERE matricula = ?";
    private static final String DELETE_ALUMNO_BY_MATRICULA = "DELETE FROM alumnos WHERE matricula = ?";
    private static final String SELECT_ALUMNO_BY_MATRICULA = "SELECT * FROM alumnos WHERE matricula = ?";
    private static final String SELECT_ALL_ALUMNOS = "SELECT * FROM alumnos";


    public List<Alumnos> obtenerTodosLosAlumnos() {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Alumnos> listaAlumnos = new ArrayList<>();

        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_ALL_ALUMNOS);
            rs = ps.executeQuery();

            while (rs.next()) {
                Alumnos alumno = new Alumnos(
                        rs.getString("matricula"),
                        rs.getString("nombre"),
                        rs.getString("segundo_nombre"),
                        rs.getString("apellido_paterno"),
                        rs.getString("apellido_materno"),
                        rs.getString("correo")
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


    public List<Alumnos> obtenerAlumnosPorMatricula(String matricula) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Alumnos> listaAlumnos = new ArrayList<>();

        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(SELECT_ALUMNO_BY_MATRICULA);
            ps.setString(1, matricula);
            rs = ps.executeQuery();

            while (rs.next()) {
                Alumnos alumno = new Alumnos(
                        rs.getString("matricula"),
                        rs.getString("nombre"),
                        rs.getString("segundo_nombre"),
                        rs.getString("apellido_paterno"),
                        rs.getString("apellido_materno"),
                        rs.getString("correo")
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


    public void insertarAlumno(Alumnos alumno) {
        Connection connection = null;
        PreparedStatement ps = null;

        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(INSERT_ALUMNO);
            ps.setString(1, alumno.getMatricula());
            ps.setString(2, alumno.getNombre());
            ps.setString(3, alumno.getSegundo_nombre());
            ps.setString(4, alumno.getApellido_paterno());
            ps.setString(5, alumno.getApellido_materno());
            ps.setString(6, alumno.getCorreo());

            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("Error al insertar alumno: " + e.getMessage());

        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }


    public void actualizarAlumno(Alumnos alumno) {
        Connection connection = null;
        PreparedStatement ps = null;

        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(UPDATE_ALUMNO);
            ps.setString(1, alumno.getNombre());
            ps.setString(2, alumno.getSegundo_nombre());
            ps.setString(3, alumno.getApellido_paterno());
            ps.setString(4, alumno.getApellido_materno());
            ps.setString(5, alumno.getCorreo());
            ps.setString(6, alumno.getMatricula());

            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("Error al actualizar alumno: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }


    public void eliminarAlumno(String matricula) {
        Connection connection = null;
        PreparedStatement ps = null;

        try {
            connection = Conexion.getConexion();
            ps = connection.prepareStatement(DELETE_ALUMNO_BY_MATRICULA);
            ps.setString(1, matricula);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al eliminar alumno: " + e.getMessage());
        } finally {
            Conexion.cerrarStatement(ps);
            Conexion.cerrarConexion(connection);
        }
    }


}
