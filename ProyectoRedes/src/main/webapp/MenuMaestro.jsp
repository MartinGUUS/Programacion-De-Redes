<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Configurar las cabeceras de la respuesta para evitar caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    if (request.getSession(false) == null || request.getSession().getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Obtener la matrícula del usuario desde la sesión
    String n_control = (String) request.getSession().getAttribute("usuario");

    // Llamar al servicio RMI para obtener las materias
    List<Grupos_Alumnos> listaMaterias = null;
    try {
        LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
        listaMaterias = loginService.obtenerGruposPorMaestro(n_control);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menú Maestro - Teams UV</title>
    <link rel="stylesheet" href="CSS/Menu.css">
    <script>
        function toggleSubmenu(id) {
            const submenu = document.getElementById(id);
            submenu.style.display = submenu.style.display === "block" ? "none" : "block";
        }
    </script>
</head>
<body>
<div class="main">
    <!-- BARRA LATERAL -->
    <div class="lateral">
        <h1>Teams UV</h1>
        </h1>

        <div>
            <div class="menu-item" onclick="toggleSubmenu('formsSubmenu')">Gestión de Grupos</div>
            <div id="formsSubmenu" class="submenuPrincipal">
                <a href="#">-- Unirse a un chat --</a>
                <%
                    if (listaMaterias != null && !listaMaterias.isEmpty()) {
                        for (Grupos_Alumnos grupo : listaMaterias) {
                %>
                <a href="ChatMaestro.jsp?materia=<%= grupo.getNombreMateria() %>">
                    <%= grupo.getNombreMateria() %>
                </a>
                <%
                    }
                } else {
                %>
                <p>No tienes materias inscritas.</p>
                <%
                    }
                %>
            </div>
        </div>
        <a href="#">Configuraciones</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>

    <!-- CONTENIDO MAIN -->
    <div class="main-content">
        <div class="header">
            <h1>Bienvenido maestro: <%= request.getSession().getAttribute("nombre") %>

        </div>
        <div class="info-section">
            <h2>Gestión de Grupos</h2>
            <p>Aquí puedes crear grupos para tus materias, gestionar alumnos y revisar la actividad en los chats.</p>
            <ul>
                <%
                    if (listaMaterias != null && !listaMaterias.isEmpty()) {
                        for (Grupos_Alumnos grupo : listaMaterias) {
                %>
                <li><%= grupo.getNombreMateria() %>
                </li>
                <%
                    }
                } else {
                %>
                <li>No tienes materias inscritas.</li>
                <%
                    }
                %>
            </ul>

            <h2>Información</h2>
            <p>Este es tu espacio para mantenerte conectado con tus alumnos y gestionar materiales de estudio.</p>
        </div>
    </div>
</div>
</body>
</html>
