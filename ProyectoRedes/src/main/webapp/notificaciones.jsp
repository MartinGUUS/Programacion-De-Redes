<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="Modelo.Alumnos" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  // Configurar las cabeceras de la respuesta para evitar caché
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
  response.setHeader("Pragma", "no-cache"); // HTTP 1.0
  response.setDateHeader("Expires", 0); // Proxies

  // Validar sesión activa
  if (request.getSession(false) == null || request.getSession().getAttribute("usuario") == null) {
    response.sendRedirect("index.jsp");
    return;
  }

  // Obtener la matrícula del usuario desde la sesión
  String matricula = (String) request.getSession().getAttribute("usuario");

  // Llamar al servicio RMI para obtener las materias
  List<Grupos_Alumnos> listaMaterias = null;
  try {
    LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
    listaMaterias = loginService.obtenerGruposPorAlumno(matricula);
  } catch (Exception e) {
    e.printStackTrace();
  }


  Alumnos alu = null;
  try {
    LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
    alu = loginService.obtenerAlumnoPorMatricula(matricula);
  } catch (Exception e) {
    e.printStackTrace();
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Menú Alumno - Teams UV</title>
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
  <!-- BARRA LATERAL -->
  <div class="lateral">
    <h1>Teams UV</h1>
    <a href="MenuAlumno.jsp">Inicio</a>
    <a href="#">Perfil</a>
    <a href="CerrarSesionServlet">Cerrar sesión</a>
  </div>

  <!-- CONTENIDO MAIN -->
  <div class="main-content">
    <div class="header">
      <% String matri = (String) request.getSession().getAttribute("usuario"); %>
      <h1>Notificaciones de <%= request.getSession().getAttribute("nombre") %>
      </h1>
    </div>
    <div class="info-section">
      <p><b>Matricula:</b> <%=alu.getMatricula()%>
      </p>
      <p><b>Nombre:</b> <%=alu.getNombre()%> <%=alu.getSegundo_nombre()%>
      </p>
      <p><b>Apellido Paterno:</b> <%=alu.getApellido_paterno()%>
      </p>
      <p><b>Apellido Materno:</b> <%=alu.getApellido_materno()%>
      </p>
      <p><b>Correo electronico:</b> <%=alu.getCorreo()%>
      </p>

    </div>
  </div>
</div>
</body>
</html>
