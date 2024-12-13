<%@ page import="Modelo.Alumnos" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Configurar las cabeceras de la respuesta para evitar cache
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (request.getSession(false) == null || request.getSession().getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String materia = request.getParameter("materia");
    if (materia == null || materia.isEmpty()) {
        materia = "Sin nombre";
    }

    Alumnos alumno = (Alumnos) request.getAttribute("resultadosBusqueda");
    String n_control = (String) request.getSession().getAttribute("usuario");

    String idgrupo = request.getParameter("id_grupos");
    if (idgrupo == null || idgrupo.isEmpty()) {
        idgrupo = "Sin id grupo";
    }

    String nombre = request.getParameter("nombre");
    if (nombre == null || nombre.isEmpty()) {
        nombre = "no se recibio nombre en agregar alumno";
    }


    String mensaje = request.getParameter("mensaje");
    if (mensaje == null || mensaje.isEmpty()) {
        mensaje = "Usuario no encontrado.";
    }


%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agregar Alumnos - Teams UV</title>
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
        .form-busqueda {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .form-busqueda input[type="text"] {
            padding: 8px;
            font-size: 14px;
            border: 1px solid #E2E8F0;
            border-radius: 5px;
            width: 250px;
        }

        .form-busqueda .btn-buscar {
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
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .btn-buscar:hover {
            background-color: #005bb5;
            transform: scale(1.05);
        }

        .btn-buscar:active {
            background-color: #005bb5;
            transform: scale(0.95);
        }

        .form-busqueda .btn-buscar:hover {
            background-color: #005bb5;
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

        .tabla-alumnos .btn-agregar {
            background-color: #0879ef;
            color: white;
            font-size: 14px;
            font-weight: bold;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .tabla-alumnos .btn-agregar:hover {
            background-color: #005bb5;
        }
    </style>
</head>
<body>
<div class="main">
    <div class="lateral">
        <h1>Teams UV
        </h1>
        <a href="MenuMaestro.jsp">Inicio</a>
        <div>

            <a href="ConfiguracionMaestro.jsp">Perfil</a>
            <a href="CerrarSesionServlet">Cerrar sesión</a>
        </div>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Agregar alumnos en <%= materia %>
            </h1>
            <button type="button" class="btn-buscar" style="font-family: JetBrains Mono"
                    onclick="window.location.href='ChatMaestro.jsp?id_grupos=<%=idgrupo%>&materia=<%=materia%>&nombre=<%=nombre%>'">
                Atras
            </button>
        </div>
        <div class="info-section">
            <form action="BuscarAlumnoServlet" method="get" class="form-busqueda">
                <input type="hidden" name="materia" value="<%= materia %>">
                <input type="hidden" name="id_grupos" value="<%= idgrupo %>">
                <input type="hidden" name="nombre" value="<%= nombre %>">
                <input type="text" id="busqueda" name="busqueda" placeholder="Ingresa la matrícula..." required>
                <button type="submit" class="btn-buscar" style="font-family: JetBrains Mono">Buscar</button>

            </form>


            <h3>Resultados de la búsqueda</h3>
            <table class="tabla-alumnos">
                <thead>
                <tr>
                    <th>Matrícula</th>
                    <th>Nombre</th>
                    <th>Acción</th>
                </tr>
                </thead>
                <tbody>
                <% if (alumno != null) { %>
                <tr>
                    <td><%= alumno.getMatricula() %>
                    </td>
                    <td><%= alumno.getNombre() + " " + alumno.getSegundo_nombre() + " " + alumno.getApellido_paterno() + " " + alumno.getApellido_materno() %>
                    </td>
                    <td>
                        <form action="AgregarAlumnoGrupoServlet" method="post">
                            <input type="hidden" name="matricula" value="<%= alumno.getMatricula() %>">
                            <input type="hidden" name="id_grupos" value="<%= idgrupo %>">
                            <input type="hidden" name="ncontrol" value="<%= n_control %>">
                            <input type="hidden" name="materia" value="<%= materia %>">
                            <input type="hidden" name="nombre" value="<%= nombre %>">

                            <button type="submit" class="btn-agregar">Agregar</button>
                        </form>

                    </td>
                </tr>
                <% } else if (mensaje != null) { %>
                <tr>
                    <td colspan="3"><%= mensaje%>
                    </td>
                </tr>
                <% } else { %>
                <tr>
                    <td colspan="3">Usuario no encontrado.
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
