-- Active: 1732285790385@@127.0.0.1@3306@proyecto_redes
-- Eliminar la base de datos si ya existe
DROP DATABASE IF EXISTS proyecto_redes;

-- Crear la base de datos
CREATE DATABASE proyecto_redes;

-- Usar la base de datos
USE proyecto_redes;

-- Crear la tabla alumnos
CREATE TABLE alumnos (
    matricula VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    segundo_nombre VARCHAR(50),
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    contrasena VARCHAR(50) NOT NULL
);

-- Crear la tabla maestros
CREATE TABLE maestros (
    n_control VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    segundo_nombre VARCHAR(50),
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    contrasena VARCHAR(50) NOT NULL
);

-- Crear la tabla grupos
CREATE TABLE grupos (
    id_grupos INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fk_maestros VARCHAR(20) NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (fk_maestros) REFERENCES maestros (n_control) ON DELETE CASCADE
);

-- Crear la tabla grupos_alumnos (relación entre alumnos, maestros y grupos)
CREATE TABLE grupos_alumnos (
    fk_grupos INT NOT NULL,
    fk_alumnos VARCHAR(20) NOT NULL,
    fk_maestros VARCHAR(20) NOT NULL,
    FOREIGN KEY (fk_grupos) REFERENCES grupos (id_grupos) ON DELETE CASCADE,
    FOREIGN KEY (fk_alumnos) REFERENCES alumnos (matricula) ON DELETE CASCADE,
    FOREIGN KEY (fk_maestros) REFERENCES maestros (n_control) ON DELETE CASCADE
);

-- Crear la tabla mensajes
CREATE TABLE mensajes (
    id_mensajes INT AUTO_INCREMENT PRIMARY KEY,
    fk_maestros VARCHAR(20) NOT NULL,
    fk_grupos INT NOT NULL,
    texto TEXT,
    imagen LONGBLOB,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fk_maestros) REFERENCES maestros (n_control) ON DELETE CASCADE,
    FOREIGN KEY (fk_grupos) REFERENCES grupos (id_grupos) ON DELETE CASCADE
);


INSERT INTO maestros (n_control, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo, contrasena)
VALUES ('123', 'Carlos', 'Eduardo', 'Gómez', 'López', 'carlos.gomez@example.com', '123');
INSERT INTO maestros (n_control, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo, contrasena)
VALUES ('asd', 'Miguel', 'Angel', 'Gómez', 'López', 'carlos.gomez@example.com', '123');

INSERT INTO alumnos (matricula, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo, contrasena)
VALUES ('zs2202', 'María', 'Isabel', 'Pérez', 'Hernández', 'maria.perez@example.com', '123');
INSERT INTO alumnos (matricula, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo, contrasena)
VALUES ('zs2203', 'Gustavo', 'Isabel', 'Pérez', 'Hernández', 'maria.perez@example.com', '123');
INSERT INTO alumnos (matricula, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo, contrasena)
VALUES ('zs2204', 'Martin', 'Isabel', 'Pérez', 'Hernández', 'maria.perez@example.com', '123');
INSERT INTO alumnos (matricula, nombre, segundo_nombre, apellido_paterno, apellido_materno, correo, contrasena)
VALUES ('zs2205', 'Ricardo', 'Isabel', 'Pérez', 'Hernández', 'maria.perez@example.com', '123');

