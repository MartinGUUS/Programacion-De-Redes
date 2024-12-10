<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Configurar las cabeceras de la respuesta para evitar caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    // Validar sesión activa
    if (request.getSession(false) == null || request.getSession().getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Obtener la matrícula del usuario desde la sesión
    String matricula = (String) request.getSession().getAttribute("usuario");

    // Llamar al servicio RMI para obtener las materias
    List<Grupos_Alumnos> listaMaterias = null;
    try {
        LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
        listaMaterias = loginService.obtenerGruposPorAlumno(matricula);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menú Alumno - Teams UV</title>
    <link rel="stylesheet" href="CSS/Menu.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=JetBrains+Mono:ital,wght@0,100..800;1,100..800&display=swap"
          rel="stylesheet">
    <style>
        html, body {
            font-family: 'JetBrains Mono', sans-serif;
            margin: 0; /* Opcional: quita los márgenes predeterminados */
            padding: 0;
        }

    </style>
    <style>

        .info-section {
            margin: 20px;
            padding: 20px;
            background-color: #f9f9f9;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
        }

        .info-section h2 {
            font-size: 20px;
            color: #2d3748;
            margin-bottom: 15px;
            font-weight: bold;
        }

        .info-section p, .info-section ul {
            font-size: 16px;
            color: #4a5568;
            line-height: 1.5;
        }

        .info-section ul li {
            margin-bottom: 10px;
            list-style: disc;
            margin-left: 20px;
        }

    </style>
    <script>
        function toggleSubmenu(id) {
            const submenu = document.getElementById(id);
            submenu.style.display = submenu.style.display === "block" ? "none" : "block";
        }
    </script>

    <!--
    <script>
        const ws = new WebSocket("ws://localhost:8080/ProyectoRedes/wsNotificaciones");

        ws.onmessage = function (event) {
            const notificationButton = document.querySelector(".btn-notificaciones");

            notificationButton.style.backgroundColor = "#ff0000";

            setTimeout(() => {
                notificationButton.style.backgroundColor = "#0879ef";
            }, 1000);
        };

        ws.onerror = function (error) {
            alert("Error en WebSocket:", error);
        };
    </script>
    -->
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
                <!-- <a href="#">-- Unirse a un chat --</a> -->
                <%
                    if (listaMaterias != null && !listaMaterias.isEmpty()) {
                        for (Grupos_Alumnos grupo : listaMaterias) {
                %>
                <a href="ChatAlumno.jsp?materia=<%= grupo.getNombreMateria() %>&id_grupos=<%= grupo.getFk_grupos() %>">
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
        <a href="ConfiguracionesAlumnos.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>

    <!-- CONTENIDO MAIN -->
    <div class="main-content">
        <div class="header">
            <h1>Bienvenido alumno: <%= request.getSession().getAttribute("nombre") %>
            </h1>
            <button
                    type="button"
                    class="btn-notificaciones"
                    style="margin-bottom: 20px; padding: 10px 20px; font-size: 14px; font-family: 'JetBrains Mono'; border: none; background-color: #0879ef; color: white; border-radius: 5px; cursor: pointer; transition: background-color 0.3s ease;">
                Notificaciones
            </button>

        </div>
        <!-- Botón para redirigir a notificaciones -->

        <div class="info-section">
            <h2>Materias Inscritas</h2>
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
            <p>Desde este menú puedes acceder a los chats de tus materias, revisar materiales y estar al tanto de las
                notificaciones importantes.</p>
        </div>
    </div>

</div>
</body>
</html>
