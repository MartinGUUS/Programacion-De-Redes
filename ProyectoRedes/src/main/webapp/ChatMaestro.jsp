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
    <title>Chat de Materias</title>
    <link rel="stylesheet" href="CSS/Menu.css">
    <link rel="stylesheet" href="CSS/Chat.css">
    <script>
        function toggleSubmenu(id) {
            const submenu = document.getElementById(id);
            submenu.style.display = submenu.style.display === "block" ? "none" : "block";
        }
    </script>
</head>
<body>
<%
    String materia = request.getParameter("materia");
    if (materia == null || materia.isEmpty()) {
        materia = "Sin nombre";
    }
%>
<div class="main">
    <div class="lateral">
        <h1>Teams UV</h1>
        <a href="MenuMaestro.jsp">Inicio</a>
        <div>
            <div class="menu-item" onclick="toggleSubmenu('formsSubmenu')">Chats de trabajo</div>
            <div id="formsSubmenu" class="submenuPrincipal">
                <a href="#">-- Unirse a un chat --</a>
                <a href="ChatMaestro.jsp?materia=Materia1">Materia 1</a>
                <a href="ChatMaestro.jsp?materia=Materia2">Materia 2</a>
            </div>
        </div>
        <a href="#">Configuraciones</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>
    <div class="main-content">
        <div class="header">
            <h1>Chat de <%= materia %>
            </h1>
        </div>
        <div class="chat-container">
            <div class="chat-messages">
                <p><strong>Profesor:</strong> Bienvenido al chat de <%= materia %>.</p>
                <p><strong>Profesor:</strong> Por favor, revisa los materiales publicados.</p>
            </div>
            <form class="chat-input" method="post" enctype="multipart/form-data" action="EnviarMensajeServlet">
                <textarea name="mensaje" placeholder="Escribe un mensaje..." rows="3"></textarea>
                <input type="file" name="imagen" accept="image/*">
                <button type="submit">Enviar</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
