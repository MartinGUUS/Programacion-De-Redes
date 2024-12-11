package Datos;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.util.ArrayList;
import java.util.concurrent.CopyOnWriteArrayList;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/wsChat")
public class webSocketsCHAT {
    // Mapa: idGrupo -> lista de sesiones
    private static Map<Integer, List<Session>> grupoSesiones = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("WebSocket abierto: " + session.getId());

        String query = session.getQueryString(); // Ej: "idGrupo=1"
        int idGrupo = parsearIdGrupo(query);

        if (idGrupo != -1) {
            grupoSesiones.computeIfAbsent(idGrupo, k -> new CopyOnWriteArrayList<>()).add(session);
        } else {
            System.out.println("idGrupo inválido: " + query);
        }
    }


    @OnMessage
    public void onMessage(String message, Session session) {
        // Opcional: Si los alumnos no envían mensajes, este método puede quedar vacío
    }

    @OnClose
    public void onClose(Session session) {
        // Remover la sesión de la lista correspondiente
        String query = session.getQueryString();
        int idGrupo = parsearIdGrupo(query);
        if (idGrupo != -1) {
            List<Session> sesiones = grupoSesiones.get(idGrupo);
            if (sesiones != null) {
                sesiones.remove(session);
                if (sesiones.isEmpty()) {
                    grupoSesiones.remove(idGrupo);
                }
            }
        }
        System.out.println("WebSocket cerrado: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.out.println("Error en WebSocket: " + session.getId() + " - " + throwable.getMessage());
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
            try {
                return Integer.parseInt(query.substring("idGrupo=".length()));
            } catch (NumberFormatException e) {
                System.out.println("Número de grupo inválido en query string: " + query);
            }
        }
        return -1;
    }
}
