package Servicios;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface LoginService extends Remote {
    boolean loginAlumno(String matricula, String contrasena) throws RemoteException;
    boolean loginMaestro(String numeroControl, String contrasena) throws RemoteException;
}
