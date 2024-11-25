<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menú Maestro - Teams UV</title>
    <link rel="stylesheet" href="CSS/Menu.css">
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
        <a href="MenuMaestro.jsp">Inicio</a>
        <div>
            <div class="menu-item" onclick="toggleSubmenu('formsSubmenu')">Gestión de Grupos</div>
            <div id="formsSubmenu" class="submenuPrincipal">
                <a href="#">-- Crear Grupo --</a>
                <a href="ChatMaestro.jsp?materia=Materia1">Materia 1</a>
                <a href="ChatMaestro.jsp?materia=Materia2">Materia 2</a>
            </div>
        </div>
        <a href="#">Configuraciones</a>
        <a href="index.jsp">Cerrar sesión</a>
    </div>

    <!-- CONTENIDO MAIN -->
    <div class="main-content">
        <div class="header">
            <h1>Bienvenido, Maestro</h1>
            <a href="#" class="btn-notificaciones">Notificaciones</a>
        </div>
        <div class="info-section">
            <h2>Gestión de Grupos</h2>
            <p>Aquí puedes crear grupos para tus materias, gestionar alumnos y revisar la actividad en los chats.</p>
            <ul>
                <li>Materia 1</li>
                <li>Materia 2</li>
                <li>Materia 3</li>
            </ul>

            <h2>Información</h2>
            <p>Este es tu espacio para mantenerte conectado con tus alumnos y gestionar materiales de estudio.</p>
        </div>
    </div>
</div>
</body>
</html>
