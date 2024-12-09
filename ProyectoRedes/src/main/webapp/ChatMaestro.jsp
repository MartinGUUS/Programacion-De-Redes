<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="java.util.List" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="Modelo.Grupos" %>
<%@ page import="Modelo.Mensajes" %>
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
    String n_control = (String) request.getSession().getAttribute("usuario");

    // Llamar al servicio RMI para obtener las materias
    List<Grupos> listaMaterias = null;
    try {
        LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
        listaMaterias = loginService.obtenerGruposPorMaestro(n_control);
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
    <link rel="stylesheet" href="CSS/Chat.css">
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

        /* Estilo para las imágenes */
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
        function showModal(imgSrc) {
            const modal = document.getElementById('imageModal');
            const modalImg = document.getElementById('modalImage');
            modal.style.display = 'flex'; // Cambiado a 'flex' para centrar
            modalImg.src = imgSrc;
        }

        function closeModal() {
            const modal = document.getElementById('imageModal');
            modal.style.display = 'none';
        }
    </script>
</head>
<body>
<%
    String materia = request.getParameter("materia");
    if (materia == null || materia.isEmpty()) {
        materia = "Sin nombre";
    }

    String nombre = request.getParameter("nombre");
    if (nombre == null || materia.isEmpty()) {
        nombre = "Sin nombre maestro";
    }

    String idgrupo = request.getParameter("id_grupos");
    if (idgrupo == null || idgrupo.isEmpty()) {
        idgrupo = "0"; // Asignar un valor por defecto para evitar errores
    }

%>

<div class="main">
    <div class="lateral">
        <h1>Teams UV</h1>
        <a href="MenuMaestro.jsp">Inicio</a>

        <a href="ConfiguracionMaestro.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesión</a>
    </div>
    <div class="main-content">
        <div class="header">
            <h1>Chat de <%= materia %>
            </h1>
            <a href="AgregarAlumnos.jsp?materia=<%= materia %>&id_grupos=<%=idgrupo%>&nombre=<%=nombre%>"
               class="agregarAlu">Agregar alumnos</a>

            <a href="VerMiembros.jsp?materia=<%= materia %>&id_grupos=<%=idgrupo%>&nombre=<%=nombre%>"
               class="agregarAlu">Ver alumnos de <%=materia%>
            </a>

        </div>
        <div class="chat-container">
            <div class="chat-container">
                <div class="chat-messages">
                    <%
                        List<Mensajes> mensajes = null;
                        try {
                            LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
                            mensajes = loginService.obtenerMensajesPorGrupo(Integer.parseInt(idgrupo));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        if (mensajes != null) {
                            for (Mensajes mensaje : mensajes) {
                                if (mensaje.getTexto() == null) mensaje.setTexto("Imagen enviada");
                    %>
                    <p><strong><%= nombre %>
                        :</strong> <%= mensaje.getTexto()%>
                    </p>
                    <% if (mensaje.getImagen() != null) { %>
                    <img
                            class="chat-image"
                            src="data:image/png;base64,<%= java.util.Base64.getEncoder().encodeToString(mensaje.getImagen()) %>"
                            alt="Imagen"
                            onclick="showModal(this.src)">
                    <% } %>
                    <% }
                    } else {
                    %>
                    <p>No hay mensajes en este grupo.</p>
                    <% } %>
                </div>
                <form class="chat-input" method="post" enctype="multipart/form-data" action="EnviarMensajeServlet">
                    <textarea name="mensaje" placeholder="Escribe un mensaje..." rows="3"
                              style="font-family: JetBrains Mono"></textarea>
                    <input type="file" name="imagen" accept="image/*" style="font-family: JetBrains Mono">
                    <input type="hidden" name="grupo" value="<%=idgrupo%>">
                    <input type="hidden" name="nom" value="<%=nombre%>">
                    <input type="hidden" name="materia" value="<%=materia%>">
                    <button type="submit" style="font-family: JetBrains Mono">Enviar</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
<div id="imageModal" class="modal" onclick="closeModal()">
    <span class="close" onclick="closeModal()">&times;</span>
    <img class="modal-content" id="modalImage" alt="Imagen ampliada">
</div>

</body>
</html>



