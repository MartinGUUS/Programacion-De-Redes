<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="Modelo.Mensajes" %>
<%@ page import="java.util.List" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="Modelo.Maestros" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Configurar las cabeceras de la respuesta para evitar caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    if (request.getSession(false) == null || request.getSession().getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Obtener la matrícula del usuario desde la sesión
    String matricula = (String) request.getSession().getAttribute("usuario");

    // Obtener los parámetros de la materia y el id_grupos
    String materia = request.getParameter("materia");
    if (materia == null || materia.isEmpty()) {
        materia = "Sin nombre";
    }

    String idgrupo = request.getParameter("id_grupos");
    if (idgrupo == null || idgrupo.isEmpty()) {
        idgrupo = "0"; // Valor por defecto
    }

    // Llamar al servicio RMI para obtener los grupos del alumno (opcional, por si se requiere info adicional)
    List<Grupos_Alumnos> listaMaterias = null;
    List<Mensajes> mensajes = null;
    Maestros maestro = null;


    try {
        LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
        listaMaterias = loginService.obtenerGruposPorAlumno(matricula);

        mensajes = loginService.obtenerMensajesPorGrupo(Integer.parseInt(idgrupo));


    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat de Materias</title>
    <link rel="stylesheet" href="CSS/Menu.css">
    <link rel="stylesheet" href="CSS/Chat.css">

    <style>
        .agregarAlu {
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
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .agregarAlu:hover {
            background-color: #005bb5;
            transform: scale(1.05);
        }

        .agregarAlu:active {
            background-color: #003f8c;
            transform: scale(0.95);
        }

        /* Estilo para las imágenes en el chat */
        .chat-image {
            max-width: 100px;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .chat-image:hover {
            transform: scale(1.2);
        }

        /* Estilo para el modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.8);
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            max-width: 80%;
            max-height: 80%;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
        }

        .close {
            position: absolute;
            top: 20px;
            right: 30px;
            font-size: 30px;
            font-weight: bold;
            color: white;
            cursor: pointer;
        }

        .close:hover {
            color: #ccc;
        }
    </style>

    <script>
        function toggleSubmenu(id) {
            const submenu = document.getElementById(id);
            submenu.style.display = submenu.style.display === "block" ? "none" : "block";
        }

        function showModal(imgSrc) {
            const modal = document.getElementById('imageModal');
            const modalImg = document.getElementById('modalImage');
            modal.style.display = 'flex';
            modalImg.src = imgSrc;
        }

        function closeModal() {
            const modal = document.getElementById('imageModal');
            modal.style.display = 'none';
        }
    </script>
</head>
<body>

<div class="main">
    <div class="lateral">
        <h1>Teams UV</h1>
        <a href="MenuAlumno.jsp">Inicio</a>
        <a href="ConfiguracionesAlumnos.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>
    <div class="main-content">
        <div class="header">
            <h1>Chat de <%= materia %>
            </h1>
        </div>
        <div class="chat-container">
            <div class="chat-messages">
                <%
                    if (mensajes != null && !mensajes.isEmpty()) {
                        for (Mensajes mensaje : mensajes) {
                            String texto = mensaje.getTexto();
                            if (texto == null || texto.trim().isEmpty()) {
                                texto = "Imagen enviada";
                            }
                            LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
                            maestro = loginService.obtenerMaestroPorNControl(mensaje.getFk_maestros());
                %>
                <p><strong><%= maestro.getNombre() %>
                    :</strong> <%= texto %>
                </p>
                <% if (mensaje.getImagen() != null) { %>
                <img
                        class="chat-image"
                        src="data:image/png;base64,<%= java.util.Base64.getEncoder().encodeToString(mensaje.getImagen()) %>"
                        alt="Imagen"
                        onclick="showModal(this.src)">
                <% } %>
                <%
                    }
                } else {
                %>
                <p>No hay mensajes en este grupo.</p>
                <% } %>
            </div>
            <!-- No se muestra el formulario de envío ya que el alumno sólo puede leer -->
            <div class="chat-input">
                <textarea placeholder="Solo lectura: No puedes escribir mensajes." disabled></textarea>
            </div>
        </div>
    </div>
</div>

<!-- Modal para mostrar imagen ampliada -->
<div id="imageModal" class="modal" onclick="closeModal()">
    <span class="close" onclick="closeModal()">&times;</span>
    <img class="modal-content" id="modalImage" alt="Imagen ampliada">
</div>

</body>
</html>
