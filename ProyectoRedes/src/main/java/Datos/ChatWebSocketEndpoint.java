package Datos;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/wsChat")
public class ChatWebSocketEndpoint {
    // Mapa: idGrupo -> lista de sesiones
    private static Map<Integer, List<Session>> grupoSesiones = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("WebSocket abierto: " + session.getId());

        String query = session.getQueryString(); // Ej: "idGrupo=1"
        int idGrupo = parsearIdGrupo(query);

        grupoSesiones.computeIfAbsent(idGrupo, k -> new ArrayList<>()).add(session);
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        // Opcional: si el alumno no envía mensajes, este método puede quedar vacío
    }

    @OnClose
    public void onClose(Session session) {
        // Remover la sesión de la lista correspondiente
        // Se necesita conocer el idGrupo de la sesión; tal vez almacenarlo en la sesión
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        // Manejo de errores
    }

    public static void enviarMensajeAGrupo(int idGrupo, String mensaje) {
        List<Session> sesiones = grupoSesiones.get(idGrupo);
        if (sesiones != null) {
            for (Session s : sesiones) {
                if (s.isOpen()) {
                    s.getAsyncRemote().sendText(mensaje);
                }
            }
        }
    }

    private int parsearIdGrupo(String query) {
        // Implementar lógica para extraer idGrupo del query string
        // Por ejemplo: "idGrupo=1" => return 1
        if (query != null && query.startsWith("idGrupo=")) {
            return Integer.parseInt(query.substring("idGrupo=".length()));
        }
        return -1;
    }
}

