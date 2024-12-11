package Modelo;

import java.io.Serializable;
import java.sql.Timestamp;

public class Mensajes implements Serializable {

    private int id_mensajes;
    private String fk_maestros;
    private int fk_grupos;
    private String texto;
    private String imagen_url; // Cambiado de byte[] a String
    private Timestamp fecha_envio;

    public Mensajes() {
    }

    public Mensajes(int id_mensajes, String fk_maestros, int fk_grupos, String texto, String imagen_url, Timestamp fecha_envio) {
        this.id_mensajes = id_mensajes;
        this.fk_maestros = fk_maestros;
        this.fk_grupos = fk_grupos;
        this.texto = texto;
        this.imagen_url = imagen_url;
        this.fecha_envio = fecha_envio;
    }

    public int getId_mensajes() {
        return id_mensajes;
    }

    public void setId_mensajes(int id_mensajes) {
        this.id_mensajes = id_mensajes;
    }

    public String getFk_maestros() {
        return fk_maestros;
    }

    public void setFk_maestros(String fk_maestros) {
        this.fk_maestros = fk_maestros;
    }

    public int getFk_grupos() {
        return fk_grupos;
    }

    public void setFk_grupos(int fk_grupos) {
        this.fk_grupos = fk_grupos;
    }

    public String getTexto() {
        return texto;
    }

    public void setTexto(String texto) {
        this.texto = texto;
    }

    public String getImagen_url() {
        return imagen_url;
    }

    public void setImagen_url(String imagen_url) {
        this.imagen_url = imagen_url;
    }

    public Timestamp getFecha_envio() {
        return fecha_envio;
    }

    public void setFecha_envio(Timestamp fecha_envio) {
        this.fecha_envio = fecha_envio;
    }
}
