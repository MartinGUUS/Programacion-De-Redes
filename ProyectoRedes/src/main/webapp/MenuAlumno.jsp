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
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menú Alumno - Teams UV</title>
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
        <a href="MenuAlumno.jsp">Inicio</a>
        <div>
            <div class="menu-item" onclick="toggleSubmenu('formsSubmenu')">Chats de trabajo</div>
            <div id="formsSubmenu" class="submenuPrincipal">
                <a href="#">-- Unirse a un chat --</a>
                <a href="ChatAlumno.jsp?materia=Materia1">Materia 1</a>
                <a href="ChatAlumno.jsp?materia=Materia2">Materia 2</a>
            </div>
        </div>
        <a href="#">Configuraciones</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>

    <!-- CONTENIDO MAIN -->
    <div class="main-content">
        <div class="header">
            <h1>Bienvenido alumno: <%= request.getSession().getAttribute("nombre") %>
            </h1>
        </div>
        <div class="info-section">
            <h2>Materias Inscritas</h2>
            <ul>
                <li>Materia 1</li>
                <li>Materia 2</li>
                <li>Materia 3</li>
            </ul>

            <h2>Información</h2>
            <p>Desde este menú puedes acceder a los chats de tus materias, revisar materiales y estar al tanto de las
                notificaciones importantes.</p>
        </div>
    </div>
</div>
</body>
</html>
