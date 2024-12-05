<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="java.util.List" %>
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
    <title>Menú Maestro - Teams UV</title>
    <link rel="stylesheet" href="CSS/Menu.css">
    <style>
        .form-container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .form-container h2 {
            margin-bottom: 20px;
            font-size: 24px;
            color: #0879ef;
            text-align: center;
        }

        .form-container label {
            display: block;
            margin-bottom: 10px;
            font-size: 16px;
            color: #333333;
        }

        .form-container input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #E2E8F0;
            border-radius: 5px;
            font-size: 16px;
            margin-bottom: 20px;
        }

        .form-container button {
            background-color: #0879ef;
            color: #ffffff;
            font-size: 16px;
            font-weight: bold;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        .form-container button:hover {
            background-color: #005bb5;
        }
    </style>
</head>
<body>
<div class="main">
    <!-- BARRA LATERAL -->
    <div class="lateral">
        <h1>Teams UV</h1>
        <a href="MenuMaestro.jsp">Inicio</a>

        <a href="ConfiguracionMaestro.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>

    <!-- CONTENIDO MAIN -->
    <div class="main-content">
        <div class="header">
            <h1>Crear un nuevo grupo</h1>
        </div>
        <div class="info-section">
            <div class="form-container">

                <form action="CrearGrupoServlet" method="post">
                    <label for="nombreGrupo">Nombre del Grupo:</label>
                    <input type="text" id="nombreGrupo" name="nombreGrupo" placeholder="Ingrese el nombre del grupo"
                           required>

                    <label for="ncontrol">Numero de control maestro:</label>
                    <input type="text" id="ncontrol" name="ncontrol" value="<%= n_control %>" readonly>

                    <button type="submit">Crear Grupo</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
