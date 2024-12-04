<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Maestros" %>
<%@ page import="Modelo.Grupos" %>
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
        <a href="MenuMaestro.jsp">Inicio</a>
        <div>
            <div class="menu-item" onclick="toggleSubmenu('formsSubmenu')">Gestión de Grupos</div>
            <div id="formsSubmenu" class="submenuPrincipal">
                <a href="CrearChats.jsp?maestro=<%=n_control%>">-- Crear un chat --</a>
                <%
                    if (listaMaterias != null && !listaMaterias.isEmpty()) {
                        for (Grupos grupo : listaMaterias) {
                %>
                <a href="ChatMaestro.jsp?materia=<%= grupo.getNombre() %>">
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
            </div>
        </div>
        <a href="ConfiguracionMaestro.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>

    <!-- CONTENIDO MAIN -->
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
