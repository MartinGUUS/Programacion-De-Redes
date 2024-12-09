package Controlador;

import Modelo.Alumnos;
import Servicios.LoginService;
import Servicios.RegistroService;
import Modelo.Grupos_Alumnos;

import java.io.IOException;
import java.rmi.Naming;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/BuscarAlumnoServlet")
public class BuscarAlumnoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String matricula = request.getParameter("busqueda");
        String materia = request.getParameter("materia");
        String id_grupos = request.getParameter("id_grupos");
        String nombre = request.getParameter("nombre");
        String mensaje = "";
        Alumnos alumno = null;

        try {

            LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
            if (loginService.contarAlumnosEnGrupo(matricula, Integer.parseInt(id_grupos)) == 0) {
                alumno = loginService.obtenerAlumnoPorMatricula(matricula);
            }else{
                mensaje = "El alumno ya esta en el grupo";
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al buscar el alumno: " + e.getMessage());
        }

        request.setAttribute("resultadosBusqueda", alumno);
        request.setAttribute("materia", materia);
        request.setAttribute("id_grupos", id_grupos);
        request.setAttribute("nombre", nombre);
        request.setAttribute("mensaje", mensaje);


        request.getRequestDispatcher("AgregarAlumnos.jsp").forward(request, response);
    }
}