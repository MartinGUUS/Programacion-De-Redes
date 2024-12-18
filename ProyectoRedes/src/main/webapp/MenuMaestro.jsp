<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Grupos" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Configurar las cabeceras de la respuesta para evitar caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (request.getSession(false) == null || request.getSession().getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String n_control = (String) request.getSession().getAttribute("usuario");
    String nombreMaestro = (String) request.getSession().getAttribute("nombre");


    List<Grupos> listaMaterias = null;
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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=JetBrains+Mono:ital,wght@0,100..800;1,100..800&display=swap"
          rel="stylesheet">
    <style>
        html, body {
            font-family: 'JetBrains Mono', sans-serif;
            margin: 0;
            padding: 0;
        }

    </style>
    <style>

        .submenuPrincipal a:first-child {
            font-size: 16px;
            font-weight: bold;
            color: #ffffff; /* Color blanco */
            background-color: rgba(89, 201, 98);

            text-align: center;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .submenuPrincipal a:first-child:hover {
            background-color: rgb(46, 114, 52);
            transform: scale(1.05);
        }

        /* Estilo adicional para el enlace destacado */
        .lateral .submenuPrincipal .highlight-link {
            color: #ffffff; /* Color blanco */
            font-weight: bold;
            background-color: rgba(89, 201, 98);
        }

        .lateral .submenuPrincipal .highlight-link:hover {
            color: #ffffff; /* Color blanco */
            background-color: rgb(46, 114, 52);
        }

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
</head>
<body>
<div class="main">
    <div class="lateral">
        <h1>Teams UV</h1>
        <a href="MenuMaestro.jsp">Inicio</a>
        <div>
            <div class="menu-item" onclick="toggleSubmenu('formsSubmenu')">Chats de trabajo</div>
            <div id="formsSubmenu" class="submenuPrincipal">
                <a href="CrearChats.jsp?maestro=<%=n_control%>">-- CREAR CHAT --</a>
                <%
                    if (listaMaterias != null && !listaMaterias.isEmpty()) {
                        for (Grupos grupo : listaMaterias) {
                %>
                <a href="ChatMaestro.jsp?id_grupos=<%= grupo.getId_grupos() %>&materia=<%= grupo.getNombre() %>&nombre=<%=nombreMaestro%>">
                    <%= grupo.getNombre() %>
                </a>
                <%
                    }
                } else {
                %>
                <p>No tienes materias inscritas.</p>
                <%
                    }
                %>
                <a href="ModificarEliminarChats.jsp?maestro=<%=n_control%>" class="highlight-link">
                    MODIFICAR O ELIMINAR
                </a>
            </div>
        </div>
        <a href="ConfiguracionMaestro.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Bienvenido maestro: <%= request.getSession().getAttribute("nombre") %>
            </h1>
        </div>
        <div class="info-section">
            <h2>Gestiona tus grupos</h2>
            <ul>
                <%
                    if (listaMaterias != null && !listaMaterias.isEmpty()) {
                        for (Grupos grupo : listaMaterias) {
                %>
                <li><%= grupo.getNombre() %>
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


