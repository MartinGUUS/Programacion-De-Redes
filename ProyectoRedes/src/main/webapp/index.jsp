<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Proyecto Redes</title>
    <link rel="stylesheet" href="CSS/Index.css">
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
        function limpiarCampos(form) {
            setTimeout(() => {
                form.reset();
            }, 50);
        }
    </script>
</head>
<body>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<div class="login-container">
    <div class="login-card">
        <h2>Iniciar sesion</h2>
        <form action="LoginServlet" method="post" onsubmit="limpiarCampos(this);">
            <div class="form-group">
                <label for="usuario">Matricula o numero de control</label>
                <input type="text" id="usuario" name="usuario" required>
            </div>
            <div class="form-group">
                <label for="contrasena">Clave</label>
                <input type="password" id="contrasena" name="contrasena" required>
            </div>
            <button type="submit" class="login-button" style="font-family: JetBrains Mono">Iniciar sesion</button>
        </form>
        <p class="register-link">No tienes cuenta? <a href="Registro.jsp">Registrate aqui</a></p>
        <%
            String mensaje = (String) request.getAttribute("mensaje");
            if (mensaje != null) {
        %>
        <p style="color: red;"><%= mensaje %>
        </p>
        <%
            }
        %>
    </div>
</div>
</body>
</html>
