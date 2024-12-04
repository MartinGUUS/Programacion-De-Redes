package Controlador;

import Modelo.Alumnos;
import Servicios.LoginService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.rmi.Naming;

@WebServlet("/AgregarAlumnoGrupoServlet")
public class AgregarAlumnoGrupoServlet extends HttpServlet {


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String matricula = request.getParameter("matricula");
        String grupoStr = request.getParameter("id_grupos");
        String ncontrol = request.getParameter("ncontrol");
        String materia = request.getParameter("materia");

        // Validar si el parámetro 'id_grupos' es válido
        if (grupoStr == null || grupoStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El ID del grupo es obligatorio.");
            return;
        }

        try {
            int grupo = Integer.parseInt(grupoStr);

            LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
            if (loginService.obtenerGruposPorAlumno(matricula, grupo) == 0) {
                loginService.insertarGrupoAlumno(grupo, matricula, ncontrol);
            } else {
                System.out.println("ya esta el alumno");
            }

            response.sendRedirect("ChatMaestro.jsp?id_grupos=" + grupo + "&materia=" + materia); // Cambia 'success.jsp' por la página adecuada
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El ID del grupo debe ser un número válido.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al agregar el alumno: " + e.getMessage());
        }
    }
}
