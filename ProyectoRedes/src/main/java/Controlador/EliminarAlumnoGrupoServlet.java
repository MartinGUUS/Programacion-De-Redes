package Controlador;

import Servicios.LoginService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.rmi.Naming;

@WebServlet("/EliminarAlumnoGrupoServlet")
public class EliminarAlumnoGrupoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String matricula = request.getParameter("matricula");
        String grupoStr = request.getParameter("id_grupos");
        String materia = request.getParameter("materia");
        int grupoint = 0;
        if (grupoStr != null && !grupoStr.equals("")) {
            grupoint = Integer.parseInt(grupoStr);
        }

        try {
            LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
            loginService.eliminarAlumnoDeGrupo(matricula, grupoint);
            response.sendRedirect("ChatMaestro.jsp?materia=" + materia + "&id_grupos=" + grupoint);
        } catch (Exception e) {
            System.out.println(e.toString());
        }


    }
}
