package Controlador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/CerrarSesionServlet")
public class CerrarSesionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Invalidar la sesión
        if (request.getSession(false) != null) {
            request.getSession().invalidate();
        }

        // Redirigir al login
        response.sendRedirect("index.jsp");
    }
}
