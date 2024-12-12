package Datos;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/wsChat")
public class webSocketsCHAT {
    private static Map<Integer, List<Session>> grupoSesiones = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("WebSocket abierto: " + session.getId());

        String query = session.getQueryString();
        int idGrupo = parsearIdGrupo(query);

        if (idGrupo != -1) {
            grupoSesiones.computeIfAbsent(idGrupo, k -> new CopyOnWriteArrayList<>()).add(session);
        } else {
            System.out.println("idGrupo invalido: " + query);
        }
    }


    @OnMessage
    public void onMessage(String message, Session session) {

    }

    @OnClose
    public void onClose(Session session) {
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
        if (query != null && query.startsWith("idGrupo=")) {
            try {
                return Integer.parseInt(query.substring("idGrupo=".length()));
            } catch (NumberFormatException e) {
                System.out.println("numero de grupo invalido en query " + query);
            }
        }
        return -1;
    }
}
