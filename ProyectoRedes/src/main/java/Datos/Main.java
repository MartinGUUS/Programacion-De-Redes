package Datos;

import Servicios.RegistroService;
import Servicios.impl.LoginServiceImpl;
import Servicios.impl.RegistroServiceImpl;

import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;

public class Main {
    public static void main(String[] args) {
        try {
            // Establece el puerto y el hostname
            System.setProperty("java.rmi.server.hostname", "localhost");
            LocateRegistry.createRegistry(1099);

            RegistroService registroService = new RegistroServiceImpl();
            Naming.rebind("rmi://localhost:1099/RegistroService", registroService);

            LoginServiceImpl loginService = new LoginServiceImpl();
            Naming.rebind("rmi://localhost:1099/ServicioLogin", loginService);

            System.out.println("Servidor RMI iniciado correctamente");
        } catch (Exception e) {
            System.err.println("Error al iniciar el servidor RMI: " + e.getMessage());
        }
    }
}
