package Controlador;

import Modelo.Mensajes;
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


        // Obtener el parámetro "mensaje"
        Part mensajePart = request.getPart("mensaje");
        String texto = null;
        if (mensajePart != null) {
            texto = new BufferedReader(new InputStreamReader(mensajePart.getInputStream()))
                    .lines().collect(Collectors.joining("\n"));
        }

        // Obtener el parámetro "grupo"
        Part grupoPart = request.getPart("grupo");
        String grupo = null;
        if (grupoPart != null) {
            grupo = new BufferedReader(new InputStreamReader(grupoPart.getInputStream()))
                    .lines().collect(Collectors.joining("\n"));
        }

        // Imprimir para depuración
        System.out.println("el grupo id es: " + grupo + " mensaje: " + texto);

        if (grupo != null && !grupo.equals("")) {
            int fk_grupos = Integer.parseInt(grupo);
            byte[] imagen = null;

            // Obtener el archivo de imagen
            Part imagenPart = request.getPart("imagen");
            if (imagenPart != null && imagenPart.getSize() > 0) {
                imagen = imagenPart.getInputStream().readAllBytes();
            }

            try {
                // Asegúrate de que el servicio RMI esté corriendo y registrado correctamente
                LoginService mensajeriaService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
                if (texto == null && imagen != null) {
                    Mensajes mensaje = new Mensajes(0, fk_maestros, fk_grupos, "Se ha enviado una imagen", imagen, new Timestamp(System.currentTimeMillis()));
                    mensajeriaService.enviarMensaje(mensaje);
                } else {
                    Mensajes mensaje = new Mensajes(0, fk_maestros, fk_grupos, texto, imagen, new Timestamp(System.currentTimeMillis()));
                    mensajeriaService.enviarMensaje(mensaje);
                }
                response.sendRedirect("ChatMaestro.jsp?id_grupos=" + fk_grupos + "&materia=" + materia + "&nombre=" + nombre);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
