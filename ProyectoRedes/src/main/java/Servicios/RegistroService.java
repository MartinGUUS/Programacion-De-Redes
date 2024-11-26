package Servicios;

import Modelo.Alumnos;
import Modelo.Maestros;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface RegistroService extends Remote {
    boolean registrarAlumno(Alumnos alumno) throws RemoteException;

    boolean registrarMaestro(Maestros maestro) throws RemoteException;
}
