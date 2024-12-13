<%@ page import="Modelo.Grupos" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="java.util.List" %>
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
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modificar o Eliminar Chats - Teams UV</title>
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
    <script>
        function toggleSubmenu(id) {
            const submenu = document.getElementById(id);
            submenu.style.display = submenu.style.display === "block" ? "none" : "block";
        }
    </script>

    <style>
        .info-section h3 {
            margin-bottom: 20px;
            color: #2D3748;
            font-size: 20px;
            font-weight: bold;
        }

        .tabla-grupos {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .tabla-grupos th,
        .tabla-grupos td {
            padding: 12px 15px;
            border: 1px solid #E2E8F0;
            text-align: left;
            font-size: 14px;
        }

        .tabla-grupos th {
            background-color: #0879ef;
            color: white;
            font-weight: bold;
        }

        .tabla-grupos tr:nth-child(even) {
            background-color: #f7f9fc;
        }

        .input-nombre {
            width: 100%;
            padding: 8px;
            border: 1px solid #E2E8F0;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn-guardar,
        .btn-eliminar {
            display: inline-block;
            background-color: #0879ef;
            color: white;
            font-size: 16px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .btn-guardar:hover {
            background-color: #005bb5;
            transform: scale(1.05);
        }

        .btn-guardar:active {
            background-color: #005bb5;
            transform: scale(0.95);
        }

        .btn-eliminar {
            background-color: #ff4d4d;
        }

        .btn-eliminar:hover {
            background-color: #cc0000;
            transform: scale(1.05);
        }

        .btn-eliminar:active {
            background-color: #cc0000;
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
            <h1>Modificar o Eliminar Chats</h1>
        </div>
        <div class="info-section">
            <h3>Gestión de Chats</h3>
            <table class="tabla-grupos">
                <thead>
                <tr>
                    <th>Nombre del Grupo</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (listaMaterias != null && !listaMaterias.isEmpty()) {
                        for (Grupos grupo : listaMaterias) {
                %>
                <tr>
                    <form action="ModificarEliminarGrupoServlet" method="post">
                        <td>
                            <input type="hidden" name="id_grupo" value="<%= grupo.getId_grupos() %>">
                            <input type="text" style="font-family: JetBrains Mono" name="nombre_grupo"
                                   value="<%= grupo.getNombre() %> "
                                   class="input-nombre">
                        </td>
                        <td>
                            <button type="submit" name="accion" value="guardar" class="btn-guardar"
                                    style="font-family: JetBrains Mono">Guardar Cambios
                            </button>
                            <button type="submit" name="accion" value="eliminar" class="btn-eliminar"
                                    style="font-family: JetBrains Mono">Eliminar
                            </button>
                        </td>
                    </form>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="2">No tienes grupos creados.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>

        </div>
    </div>
</div>
</body>
</html>
