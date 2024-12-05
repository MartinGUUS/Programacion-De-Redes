<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Grupos" %>
<%@ page import="Modelo.Alumnos" %>
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

    // Obtener el id del grupo
    int id_grupo = Integer.parseInt(request.getParameter("id_grupos"));

    // Obtener la lista de alumnos del grupo
    List<Alumnos> listaAlumnos = null;
    try {
        LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
        listaAlumnos = loginService.obtenerTodosLosAlumnosPorGrupo(id_grupo);
    } catch (Exception e) {
        e.printStackTrace();
    }

    String materia = request.getParameter("materia");
    if (materia == null || materia.isEmpty()) {
        materia = "Sin nombre";
    }

    String nombre = request.getParameter("nombre");
    if (nombre == null || nombre.isEmpty()) {
        nombre = "sin nombre";
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
        .info-section {
            margin: 20px;
        }

        .tabla-alumnos {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .tabla-alumnos th,
        .tabla-alumnos td {
            padding: 12px 15px;
            border: 1px solid #E2E8F0;
            text-align: left;
            font-size: 14px;
        }

        .tabla-alumnos th {
            background-color: #0879ef;
            color: white;
            font-weight: bold;
        }

        .tabla-alumnos tr:nth-child(even) {
            background-color: #f7f9fc;
        }

        .btn-eliminar {
            background-color: #ff4d4d;
            color: white;
            font-size: 14px;
            font-weight: bold;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
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
        <a href="ConfiguracionMaestro.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>

    <!-- CONTENIDO MAIN -->
    <div class="main-content">
        <div class="header">
            <h1>Consulta los miembros de la clase</h1>
        </div>
        <div class="info-section">
            <h3>Alumnos del Grupo</h3>
            <table class="tabla-alumnos">
                <thead>
                <tr>
                    <th>Matrícula</th>
                    <th>Nombre</th>
                    <th>Correo</th>
                    <th>Eliminar del grupo</th>
                </tr>
                </thead>
                <tbody>
                <% if (listaAlumnos != null && !listaAlumnos.isEmpty()) {
                    for (Alumnos alumno : listaAlumnos) { %>
                <tr>
                    <td><%= alumno.getMatricula() %></td>
                    <td><%= alumno.getNombre() + " " + alumno.getSegundo_nombre() + " " + alumno.getApellido_paterno() + " " + alumno.getApellido_materno() %></td>
                    <td><%= alumno.getCorreo() %></td>
                    <td>
                        <!-- Botón para eliminar -->
                        <form action="EliminarAlumnoGrupoServlet" method="post">
                            <input type="hidden" name="matricula" value="<%= alumno.getMatricula() %>">
                            <input type="hidden" name="id_grupos" value="<%= id_grupo %>">
                            <input type="hidden" name="materia" value="<%= materia %>">
                            <input type="hidden" name="nombre" value="<%= nombre %>">


                            <button type="submit" class="btn-eliminar">Eliminar</button>
                        </form>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="4">No se encontraron alumnos en este grupo.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
