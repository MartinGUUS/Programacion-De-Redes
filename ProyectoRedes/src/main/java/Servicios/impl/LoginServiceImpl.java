package Servicios.impl;

import Servicios.LoginService;
import Datos.Conexion;

import java.rmi.server.UnicastRemoteObject;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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

}
