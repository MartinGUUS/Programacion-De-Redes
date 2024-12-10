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
import java.util.stream.Collectors;

@WebServlet("/EnviarMensajeServlet")
@MultipartConfig
public class EnviarMensajeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener el usuario de la sesión
        String fk_maestros = (String) request.getSession().getAttribute("usuario");
        String materia = request.getParameter("materia");
        String nombre = request.getParameter("nom");

        // Obtener el texto del mensaje
        Part mensajePart = request.getPart("mensaje");
        String texto = null;
        if (mensajePart != null) {
            texto = new BufferedReader(new InputStreamReader(mensajePart.getInputStream()))
                    .lines().collect(Collectors.joining("\n")).trim(); // Eliminar espacios en blanco
        }

        // Obtener el grupo
        Part grupoPart = request.getPart("grupo");
        String grupo = null;
        if (grupoPart != null) {
            grupo = new BufferedReader(new InputStreamReader(grupoPart.getInputStream()))
                    .lines().collect(Collectors.joining("\n"));
        }

        // Validación básica para grupo
        if (grupo == null || grupo.trim().isEmpty()) {
            return; // Terminar si no hay grupo
        }

        int fk_grupos = Integer.parseInt(grupo);

        // Obtener el archivo de imagen
        byte[] imagen = null;
        Part imagenPart = request.getPart("imagen");
        if (imagenPart != null && imagenPart.getSize() > 0) {
            imagen = imagenPart.getInputStream().readAllBytes();
        }

        // Validar que haya texto o imagen
        if ((texto == null || texto.trim().isEmpty()) && imagen == null) {
            System.out.println("Mensaje vacío: no se enviará nada.");
            response.sendRedirect("ChatMaestro.jsp?id_grupos=" + fk_grupos + "&materia=" + materia + "&nombre=" + nombre);
            return; // No hacer nada si ambos están vacíos
        }

        try {
            // Asegurarte de que el servicio RMI esté corriendo
            LoginService mensajeriaService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");

            Mensajes mensaje;
            if (texto == null || texto.trim().isEmpty()) {
                // Solo imagen
                mensaje = new Mensajes(0, fk_maestros, fk_grupos, "Se ha enviado una imagen", imagen, new Timestamp(System.currentTimeMillis()));
            } else {
                // Texto y/o imagen
                mensaje = new Mensajes(0, fk_maestros, fk_grupos, texto, imagen, new Timestamp(System.currentTimeMillis()));
            }

            // Guardar en la base de datos
            mensajeriaService.enviarMensaje(mensaje);

            // Enviar mensaje a WebSocket y demás conexiones
            if (texto != null && !texto.trim().isEmpty()) {
                ChatSocketServer.broadcastMessage(texto, fk_grupos);
                ChatWebSocketEndpoint.enviarMensajeAGrupo(fk_grupos, texto);
            } else if (imagen != null) {
                ChatSocketServer.broadcastMessage("Se ha enviado una imagen - recarga pagina", fk_grupos);
                ChatWebSocketEndpoint.enviarMensajeAGrupo(fk_grupos, "Se ha enviado una imagen - recarga pagina");
            }

            response.sendRedirect("ChatMaestro.jsp?id_grupos=" + fk_grupos + "&materia=" + materia + "&nombre=" + nombre);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
