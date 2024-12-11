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
        }


        .btn-buscar {
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
            border: none;
        }

        .btn-buscar:hover {
            background-color: #005bb5;
            transform: scale(1.05);
        }

        .btn-buscar:active {
            background-color: #005bb5;
            transform: scale(0.95);
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
            display: inline-block;
            background-color: #ff4d4d;
            color: white;
            font-size: 16px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
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
            <button type="button" class="btn-buscar" style="font-family: JetBrains Mono"
                    onclick="window.location.href='ChatMaestro.jsp?id_grupos=<%=id_grupo%>&materia=<%=materia%>&nombre=<%=nombre%>'">
                Atras
            </button>
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
                    <td><%= alumno.getMatricula() %>
                    </td>
                    <td><%= alumno.getNombre() + " " + alumno.getSegundo_nombre() + " " + alumno.getApellido_paterno() + " " + alumno.getApellido_materno() %>
                    </td>
                    <td><%= alumno.getCorreo() %>
                    </td>
                    <td>
                        <!-- Botón para eliminar -->
                        <form action="EliminarAlumnoGrupoServlet" method="post">
                            <input type="hidden" name="matricula" value="<%= alumno.getMatricula() %>">
                            <input type="hidden" name="id_grupos" value="<%= id_grupo %>">
                            <input type="hidden" name="materia" value="<%= materia %>">
                            <input type="hidden" name="nombre" value="<%= nombre %>">


                            <button type="submit" class="btn-eliminar" style="font-family: JetBrains Mono">Eliminar
                            </button>
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
