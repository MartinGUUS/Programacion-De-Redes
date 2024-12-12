package Controlador;

import Datos.webSocketsCHAT;
import Modelo.Mensajes;
import Servicios.LoginService;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.rmi.Naming;
import java.sql.Timestamp;
import java.util.UUID;

@WebServlet("/EnviarMensajeServlet")
@MultipartConfig
public class EnviarMensajeServlet extends HttpServlet {

    private static final String IMAGENES_URL = "http://localhost:8080/ProyectoRedes/imagenes/";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fk_maestros = (String) request.getSession().getAttribute("usuario");
        String materia = request.getParameter("materia");
        String nombre = request.getParameter("nom");

        String texto = request.getParameter("mensaje");
        if (texto != null) {
            texto = texto.trim();
            if (texto.isEmpty()) {
                texto = null;
            }
        }

        String grupo = request.getParameter("grupo");
        if (grupo == null || grupo.trim().isEmpty()) {
            response.sendRedirect("ChatMaestro.jsp?id_grupos=" + grupo + "&materia=" + materia + "&nombre=" + nombre);
            return;
        }

        int fk_grupos = Integer.parseInt(grupo);

        String imagen_url = null;
        Part imagenPart = request.getPart("imagen");
        if (imagenPart != null && imagenPart.getSize() > 0) {
            String tipoArchivo = imagenPart.getContentType();
            if (tipoArchivo.startsWith("image/")) {
                String extension = getExtencionArchivo(getNombreArchivo(imagenPart));
                String nombreArchivo = UUID.randomUUID().toString() + extension;
                String direccionImagen = getServletContext().getRealPath("/imagenes/");

                File img = new File(direccionImagen);
                if (!img.exists()) {
                    img.mkdirs();
                }
                File imgExtension = new File(img, nombreArchivo);
                try (InputStream input = imagenPart.getInputStream()) {
                    Files.copy(input, imgExtension.toPath(), StandardCopyOption.REPLACE_EXISTING);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                imagen_url = IMAGENES_URL + nombreArchivo;
            } else {
                System.out.println("Tipo de archivo no permitido: " + tipoArchivo);
            }
        }

        if (texto == null && imagen_url == null) {
            response.sendRedirect("ChatMaestro.jsp?id_grupos=" + fk_grupos + "&materia=" + materia + "&nombre=" + nombre);
            return;
        }

        try {
            LoginService mensajeriaService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
            Mensajes mensaje = new Mensajes();
            mensaje.setFk_maestros(fk_maestros);
            mensaje.setFk_grupos(fk_grupos);
            mensaje.setTexto(texto);
            mensaje.setImagen_url(imagen_url);
            mensaje.setFecha_envio(new Timestamp(System.currentTimeMillis()));

            mensajeriaService.enviarMensaje(mensaje);

            if (imagen_url != null) {
                String json = "{" +
                        "\"type\":\"image\"," +
                        "\"text\":\"" + formatoJSON(texto != null ? texto : "") + "\"," +
                        "\"imageData\":\"" + imagen_url + "\"" +
                        "}";

                webSocketsCHAT.enviarMensajeAGrupo(fk_grupos, json);
            } else if (texto != null) {
                String json = "{" +
                        "\"type\":\"text\"," +
                        "\"text\":\"" + formatoJSON(texto) + "\"" +
                        "}";

                webSocketsCHAT.enviarMensajeAGrupo(fk_grupos, json);
            }

            response.sendRedirect("ChatMaestro.jsp?id_grupos=" + fk_grupos + "&materia=" + materia + "&nombre=" + nombre);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getExtencionArchivo(String nombreArchivo) {
        if (nombreArchivo == null) return "";
        int index = nombreArchivo.lastIndexOf('.');
        return (index == -1) ? "" : nombreArchivo.substring(index);
    }

    private String getNombreArchivo(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String contenido : header.split(";")) {
            if (contenido.trim().startsWith("filename")) {
                String nombreArchivo = contenido.substring(contenido.indexOf('=') + 1).trim().replace("\"", "");
                return nombreArchivo;
            }
        }
        return null;
    }

    private String formatoJSON(String texto) {
        if (texto == null) return "";
        return texto.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("/", "\\/")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
