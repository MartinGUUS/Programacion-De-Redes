package Controlador;

import Servicios.LoginService; // Interfaz del servicio RMI

import java.io.IOException;
import java.rmi.Naming;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");

        try {
            // Conectar al servicio RMI
            LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");

            String nombreUsuario = null; // Para guardar el nombre

            if (usuario.toLowerCase().startsWith("zs")) { // Es un alumno
                boolean esValido = loginService.loginAlumno(usuario, contrasena);
                if (esValido) {
                    nombreUsuario = loginService.obtenerNombreAlumno(usuario);
                    request.getSession().setAttribute("usuario", usuario);
                    request.getSession().setAttribute("nombre", nombreUsuario); // Guardar el nombre
                    response.sendRedirect("MenuAlumno.jsp");
                } else {
                    request.setAttribute("mensaje", "Credenciales incorrectas para alumno.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }
            } else { // Es un maestro
                boolean esValido = loginService.loginMaestro(usuario, contrasena);
                if (esValido) {
                    nombreUsuario = loginService.obtenerNombreMaestro(usuario);
                    request.getSession().setAttribute("usuario", usuario);
                    request.getSession().setAttribute("nombre", nombreUsuario); // Guardar el nombre
                    response.sendRedirect("MenuMaestro.jsp");
                } else {
                    request.setAttribute("mensaje", "Credenciales incorrectas para maestro.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al conectarse al servidor.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}

