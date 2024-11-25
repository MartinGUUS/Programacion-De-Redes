package Datos;

import Servicios.impl.LoginServiceImpl;

import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;

public class Main {
    public static void main(String[] args) {
        try {
            // Establece el puerto y el hostname
            System.setProperty("java.rmi.server.hostname", "localhost");
            LocateRegistry.createRegistry(1099);

            // Registra el servicio
            LoginServiceImpl loginService = new LoginServiceImpl();
            Naming.rebind("rmi://localhost:1099/ServicioLogin", loginService);

            System.out.println("Servidor RMI iniciado correctamente en rmi://localhost:1099/ServicioLogin");
        } catch (Exception e) {
            System.err.println("Error al iniciar el servidor RMI: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
