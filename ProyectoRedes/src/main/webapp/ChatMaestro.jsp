<%@ page import="Modelo.Grupos_Alumnos" %>
<%@ page import="java.util.List" %>
<%@ page import="Servicios.LoginService" %>
<%@ page import="java.rmi.Naming" %>
<%@ page import="Modelo.Grupos" %>
<%@ page import="Modelo.Mensajes" %>
<%@ page import="Modelo.Maestros" %>
<%
    // Configurar las cabeceras de la respuesta para evitar caché
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (request.getSession(false) == null || request.getSession().getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String n_control = (String) request.getSession().getAttribute("usuario");

    String materia = request.getParameter("materia");
    if (materia == null || materia.isEmpty()) {
        materia = "Sin nombre";
    }

    String nombre = request.getParameter("nombre");
    if (nombre == null || nombre.isEmpty()) {
        nombre = "Sin nombre maestro";
    }

    String idgrupo = request.getParameter("id_grupos");
    if (idgrupo == null || idgrupo.isEmpty()) {
        idgrupo = "0";
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
            margin: 0;
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

        .chat-image {
            max-width: 100px;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .chat-image:hover {
            transform: scale(1.2);
        }

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

        .chat-messages {
            min-height: 150px;
            max-height: 500px;
            overflow-y: auto;
        }

        .chat-container {
            min-height: 150px;
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

<div class="main">
    <div class="lateral">
        <h1>Teams UV</h1>
        <a href="MenuMaestro.jsp">Inicio</a>
        <a href="ConfiguracionMaestro.jsp">Perfil</a>
        <a href="CerrarSesionServlet">Cerrar sesion</a>
    </div>
    <div class="main-content">
        <div class="header">
            <h1>Chat de <%= materia %>
            </h1>
            <a href="AgregarAlumnos.jsp?materia=<%= materia %>&id_grupos=<%=idgrupo%>&nombre=<%=nombre%>"
               class="agregarAlu">Agregar alumnos</a>

            <a href="VerMiembros.jsp?materia=<%= materia %>&id_grupos=<%=idgrupo%>&nombre=<%=nombre%>"
               class="agregarAlu">Ver alumnos
            </a>
        </div>
        <div class="chat-container-principal">
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

                        if (mensajes != null && !mensajes.isEmpty()) {
                            for (Mensajes mensaje : mensajes) {
                                String texto = mensaje.getTexto();
                                if (texto == null || texto.trim().isEmpty()) {
                                    texto = "Imagen enviada";
                                }
                                // Obtener el maestro para el mensaje
                                String nombreMaestroActual = "Maestro Desconocido";
                                try {
                                    LoginService loginService = (LoginService) Naming.lookup("rmi://localhost:1099/ServicioLogin");
                                    Maestros maestroActual = loginService.obtenerMaestroPorNControl(mensaje.getFk_maestros());
                                    if (maestroActual != null) {
                                        nombreMaestroActual = maestroActual.getNombre();
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                    %>
                    <p><strong><%= nombreMaestroActual %>:</strong> <%= texto %>
                    </p>
                    <% if (mensaje.getImagen_url() != null && !mensaje.getImagen_url().isEmpty()) { %>
                    <img
                            class="chat-image"
                            src="<%= mensaje.getImagen_url() %>"
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

                <form class="chat-input" method="post" enctype="multipart/form-data" action="EnviarMensajeServlet">
                    <div class="input-row">
                        <button type="submit" style="font-family: 'JetBrains Mono', sans-serif" class="agregarAlu">
                            Enviar
                        </button>
                        <label for="file-input" class="agregarAlu">Adjuntar</label>
                        <input id="file-input" type="file" name="imagen" accept="image/*" hidden>
                        <textarea name="mensaje" placeholder="Escribe un mensaje..." rows="3"></textarea>
                    </div>
                    <input type="hidden" name="grupo" value="<%= idgrupo %>">
                    <input type="hidden" name="nom" value="<%= nombre %>">
                    <input type="hidden" name="materia" value="<%= materia %>">
                </form>

            </div>
        </div>
    </div>
</div>

<div id="imageModal" class="modal" onclick="closeModal()">
    <span class="close" onclick="closeModal()">&times;</span>
    <img class="modal-content" id="modalImage" alt="Imagen ampliada">
</div>

</body>


</html>