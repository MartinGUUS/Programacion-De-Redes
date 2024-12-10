package Controlador;

import Datos.ChatWebSocketEndpoint;
import Modelo.Mensajes;
import Datos.ChatSocketServer;
import Servicios.LoginService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.rmi.Naming;
import java.sql.Timestamp;
import java.util.Base64;
import java.util.stream.Collectors;

@WebServlet("/EnviarMensajeServlet")
@MultipartConfig
public class EnviarMensajeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fk_maestros = (String) request.getSession().getAttribute("usuario");
        String materia = request.getParameter("materia");
        String nombre = request.getParameter("nom");

        Part mensajePart = request.getPart("mensaje");
        String texto = null;
        if (mensajePart != null) {
            texto = new BufferedReader(new InputStreamReader(mensajePart.getInputStream()))
                    .lines().collect(Collectors.joining("\n")).trim();
        }

        Part grupoPart = request.getPart("grupo");
        String grupo = null;
        if (grupoPart != null) {
            grupo = new BufferedReader(new InputStreamReader(grupoPart.getInputStream()))
                    .lines().collect(Collectors.joining("\n"));
        }

        if (grupo == null || grupo.trim().isEmpty()) {
            return;
        }

        int fk_grupos = Integer.parseInt(grupo);

        byte[] imagen = null;
        Part imagenPart = request.getPart("imagen");
        if (imagenPart != null && imagenPart.getSize() > 0) {
            imagen = imagenPart.getInputStream().readAllBytes();
        }

        if ((texto == null || texto.trim().isEmpty()) && imagen == null) {
            response.sendRedirect("ChatMaestro.jsp?id_grupos=" + fk_grupos + "&materia=" + materia + "&nombre=" + nombre);
            return;
        }

        try {
            LoginService mensajeriaService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
            Mensajes mensaje;
            if (texto == null || texto.trim().isEmpty()) {
                mensaje = new Mensajes(0, fk_maestros, fk_grupos, "Se ha enviado una imagen", imagen, new Timestamp(System.currentTimeMillis()));
            } else {
                mensaje = new Mensajes(0, fk_maestros, fk_grupos, texto, imagen, new Timestamp(System.currentTimeMillis()));
            }

            mensajeriaService.enviarMensaje(mensaje);

            if (imagen != null) {
                String base64Image = Base64.getEncoder().encodeToString(imagen);
                String jsonMessage = "{" +
                        "\"type\":\"image\"," +
                        "\"text\":\"" + (texto != null ? texto : "") + "\"," +
                        "\"imageData\":\"" + base64Image + "\"}";

                ChatWebSocketEndpoint.enviarMensajeAGrupo(fk_grupos, jsonMessage);
            } else if (texto != null && !texto.trim().isEmpty()) {
                String jsonMessage = "{" +
                        "\"type\":\"text\"," +
                        "\"text\":\"" + texto + "\"}";

                ChatWebSocketEndpoint.enviarMensajeAGrupo(fk_grupos, jsonMessage);
            }

            response.sendRedirect("ChatMaestro.jsp?id_grupos=" + fk_grupos + "&materia=" + materia + "&nombre=" + nombre);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

