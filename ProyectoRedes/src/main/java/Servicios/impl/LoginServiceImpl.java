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
}
