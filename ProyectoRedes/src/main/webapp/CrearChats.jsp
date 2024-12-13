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

        .btn-buscar:hover {
            background-color: #005bb5;
        }

        .btn-buscar {
            background-color: #0879ef;
            color: white;
            font-size: 14px;
            font-weight: bold;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

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
            <h1>Crear un nuevo grupo</h1>

        </div>
        <div class="info-section">
            <div class="form-container">

                <form action="CrearGrupoServlet" method="post">
                    <label for="nombreGrupo">Nombre del Grupo:</label>
                    <input type="text" id="nombreGrupo" name="nombreGrupo" style="font-family: JetBrains Mono"
                           placeholder="Ingrese el nombre del grupo"
                           required>

                    <label for="ncontrol">Numero de control maestro:</label>
                    <input type="text" id="ncontrol" name="ncontrol" value="<%= n_control %>"
                           style="font-family: JetBrains Mono" readonly>

                    <button type="submit" style="font-family: JetBrains Mono" class="agregarAlu">Crear Grupo
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
