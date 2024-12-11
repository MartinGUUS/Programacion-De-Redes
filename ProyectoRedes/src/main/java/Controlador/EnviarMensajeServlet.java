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

    // URL base para acceder a las imágenes desde el navegador
    private static final String IMAGENES_URL = "http://localhost:8080/ProyectoRedes/imagenes/"; // Reemplaza según tu configuración

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fk_maestros = (String) request.getSession().getAttribute("usuario");
        String materia = request.getParameter("materia");
        String nombre = request.getParameter("nom");

        // Obtener el texto del mensaje
        String texto = request.getParameter("mensaje");
        if (texto != null) {
            texto = texto.trim();
            if (texto.isEmpty()) {
                texto = null;
            }
        }

        // Obtener el id del grupo
        String grupo = request.getParameter("grupo");
        if (grupo == null || grupo.trim().isEmpty()) {
            response.sendRedirect("ChatMaestro.jsp?id_grupos=" + grupo + "&materia=" + materia + "&nombre=" + nombre);
            return;
        }

        int fk_grupos = Integer.parseInt(grupo);

        String imagen_url = null;
        Part imagenPart = request.getPart("imagen");
        if (imagenPart != null && imagenPart.getSize() > 0) {
            // Validar el tipo de archivo
            String contentType = imagenPart.getContentType();
            if (contentType.startsWith("image/")) {
                // Generar un nombre único para la imagen
                String fileExtension = getFileExtension(getFileName(imagenPart));
                String fileName = UUID.randomUUID().toString() + fileExtension;

                // Obtener la ruta absoluta del directorio 'imagenes'
                String imagenesPath = getServletContext().getRealPath("/imagenes/");

                // Crear el archivo en el servidor
                File uploads = new File(imagenesPath);
                if (!uploads.exists()) {
                    uploads.mkdirs();
                }
                File file = new File(uploads, fileName);
                try (InputStream input = imagenPart.getInputStream()) {
                    Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                } catch (IOException e) {
                    e.printStackTrace();
                    // Manejar error de subida
                    // Opcional: Redirigir con un mensaje de error
                }
                // Generar la URL accesible
                imagen_url = IMAGENES_URL + fileName;
            } else {
                // Tipo de archivo no permitido
                System.out.println("Tipo de archivo no permitido: " + contentType);
                // Opcional: Redirigir con un mensaje de error
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
                String jsonMessage = "{" +
                        "\"type\":\"image\"," +
                        "\"text\":\"" + escapeJson(texto != null ? texto : "") + "\"," +
                        "\"imageData\":\"" + imagen_url + "\"" +
                        "}";

                webSocketsCHAT.enviarMensajeAGrupo(fk_grupos, jsonMessage);
            } else if (texto != null) {
                String jsonMessage = "{" +
                        "\"type\":\"text\"," +
                        "\"text\":\"" + escapeJson(texto) + "\"" +
                        "}";

                webSocketsCHAT.enviarMensajeAGrupo(fk_grupos, jsonMessage);
            }

            response.sendRedirect("ChatMaestro.jsp?id_grupos=" + fk_grupos + "&materia=" + materia + "&nombre=" + nombre);

        } catch (Exception e) {
            e.printStackTrace();
            // Opcional: Redirigir con un mensaje de error
        }
    }

    // Método para obtener la extensión del archivo
    private String getFileExtension(String fileName) {
        if (fileName == null) return "";
        int dotIndex = fileName.lastIndexOf('.');
        return (dotIndex == -1) ? "" : fileName.substring(dotIndex);
    }

    // Método para obtener el nombre del archivo desde Part
    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String content : header.split(";")) {
            if (content.trim().startsWith("filename")) {
                String fileName = content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                return fileName;
            }
        }
        return null;
    }

    // Método para escapar caracteres especiales en JSON
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("/", "\\/")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
