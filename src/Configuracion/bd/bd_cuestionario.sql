CREATE DATABASE cuestionario;

USE cuestionario;

CREATE TABLE cuestionarios (
    id_cuestionarios INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    tiempo_limite INT,
    estado INT NOT NULL DEFAULT 1,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    id_usuario_creacion VARCHAR(50) NOT NULL,
    id_usuario_modificacion VARCHAR(50) NOT NULL
);

CREATE TABLE preguntas (
    id_preguntas INT AUTO_INCREMENT PRIMARY KEY,
    id_cuestionarios INT,
    contenido TEXT NOT NULL,
    estado INT NOT NULL DEFAULT 1,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    id_usuario_creacion VARCHAR(50) NOT NULL,
    id_usuario_modificacion VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_cuestionarios) REFERENCES cuestionarios(id_cuestionarios)
);

CREATE TABLE opciones (
    id_opciones INT AUTO_INCREMENT PRIMARY KEY,
    id_preguntas INT,
    contenido TEXT NOT NULL,
    es_correcta BOOLEAN,
    estado INT NOT NULL DEFAULT 1,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    id_usuario_creacion VARCHAR(50) NOT NULL,
    id_usuario_modificacion VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_preguntas) REFERENCES preguntas(id_preguntas)
);


CREATE TABLE usuario (
    id_usuario VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo_electronico VARCHAR(255) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    estado INT NOT NULL DEFAULT 1,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    id_usuario_creacion VARCHAR(50) NOT NULL,
    id_usuario_modificacion VARCHAR(50) NOT NULL
);

CREATE TABLE historial_cuestionarios (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario VARCHAR(50),
    id_cuestionarios INT,
    puntaje INT NOT NULL,
    estado INT NOT NULL DEFAULT 1,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    id_usuario_creacion VARCHAR(50) NOT NULL,
    id_usuario_modificacion VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_cuestionarios) REFERENCES cuestionarios(id_cuestionarios)
);







-- Insertamos un cuestionario sobre tecnología
INSERT INTO cuestionarios (titulo, descripcion, id_usuario_creacion, id_usuario_modificacion) 
VALUES ('Cuestionario sobre Tecnología', 'Test sobre conocimientos actuales en tecnología.', 'ID_USUARIO', 'ID_USUARIO');


ALTER TABLE opciones
ADD tipo_pregunta ENUM('opcion_multiple', 'eleccion_unica') NOT NULL DEFAULT 'opcion_multiple';

INSERT INTO preguntas (id_cuestionarios, contenido, id_usuario_creacion, id_usuario_modificacion) 
VALUES (
(
select id_cuestionarios from cuestionarios where id_cuestionarios  = 1
), '¿Cuál es el lenguaje de programación más popular en 2023?', 1, 1);



INSERT INTO opciones (id_preguntas, contenido, es_correcta, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'Python', 1, 'eleccion_unica', 1, 1),
       (LAST_INSERT_ID(), 'Java', 0, 'eleccion_unica', 1, 1),
       (LAST_INSERT_ID(), 'C#', 0, 'eleccion_unica', 1, 1);
       
       
INSERT INTO preguntas (id_cuestionarios, contenido, id_usuario_creacion, id_usuario_modificacion) 
VALUES (1, '¿Qué empresa produce el chip M1?', 1, 1);



INSERT INTO opciones (id_preguntas, contenido, es_correcta, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'Apple', 1, 'eleccion_unica', 1, 1),
       (LAST_INSERT_ID(), 'Intel', 0, 'eleccion_unica', 1, 1),
       (LAST_INSERT_ID(), 'AMD', 0, 'eleccion_unica', 1, 1);


INSERT INTO preguntas (id_cuestionarios, contenido, id_usuario_creacion, id_usuario_modificacion) 
VALUES (1, '¿Cuál es el sistema operativo de los dispositivos iPhone?', 1, 1);


INSERT INTO opciones (id_preguntas, contenido, es_correcta, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'iOS', 1, 'eleccion_unica', 1, 1),
       (LAST_INSERT_ID(), 'Android', 0, 'eleccion_unica', 1, 1),
       (LAST_INSERT_ID(), 'Windows', 0, 'eleccion_unica', 1, 1);


INSERT INTO preguntas (id_cuestionarios, contenido, id_usuario_creacion, id_usuario_modificacion) 
VALUES (1, '¿Cuáles de los siguientes son lenguajes de programación?', 1, 1);

INSERT INTO opciones (id_preguntas, contenido, es_correcta, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'Python', 1, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'HTML', 0, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'Java', 1, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'CSS', 0, 'opcion_multiple', 1, 1);
       
       
INSERT INTO preguntas (id_cuestionarios, contenido, id_usuario_creacion, id_usuario_modificacion) 
VALUES (1, '¿Qué compañía desarrolló el sistema operativo Android?', 1, 1);

INSERT INTO opciones (id_preguntas, contenido, es_correcta, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'Apple', 0, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'Microsoft', 0, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'Google', 1, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'Samsung', 0, 'opcion_multiple', 1, 1);


INSERT INTO preguntas (id_cuestionarios, contenido, id_usuario_creacion, id_usuario_modificacion) 
VALUES (1, '¿Cuál de los siguientes no es un sistema de gestión de bases de datos?', 1, 1);



INSERT INTO opciones (id_preguntas, contenido, es_correcta, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'MySQL', 0, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'PostgreSQL', 0, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'MongoDB', 0, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'Photoshop', 1, 'opcion_multiple', 1, 1);



INSERT INTO preguntas (id_cuestionarios, contenido, id_usuario_creacion, id_usuario_modificacion) 
VALUES (1, '¿Qué lenguaje se utiliza principalmente para estilizar páginas web?', 1, 1);



INSERT INTO opciones (id_preguntas, contenido, es_correcta, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'HTML', 0, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'CSS', 1, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'Java', 0, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'Python', 0, 'opcion_multiple', 1, 1);
       
       
INSERT INTO opciones (id_preguntas, contenido, es_correcta, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'HTTP', 0, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'FTP', 0, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'SMTP', 1, 'opcion_multiple', 1, 1),
       (LAST_INSERT_ID(), 'TCP', 0, 'opcion_multiple', 1, 1);
       
       
-- select * from preguntas
ALTER TABLE usuario RENAME COLUMN correo_electronico TO usuario;
ALTER TABLE usuario RENAME COLUMN contraseña TO contrasenia;


ALTER TABLE historial_cuestionarios DROP FOREIGN KEY historial_cuestionarios_ibfk_1;

ALTER TABLE usuario MODIFY id_usuario INT AUTO_INCREMENT;

ALTER TABLE historial_cuestionarios MODIFY id_usuario INT;


ALTER TABLE historial_cuestionarios ADD CONSTRAINT historial_cuestionarios_ibfk_1 FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario);




INSERT INTO usuario (nombre,usuario, contrasenia, estado, fecha_creacion, fecha_modificacion, id_usuario_creacion, id_usuario_modificacion) 
VALUES 
('Oscar astudillo', 'usuario1', MD5('123'), 1, NOW(), NOW(), 1, 1),
('Pepe gonzalez','usuario2', MD5('123'), 1, NOW(), NOW(), 1, 1),
('Andres tovar','usuario3', MD5('123'), 1, NOW(), NOW(), 1, 1);
       
       



