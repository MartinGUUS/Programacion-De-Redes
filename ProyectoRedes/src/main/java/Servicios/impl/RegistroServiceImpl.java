package Servicios.impl;

import Datos.AlumnosDAO;
import Datos.MaestrosDAO;
import Modelo.Alumnos;
import Modelo.Maestros;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class RegistroServiceImpl extends UnicastRemoteObject implements Servicios.RegistroService {

    public RegistroServiceImpl() throws RemoteException {
        super();
    }

    @Override
    public boolean registrarAlumno(Alumnos alumno) throws RemoteException {
        AlumnosDAO dao = new AlumnosDAO();
        if (dao.insertarAlumno(alumno) == 1) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    public boolean registrarMaestro(Maestros maestro) throws RemoteException {
        MaestrosDAO dao = new MaestrosDAO();
        if (dao.insertarMaestro(maestro) == 1) {
            return true;
        } else {
            return false;
        }
    }
}
