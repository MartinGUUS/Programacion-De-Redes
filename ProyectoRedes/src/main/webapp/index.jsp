<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Proyecto Redes</title>
    <link rel="stylesheet" href="CSS/Index.css">
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
<%
    // Configurar cabeceras para evitar caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<div class="login-container">
    <div class="login-card">
        <h2>Iniciar sesion</h2>
        <!-- Actualizar el formulario para enviar al servlet -->
        <form action="LoginServlet" method="post" onsubmit="limpiarCampos(this);">
            <div class="form-group">
                <label for="usuario">Matricula o numero de control</label>
                <input type="text" id="usuario" name="usuario" required>
            </div>
            <div class="form-group">
                <label for="contrasena">Contrasena</label>
                <input type="password" id="contrasena" name="contrasena" required>
            </div>
            <button type="submit" class="login-button">Login</button>
        </form>
        <p class="register-link">No tienes cuenta? <a href="Registro.jsp">Registrate aqui</a></p>
        <%-- Mostrar mensaje de error si el servlet establece un atributo "mensaje" --%>
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
