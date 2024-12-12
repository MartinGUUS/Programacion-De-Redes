package Datos;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class TCPsockets {
    /*private static List<GestorCliente> clientesConectados = new ArrayList<>();

    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(9999);
        System.out.println("Servidor de chat listo en el puerto 9999...");
        while (true) {
            Socket socket = serverSocket.accept();
            GestorCliente ch = new GestorCliente(socket);
            synchronized (clientesConectados) {
                clientesConectados.add(ch);
            }
            ch.start();
        }
    }

    public static void broadcastMessage(String mensaje, int idGrupo) {
        synchronized (clientesConectados) {
            for (ClientHandler ch : clientesConectados) {
                if (ch.getIdGrupo() == idGrupo) {
                    ch.enviar(mensaje);
                }
            }
        }
    }*/
}

class GestorCliente extends Thread {
    private Socket socket;
    private PrintWriter out;
    private BufferedReader in;
    private int idGrupo;

    public GestorCliente(Socket socket) throws IOException {
        this.socket = socket;
        this.out = new PrintWriter(socket.getOutputStream(), true);
        this.in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
    }

    public int getIdGrupo() {
        return idGrupo;
    }

    public void enviar(String msg) {
        out.println(msg);
    }

    @Override
    public void run() {
        try {
            String line = in.readLine();
            if (line != null) {
                this.idGrupo = Integer.parseInt(line);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
