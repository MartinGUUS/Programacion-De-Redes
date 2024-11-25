<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Proyecto Redes</title>
    <!-- Vincular el archivo CSS para el login -->
    <link rel="stylesheet" href="CSS/Index.css">
</head>
<body>
<div class="login-container">
    <div class="login-card">
        <h2>Iniciar sesión</h2>
        <!-- Actualizar el formulario para enviar al servlet -->
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="usuario">Matrícula o número de control</label>
                <input type="text" id="usuario" name="usuario" required>
            </div>
            <div class="form-group">
                <label for="contrasena">Contraseña</label>
                <input type="password" id="contrasena" name="contrasena" required>
            </div>
            <button type="submit" class="login-button">Login</button>
        </form>
        <p class="register-link">¿No tienes cuenta? <a href="Registro.jsp">Regístrate aquí</a></p>
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
