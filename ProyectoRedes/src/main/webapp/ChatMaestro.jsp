<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="java.util.List" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
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
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat de Materias</title>
    <link rel="stylesheet" href="CSS/Chat.css">
    <link rel="stylesheet" href="CSS/Menu.css">

    <style>
        .agregarAlu {
            display: inline-block;
            background-color: #0879ef;
            color: white;
            font-size: 16px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .agregarAlu:hover {
            background-color: #005bb5;
            transform: scale(1.05);
        }

        .agregarAlu:active {
            background-color: #003f8c;
            transform: scale(0.95);
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
<%
    String materia = request.getParameter("materia");
    String idgrupo = request.getParameter("id_grupos");
    if (materia == null || materia.isEmpty()) {
        materia = "Sin nombre";
    }
    if (idgrupo == null || idgrupo.isEmpty()) {
        idgrupo = "Sin nombre";
    }
%>
<div class="main">
    <div class="lateral">
        <h1>Teams UV</h1>
        <a href="MenuMaestro.jsp">Inicio</a>

        <a href="ConfiguracionMaestro.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>
    <div class="main-content">
        <div class="header">
            <h1>Chat de <%= materia %>
            </h1>
            <a href="AgregarAlumnos.jsp?materia=<%= materia %>&id_grupos=<%=idgrupo%>" class="agregarAlu">Agregar
                alumnos</a>
            <a href="VerMiembros.jsp?id_grupos=<%=idgrupo%>" class="agregarAlu">Ver alumnos
                de <%=materia%>
            </a>
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
