package Controlador;

import Modelo.Alumnos;
import Modelo.Maestros;
import Servicios.RegistroService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.rmi.Naming;

@WebServlet("/registerServlet")
public class RegistroServlet extends HttpServlet {


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String matricula = request.getParameter("matricula");
        String nombre = request.getParameter("nombre");
        String segundoNombre = request.getParameter("segundoNombre");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm_password = request.getParameter("confirm_password");
        String mensaje = "";

        RegistroService registroService;
        try {
            registroService = (RegistroService) Naming.lookup("rmi://localhost/RegistroService");
        } catch (Exception e) {
            throw new ServletException("No se pudo conectar al servicio RMI", e);
        }


        try {
            boolean registrado = false;
            if (confirm_password.equals(password)) {
                if (matricula.toLowerCase().startsWith("zs")) {
                    // Es un alumno
                    Alumnos alumno = new Alumnos(
                            matricula, nombre, segundoNombre, apellidoPaterno, apellidoMaterno, email, password
                    );
                    registrado = registroService.registrarAlumno(alumno);
                } else {
                    // Es un maestro
                    Maestros maestro = new Maestros(
                            matricula, nombre, segundoNombre, apellidoPaterno, apellidoMaterno, email, password
                    );
                    registrado = registroService.registrarMaestro(maestro);
                }
                mensaje = "Error: Matricula registrada";

            } else {
                mensaje = "Contraseñas no sin iguales";
            }
            if (registrado) {
                response.sendRedirect("index.jsp?mensaje=Registro exitoso");
            } else {
                response.sendRedirect("Registro.jsp?error=" + mensaje);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Registro.jsp?error=Error al conectar con el servidor");
        }
    }
}
