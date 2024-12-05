package Servicios;

import Modelo.Alumnos;
import Modelo.Grupos;
import Modelo.Grupos_Alumnos;
import Modelo.Maestros;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

public interface LoginService extends Remote {
    boolean loginAlumno(String matricula, String contrasena) throws RemoteException;

    boolean loginMaestro(String numeroControl, String contrasena) throws RemoteException;

    String obtenerNombreAlumno(String matricula) throws RemoteException;

    String obtenerNombreMaestro(String numeroControl) throws RemoteException;

    List<Grupos_Alumnos> obtenerGruposPorAlumno(String fk_alumnos) throws RemoteException;

    List<Grupos> obtenerGruposPorMaestro(String fk_maestros) throws RemoteException;

    Alumnos obtenerAlumnoPorMatricula(String matricula) throws RemoteException;

    Maestros obtenerMaestroPorNControl(String nControl) throws RemoteException;

    void insertarGrupoAlumno(int idgrupo, String matricula, String ncontrol) throws RemoteException;

    int obtenerGruposPorAlumno(String matricula, int idGrupo) throws RemoteException;

    void insertarGrupo(String nombre, String fkMaestro) throws RemoteException;

    void desactivarGrupo(int id_grupos) throws RemoteException;

    void actualizarNombre(String nombre, int idgrupo) throws RemoteException;

    List<Alumnos> obtenerTodosLosAlumnosPorGrupo(int grupo) throws RemoteException;
}
