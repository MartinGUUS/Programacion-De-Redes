package Servicios;

import Modelo.Grupos_Alumnos;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

public interface LoginService extends Remote {
    boolean loginAlumno(String matricula, String contrasena) throws RemoteException;

    boolean loginMaestro(String numeroControl, String contrasena) throws RemoteException;

    String obtenerNombreAlumno(String matricula) throws RemoteException;

    String obtenerNombreMaestro(String numeroControl) throws RemoteException;

    List<Grupos_Alumnos> obtenerGruposPorAlumno(String fk_alumnos) throws RemoteException;

    List<Grupos_Alumnos> obtenerGruposPorMaestro(String fk_maestros) throws RemoteException;
}
