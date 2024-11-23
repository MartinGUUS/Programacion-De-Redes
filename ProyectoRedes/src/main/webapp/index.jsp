<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Proyecto Redes</title>
    <!-- Vincular el archivo CSS para el login -->
    <link rel="stylesheet" href="CSS/Index.css">
    <script>
        // Redirigir al hacer clic en el botón "Login"
        function redirectToMenu() {
            window.location.href = "Menu.jsp";
        }
    </script>
</head>
<body>
<div class="login-container">
    <div class="login-card">
        <h2>Iniciar sesion</h2>
        <form onsubmit="redirectToMenu(); return false;">
            <div class="form-group">
                <label for="email">Matricula o numero de control</label>
                <input type="email" id="email" name="email" >
            </div>
            <div class="form-group">
                <label for="password">Contrasena</label>
                <input type="password" id="password" name="password" >
            </div>
            <button type="submit" class="login-button">Login</button>
        </form>
        <p class="register-link">No tienes cuenta? <a href="Registro.jsp">Registrate aqui</a></p>
    </div>
</div>
</body>
</html>
