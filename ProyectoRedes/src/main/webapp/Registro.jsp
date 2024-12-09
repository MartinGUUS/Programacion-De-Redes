<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String mensaje = (String) request.getParameter("error");
    if (mensaje == null || mensaje.isBlank() || mensaje.isEmpty()) {

    }

%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Proyecto Redes</title>
    <link rel="stylesheet" href="CSS/Registrar.css">
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

    <script>
        // Limpia los campos del formulario después de enviarlo
        function limpiarCampos(form) {
            setTimeout(() => {
                form.reset();
            }, 50); // Limpia después de un breve retardo para garantizar que los datos se envían primero
        }
    </script>
</head>
<body>
<div class="register-container">
    <div class="register-card">
        <h2>Registrate</h2>
        <form action="registerServlet" method="post" onsubmit="limpiarCampos(this);">
            <div class="form-group">
                <label for="matricula">Matricula o numero de control</label>
                <input type="text" id="matricula" name="matricula" required>
            </div>
            <div class="form-group">
                <label for="nombre">Nombre</label>
                <input type="text" id="nombre" name="nombre" required>
            </div>
            <div class="form-group">
                <label for="segundoNombre">Segundo nombre</label>
                <input type="text" id="segundoNombre" name="segundoNombre">
            </div>
            <div class="form-group">
                <label for="apellidoPaterno">Apellido paterno</label>
                <input type="text" id="apellidoPaterno" name="apellidoPaterno" required>
            </div>
            <div class="form-group">
                <label for="apellidoMaterno">Apellido materno</label>
                <input type="text" id="apellidoMaterno" name="apellidoMaterno">
            </div>
            <div class="form-group">
                <label for="email">Correo institucional</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Contrasena</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <label for="confirm_password">Confirmar contrasena</label>
                <input type="password" id="confirm_password" name="confirm_password" required>
            </div>
            <button type="submit" class="register-button" style="font-family: JetBrains Mono">Registrar</button>
        </form>
        <% if (mensaje != null) { %>
        <p style="color: red;"><%= mensaje %>
        </p>
        <% }%>
        <p class="login-link">Ya tienes una cuenta? <a href="index.jsp">Inicia sesion aqui</a></p>
    </div>
</div>
</body>
</html>
