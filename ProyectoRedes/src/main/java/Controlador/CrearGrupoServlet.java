package Controlador;


import Servicios.LoginService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.rmi.Naming;
import java.rmi.NotBoundException;

@WebServlet("/CrearGrupoServlet")
public class CrearGrupoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombre = request.getParameter("nombreGrupo");
        String ncontrol = request.getParameter("ncontrol");

        try {
            LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
            loginService.insertarGrupo(nombre, ncontrol);
            response.sendRedirect("MenuMaestro.jsp");
        } catch (NumberFormatException e) {
            e.printStackTrace();
        } catch (NotBoundException e) {
            throw new RuntimeException(e);
        }
    }
}
