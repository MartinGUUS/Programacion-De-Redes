<%@ page import="Modelo.Grupos" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="java.util.List" %>
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
    <title>Modificar o Eliminar Chats - Teams UV</title>
    <link rel="stylesheet" href="CSS/Menu.css">
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
            background-color: #0879ef;
            color: white;
            font-size: 14px;
            font-weight: bold;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-right: 5px;
        }

        .btn-guardar:hover {
            background-color: #005bb5;
        }

        .btn-eliminar {
            background-color: #ff4d4d;
        }

        .btn-eliminar:hover {
            background-color: #cc0000;
        }
    </style>
</head>
<body>
<div class="main">
    <!-- BARRA LATERAL -->
    <div class="lateral">
        <h1>Teams UV</h1>
        <a href="MenuMaestro.jsp">Inicio</a>
        <div>
            <div class="menu-item" onclick="toggleSubmenu('formsSubmenu')">Chats de trabajo</div>
            <div id="formsSubmenu" class="submenuPrincipal">
                <a href="CrearChats.jsp?maestro=<%=n_control%>">-- Crear un chat --</a>
                <%
                    if (listaMaterias != null && !listaMaterias.isEmpty()) {
                        for (Grupos grupo : listaMaterias) {
                %>
                <a href="ChatMaestro.jsp?id_grupos=<%= grupo.getId_grupos() %>&materia=<%= grupo.getNombre() %>">
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
                <a href="ModificarEliminarChats.jsp?maestro=<%=n_control%>">MODIFICAR O ELIMINAR CHATS</a>
            </div>
        </div>
        <a href="ConfiguracionMaestro.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>

    <!-- CONTENIDO MAIN -->
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
                            <input type="text" name="nombre_grupo" value="<%= grupo.getNombre() %>" class="input-nombre">
                        </td>
                        <td>
                            <!-- Botón para guardar cambios -->
                            <button type="submit" name="accion" value="guardar" class="btn-guardar">Guardar Cambios</button>
                            <!-- Botón para borrar el grupo -->
                            <button type="submit" name="accion" value="eliminar" class="btn-eliminar">Eliminar</button>
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
