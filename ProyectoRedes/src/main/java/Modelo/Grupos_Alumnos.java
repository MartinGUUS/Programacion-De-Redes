package Modelo;

import java.io.Serializable;

public class Grupos_Alumnos implements Serializable {

    private int fk_grupos;
    private String fk_alumnos;
    private String fk_maestros;


    public Grupos_Alumnos() {
    }

    public Grupos_Alumnos(int fk_grupos, String fk_alumnos, String fk_maestros) {
        this.fk_grupos = fk_grupos;
        this.fk_alumnos = fk_alumnos;
        this.fk_maestros = fk_maestros;
    }

    public int getFk_grupos() {
        return fk_grupos;
    }

    public void setFk_grupos(int fk_grupos) {
        this.fk_grupos = fk_grupos;
    }

    public String getFk_alumnos() {
        return fk_alumnos;
    }

    public void setFk_alumnos(String fk_alumnos) {
        this.fk_alumnos = fk_alumnos;
    }

    public String getFk_maestros() {
        return fk_maestros;
    }

    public void setFk_maestros(String fk_maestros) {
        this.fk_maestros = fk_maestros;
    }
}
