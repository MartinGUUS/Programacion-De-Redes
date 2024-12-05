package Servicios.impl;

import Datos.*;
import Modelo.Alumnos;
import Modelo.Grupos;
import Modelo.Grupos_Alumnos;
import Modelo.Maestros;
import Servicios.LoginService;

import java.rmi.server.UnicastRemoteObject;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LoginServiceImpl extends UnicastRemoteObject implements LoginService {

    public LoginServiceImpl() throws Exception {
        super();
    }

    @Override
    public boolean loginAlumno(String matricula, String contrasena) {
        try (Connection connection = Conexion.getConexion()) {
            String query = "SELECT * FROM alumnos WHERE matricula = ? AND contrasena = ?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, matricula);
            ps.setString(2, contrasena);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean loginMaestro(String numeroControl, String contrasena) {
        try (Connection connection = Conexion.getConexion()) {
            String query = "SELECT * FROM maestros WHERE n_control = ? AND contrasena = ?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, numeroControl);
            ps.setString(2, contrasena);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    @Override
    public String obtenerNombreAlumno(String matricula) {
        try (Connection connection = Conexion.getConexion()) {
            String query = "SELECT nombre FROM alumnos WHERE matricula = ?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, matricula);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("nombre");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Retorna null si no encuentra al alumno
    }

    @Override
    public String obtenerNombreMaestro(String numeroControl) {
        try (Connection connection = Conexion.getConexion()) {
            String query = "SELECT nombre FROM maestros WHERE n_control = ?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, numeroControl);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("nombre");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Retorna null si no encuentra al maestro
    }

    @Override
    public List<Grupos_Alumnos> obtenerGruposPorAlumno(String fk_alumnos) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Grupos_Alumnos> lista = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            String SELECT_BY_ALUMNO = "SELECT g.id_grupos, g.nombre " +
                    "FROM grupos_alumnos ga " +
                    "JOIN grupos g ON ga.fk_grupos = g.id_grupos " +
                    "WHERE ga.fk_alumnos = ? AND g.estado = 1";
            ps = connection.prepareStatement(SELECT_BY_ALUMNO);
            ps.setString(1, fk_alumnos);
            rs = ps.executeQuery();

            while (rs.next()) {
                Grupos_Alumnos grupoAlumno = new Grupos_Alumnos(
                        rs.getInt("id_grupos"),
                        rs.getString("nombre") // Asignar nombreMateria
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

    @Override
    public List<Grupos> obtenerGruposPorMaestro(String fk_maestros) {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Grupos> lista = new ArrayList<>();
        try {
            connection = Conexion.getConexion();
            String SELECT_BY_MAESTRO = "SELECT * FROM grupos where fk_maestros=? AND estado = 1";
            ps = connection.prepareStatement(SELECT_BY_MAESTRO);
            ps.setString(1, fk_maestros);
            rs = ps.executeQuery();
            while (rs.next()) {
                Grupos maestrolist = new Grupos(
                        rs.getInt("id_grupos"),
                        rs.getString("nombre"),
                        rs.getBoolean("estado"),
                        rs.getString("fk_maestros")

                );
                lista.add(maestrolist);
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


    @Override
    public Alumnos obtenerAlumnoPorMatricula(String matricula) {
        AlumnosDAO alumnosDAO = new AlumnosDAO();
        return alumnosDAO.obtenerAlumnoPorMatricula(matricula);
    }

    @Override
    public Maestros obtenerMaestroPorNControl(String nControl) {
        MaestrosDAO maestrosDAO = new MaestrosDAO();
        return maestrosDAO.obtenerMaestroPorNControl(nControl);
    }

    @Override
    public void insertarGrupoAlumno(int idgrupo, String matricula, String ncontrol) {
        Grupos_AlumnosDAO gruposDAO = new Grupos_AlumnosDAO();
        gruposDAO.insertarGrupoAlumno(idgrupo, matricula, ncontrol);
    }

    @Override
    public int obtenerGruposPorAlumno(String matricula, int idGrupo) {
        Grupos_AlumnosDAO gruposDAO = new Grupos_AlumnosDAO();
        return gruposDAO.obtenerGruposPorAlumno(matricula, idGrupo);
    }

    @Override
    public void insertarGrupo(String nombre, String fkMaestro) {
        GruposDAO gruposDAO = new GruposDAO();
        gruposDAO.insertarGrupo(nombre, fkMaestro);
    }

    public void desactivarGrupo(int id_grupos) {
        GruposDAO gruposDAO = new GruposDAO();
        gruposDAO.desactivarGrupo(id_grupos);
    }

    public void actualizarNombre(String nombre, int idgrupo) {
        GruposDAO gruposDAO = new GruposDAO();
        gruposDAO.actualizarNombre(nombre, idgrupo);
    }

    public List<Alumnos> obtenerTodosLosAlumnosPorGrupo(int grupo) {
        Grupos_AlumnosDAO gruposDAO = new Grupos_AlumnosDAO();
        return gruposDAO.obtenerTodosLosAlumnosPorGrupo(grupo);
    }

    public boolean eliminarAlumnoDeGrupo(String matricula, int grupo) {
        Grupos_AlumnosDAO gruposDAO = new Grupos_AlumnosDAO();
        return gruposDAO.eliminarAlumnoDeGrupo(matricula, grupo);
    }

}
