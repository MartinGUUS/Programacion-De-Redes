<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proyecto Programación de Redes</title>
    <link rel="stylesheet" href="CSS/Menu.css">
    <script>
        function toggleSubmenu(id) {
            const submenu = document.getElementById(id);
            if (submenu.style.display === "block") {
                submenu.style.display = "none";
            } else {
                submenu.style.display = "block";
            }
        }
    </script>
</head>
<body>
<div class="main">
    <!-- BARRA LATERAL -->
    <div class="lateral">
        <h1>Teams UV</h1>
        <a href="#">Inicio</a>
        <div>
            <div class="menu-item" onclick="toggleSubmenu('formsSubmenu')">Chats de trabajo</div>
            <div id="formsSubmenu" class="submenuPrincipal">
                <a href="#">-- Unirse a un chat --</a>
                <a href="#">Materia 1</a>

            </div>

        </div>



        <a href="#">Configuraciones</a>
        <a href="index.jsp">Cerrar sesion</a>

    </div>

    <!-- CONTENIDO MAIN -->
    <div class="main-content">
        <div class="header">
            <h1>Bienvenido Usuario</h1>

            <a href="#" class="btn-notificaciones">Notificaciones</a>

        </div>

        <!-- Información adicional sobre la aplicación -->
        <div class="info-section">
            <h2>¿Qué es Teams UV?</h2>
            <p>
                Teams UV es una plataforma diseñada para facilitar la comunicación y colaboración entre los estudiantes
                y profesores
                en un entorno académico. Los estudiantes pueden unirse a chats de materias específicas para mantenerse
                actualizados
                sobre tareas, materiales y anuncios importantes.
            </p>

            <h2>Características principales</h2>
            <ul>
                <li><strong>Unirse a chats:</strong> Los estudiantes pueden unirse a los chats de las materias en las
                    que están inscritos.
                </li>
                <li><strong>Solo lectura:</strong> Los estudiantes no pueden enviar mensajes, pero pueden ver las
                    discusiones y anuncios realizados por los profesores.
                </li>
                <li><strong>Gestión de materias:</strong> Cada materia tiene un canal exclusivo para discusiones
                    relevantes.
                </li>
                <li><strong>Interfaz simple:</strong> Navegación intuitiva para acceder a configuraciones y cerrar
                    sesión fácilmente.
                </li>
            </ul>

            <h2>¿Cómo funciona?</h2>
            <p>
                El profesor puede gestionar los chats y publicar información relevante para los estudiantes. Los
                estudiantes pueden
                unirse al canal correspondiente y acceder a toda la información publicada, pero sin la capacidad de
                interactuar.
            </p>
            <p>
                Para unirse a un chat, selecciona la materia desde la barra lateral y haz clic en el botón "<strong>Unirse
                a un chat</strong>".
            </p>

            <h2>Materias disponibles</h2>
            <ul>
                <li>Programación de Redes</li>
                <li>Graficación por Computadora</li>
                <li>Estructura de Datos</li>
            </ul>
        </div>

    </div>
</div>
</body>
</html>
