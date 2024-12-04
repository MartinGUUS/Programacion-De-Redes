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

@WebServlet("/ModificarEliminarGrupoServlet")

public class ModificarEliminarGrupoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombreGrupo = request.getParameter("nombre_grupo");
        String idGrupo = request.getParameter("id_grupo");
        String accion = request.getParameter("accion");

        if (accion.equals("eliminar")) {
            try {
                LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
                loginService.desactivarGrupo(Integer.parseInt(idGrupo));


                response.sendRedirect("MenuMaestro.jsp");
            } catch (Exception e) {
                e.printStackTrace();
            }


        } else if (accion.equals("guardar")) {
            try {
                LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
                loginService.actualizarNombre(nombreGrupo, Integer.parseInt(idGrupo));
                response.sendRedirect("MenuMaestro.jsp");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }


    }
}
