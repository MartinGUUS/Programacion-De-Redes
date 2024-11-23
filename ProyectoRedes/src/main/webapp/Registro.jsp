<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Proyecto Redes</title>
    <link rel="stylesheet" href="CSS/Registrar.css">
</head>
<body>
<div class="register-container">
    <div class="register-card">
        <h2>Registrate</h2>
        <form action="registerServlet" method="post">
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
            <button type="submit" class="register-button">Registrar</button>
        </form>
        <p class="login-link">Ya tienes una cuenta? <a href="index.jsp">Inicia sesion aqui</a></p>
    </div>
</div>
</body>
</html>
