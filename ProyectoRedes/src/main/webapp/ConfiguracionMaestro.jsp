<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Maestros" %>
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

    List<Grupos> listaMaterias = null;
    try {
        LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
        listaMaterias = loginService.obtenerGruposPorMaestro(n_control);
    } catch (Exception e) {
        e.printStackTrace();
    }

    Maestros maestro = null;
    String nombre = "";
    String nom = "";
    String apePaterno = "";
    String apeMaterno = "";
    String correo = "";
    try {
        LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
        maestro = loginService.obtenerMaestroPorNControl(n_control);
        nom = maestro.getNombre();
        nombre = maestro.getNombre() + " " + maestro.getSegundo_nombre();
        apePaterno = maestro.getApellido_paterno();
        apeMaterno = maestro.getApellido_materno();
        correo = maestro.getCorreo();
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
            margin: 0; /* Opcional: quita los márgenes predeterminados */
            padding: 0;
        }

    </style>
    <style>
        .info-section {
            background-color: #f7f9fc;
            padding: 20px;
            border: 1px solid #e2e8f0;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin: 20px;
            font-size: 16px;
        }

        .info-section p {
            margin: 10px 0;
            color: #2d3748;
        }

        .info-section p b {
            color: #0879ef;
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
        <a href="ConfiguracionMaestro.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Perfil de <%= nom %>

        </div>
        <div class="info-section">
            <p><b>Matricula:</b> <%=n_control%>
            </p>
            <p><b>Nombre:</b> <%=nombre%>
            </p>
            <p><b>Apellido Paterno:</b> <%=apePaterno%>
            </p>
            <p><b>Apellido Materno:</b> <%=apeMaterno%>
            </p>
            <p><b>Correo electronico:</b> <%=correo%>
            </p>

        </div>
    </div>
</div>
</body>
</html>
