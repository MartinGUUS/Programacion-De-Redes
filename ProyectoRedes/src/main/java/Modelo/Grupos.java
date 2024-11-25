package Modelo;

import java.io.Serializable;

public class Grupos implements Serializable {
    private int id_grupos;
    private String nombre;
    private boolean estado;

    public Grupos() {
    }


    public Grupos(int id_grupos, String nombre, boolean estado) {
        this.id_grupos = id_grupos;
        this.nombre = nombre;
        this.estado = estado;
    }

    public int getId_grupos() {
        return id_grupos;
    }

    public void setId_grupos(int id_grupos) {
        this.id_grupos = id_grupos;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }
}
