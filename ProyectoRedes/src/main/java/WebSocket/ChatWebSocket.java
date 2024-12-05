package WebSocket;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@ServerEndpoint("/chatWebSocket")
public class ChatWebSocket {

    private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());

    @OnOpen
    public void onOpen(Session session) {
        sessions.add(session);
        System.out.println("Nueva conexión WebSocket: " + session.getId());
    }

    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
        System.out.println("Conexión WebSocket cerrada: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session senderSession) {
        System.out.println("Mensaje recibido: " + message);
        // Transmite el mensaje a otros clientes conectados
        retransmitirMensaje(message, senderSession);
    }

    private void retransmitirMensaje(String message, Session senderSession) {
        synchronized (sessions) {
            for (Session session : sessions) {
                if (!session.equals(senderSession)) {
                    try {
                        session.getBasicRemote().sendText(message);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    public static void notificarClientes(String message) {
        synchronized (sessions) {
            Set<Session> sesionesCerradas = new HashSet<>();
            for (Session session : sessions) {
                if (session.isOpen()) {
                    try {
                        session.getBasicRemote().sendText(message);
                    } catch (IOException e) {
                        System.out.println("Error al enviar mensaje a la sesión: " + session.getId());
                        e.printStackTrace();
                    }
                } else {
                    // Agrega la sesión cerrada a una lista para removerla
                    sesionesCerradas.add(session);
                }
            }
            // Remueve las sesiones cerradas del conjunto activo
            sessions.removeAll(sesionesCerradas);
            if (!sesionesCerradas.isEmpty()) {
                System.out.println("Se eliminaron " + sesionesCerradas.size() + " sesiones cerradas.");
            }
        }
    }

}
