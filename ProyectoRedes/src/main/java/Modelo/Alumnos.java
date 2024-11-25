package Modelo;

import java.io.Serializable;

public class Alumnos implements Serializable {

    private String matricula;
    private String nombre;
    private String segundo_nombre;
    private String apellido_paterno;
    private String apellido_materno;
    private String correo;


    public Alumnos() {
    }

    public Alumnos(String matricula, String nombre, String segundo_nombre, String apellido_paterno, String apellido_materno, String correo) {
        this.matricula = matricula;
        this.nombre = nombre;
        this.segundo_nombre = segundo_nombre;
        this.apellido_paterno = apellido_paterno;
        this.apellido_materno = apellido_materno;
        this.correo = correo;
    }

    public String getMatricula() {
        return matricula;
    }

    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getSegundo_nombre() {
        return segundo_nombre;
    }

    public void setSegundo_nombre(String segundo_nombre) {
        this.segundo_nombre = segundo_nombre;
    }

    public String getApellido_paterno() {
        return apellido_paterno;
    }

    public void setApellido_paterno(String apellido_paterno) {
        this.apellido_paterno = apellido_paterno;
    }

    public String getApellido_materno() {
        return apellido_materno;
    }

    public void setApellido_materno(String apellido_materno) {
        this.apellido_materno = apellido_materno;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }
}
