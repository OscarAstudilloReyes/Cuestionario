CREATE DATABASE cuestionario2;

USE cuestionario2;

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



-- select * from preguntas
ALTER TABLE usuario RENAME COLUMN correo_electronico TO usuario;
ALTER TABLE usuario RENAME COLUMN contraseña TO contrasenia;


ALTER TABLE historial_cuestionarios DROP FOREIGN KEY historial_cuestionarios_ibfk_1;

ALTER TABLE usuario MODIFY id_usuario INT AUTO_INCREMENT;

ALTER TABLE historial_cuestionarios MODIFY id_usuario INT;


ALTER TABLE historial_cuestionarios ADD CONSTRAINT historial_cuestionarios_ibfk_1 FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario);

SELECT 
  CONCAT('ALTER TABLE ', table_name, ' MODIFY COLUMN usuario_creacion INT, MODIFY COLUMN usuario_modificacion INT;') 
FROM 
  information_schema.columns 
WHERE 
  column_name IN ('usuario_creacion', 'usuario_modificacion') 
  AND table_schema = 'cuestionario';


-- Insertamos un cuestionario sobre tecnología

ALTER TABLE cuestionarios ADD COLUMN codigo VARCHAR(60);

INSERT INTO cuestionarios (titulo, descripcion, tiempo_limite, id_usuario_creacion, id_usuario_modificacion,codigo) 
VALUES ('Cuestionario sobre Tecnología', 'Test sobre conocimientos actuales en tecnología.', 2, '1', '1','TEC');




ALTER TABLE preguntas ADD COLUMN tipo_pregunta VARCHAR(60);



INSERT INTO preguntas (id_cuestionarios, contenido, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (
(
select id_cuestionarios from cuestionarios where codigo  = 'TEC'
), '¿Cuál es el lenguaje de programación más popular en 2023?', 'UNICA' ,1, 1);




INSERT INTO opciones (id_preguntas, contenido, es_correcta,  id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'Python', 1,  1, 1),
       (LAST_INSERT_ID(), 'Java', 0,  1, 1),
       (LAST_INSERT_ID(), 'C#', 0,  1, 1);
       
       
INSERT INTO preguntas (id_cuestionarios, contenido, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES ((
select id_cuestionarios from cuestionarios where codigo  = 'TEC'
), '¿Qué empresa produce el chip M1?', 'UNICA', 1, 1);



INSERT INTO opciones (id_preguntas, contenido, es_correcta,  id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'Apple', 1,  1, 1),
       (LAST_INSERT_ID(), 'Intel', 0,  1, 1),
       (LAST_INSERT_ID(), 'AMD', 0,  1, 1);


INSERT INTO preguntas (id_cuestionarios, contenido,  tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES ((
select id_cuestionarios from cuestionarios where codigo  = 'TEC'
), '¿Cuál es el sistema operativo de los dispositivos iPhone?', 'UNICA', 1, 1);


INSERT INTO opciones (id_preguntas, contenido, es_correcta,  id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'iOS', 1,  1, 1),
       (LAST_INSERT_ID(), 'Android', 0,  1, 1),
       (LAST_INSERT_ID(), 'Windows', 0,  1, 1);


INSERT INTO preguntas (id_cuestionarios, contenido,tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES ((
select id_cuestionarios from cuestionarios where codigo  = 'TEC'
), '¿Cuáles de los siguientes son lenguajes de programación?','MULTIPLE',1, 1);

INSERT INTO opciones (id_preguntas, contenido, es_correcta,  id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'Python', 1,  1, 1),
       (LAST_INSERT_ID(), 'HTML', 0,  1, 1),
       (LAST_INSERT_ID(), 'Java', 1,  1, 1),
       (LAST_INSERT_ID(), 'CSS', 0,  1, 1);
       
       
INSERT INTO preguntas (id_cuestionarios, contenido, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES ((
select id_cuestionarios from cuestionarios where codigo  = 'TEC'
), '¿Qué compañía desarrolló el sistema operativo Android?', 'MULTIPLE', 1, 1);


INSERT INTO opciones (id_preguntas, contenido, es_correcta,  id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'Apple', 0,  1, 1),
       (LAST_INSERT_ID(), 'Microsoft', 0,  1, 1),
       (LAST_INSERT_ID(), 'Google', 1,1, 1),
       (LAST_INSERT_ID(), 'Samsung', 0,  1, 1);


INSERT INTO preguntas (id_cuestionarios, contenido, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES ((
select id_cuestionarios from cuestionarios where codigo  = 'TEC'
), '¿Cuál de los siguientes no es un sistema de gestión de bases de datos?', 'MULTIPLE', 1, 1);




INSERT INTO opciones (id_preguntas, contenido, es_correcta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'MySQL', 0,  1, 1),
       (LAST_INSERT_ID(), 'PostgreSQL', 0,  1, 1),
       (LAST_INSERT_ID(), 'MongoDB', 0,  1, 1),
       (LAST_INSERT_ID(), 'Photoshop', 1,  1, 1);



INSERT INTO preguntas (id_cuestionarios, contenido, id_usuario_creacion, tipo_pregunta, id_usuario_modificacion) 
VALUES ((
select id_cuestionarios from cuestionarios where codigo  = 'TEC'
), '¿Qué lenguaje se utiliza principalmente para estilizar páginas web?', 'MULTIPLE',1, 1);



INSERT INTO opciones (id_preguntas, contenido, es_correcta,  id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'HTML', 0,  1, 1),
       (LAST_INSERT_ID(), 'CSS', 1,  1, 1),
       (LAST_INSERT_ID(), 'Java', 0,  1, 1),
       (LAST_INSERT_ID(), 'Python', 0,  1, 1);
       
       

INSERT INTO preguntas (id_cuestionarios, contenido, id_usuario_creacion, tipo_pregunta, id_usuario_modificacion) 
VALUES ((
select id_cuestionarios from cuestionarios where codigo  = 'TEC'
), '¿¿Qué protocolo se utiliza principalmente para enviar correos electrónicos?', 'MULTIPLE', 1, 1);


INSERT INTO opciones (id_preguntas, contenido, es_correcta, id_usuario_creacion, id_usuario_modificacion) 
VALUES (LAST_INSERT_ID(), 'HTTP', 0,  1, 1),
       (LAST_INSERT_ID(), 'FTP', 0,  1, 1),
       (LAST_INSERT_ID(), 'SMTP', 1,  1, 1),
       (LAST_INSERT_ID(), 'TCP', 0,  1, 1);
       
       




INSERT INTO usuario (nombre,usuario, contrasenia, estado, fecha_creacion, fecha_modificacion, id_usuario_creacion, id_usuario_modificacion) 
VALUES 
('Oscar astudillo', 'usuario1', MD5('123'), 1, NOW(), NOW(), 1, 1),
('Pepe gonzalez','usuario2', MD5('123'), 1, NOW(), NOW(), 1, 1),
('Andres tovar','usuario3', MD5('123'), 1, NOW(), NOW(), 1, 1);
       
       


INSERT INTO cuestionarios 
(titulo, descripcion, tiempo_limite, estado, fecha_creacion, fecha_modificacion, id_usuario_creacion, id_usuario_modificacion,codigo) 
VALUES 
('Animales', 'Cuestionario sobre conocimientos generales de animales', 2, 1, NOW(), NOW(), '1', '1','ANI');



INSERT INTO preguntas (contenido, tipo_pregunta, id_cuestionarios , id_usuario_creacion, id_usuario_modificacion) 
VALUES ('¿Cuál es el mamífero más grande del mundo?', 'UNICA', (SELECT id_cuestionarios FROM cuestionarios WHERE codigo = 'ANI'),1,1);

SET @last_id_pregunta1 = LAST_INSERT_ID();
INSERT INTO opciones (contenido, es_correcta, id_preguntas,  id_usuario_creacion, id_usuario_modificacion) 
VALUES ('Elefante africano', 0, @last_id_pregunta1,1,1),
 ('Ballena azul', 1, @last_id_pregunta1,1,1),
 ('Jirafa', 0, @last_id_pregunta1,1,1),
 ('Oso polar', 0, @last_id_pregunta1,1,1);
 
 
INSERT INTO preguntas (contenido, tipo_pregunta, id_cuestionarios, id_usuario_creacion, id_usuario_modificacion) 
VALUES ('¿Qué animal es conocido como el "rey de la selva"?', 'UNICA', (SELECT id_cuestionarios FROM cuestionarios WHERE codigo = 'ANI'), 1,1);

SET @last_id_pregunta2 = LAST_INSERT_ID();
INSERT INTO opciones (contenido, es_correcta, id_preguntas,id_usuario_creacion, id_usuario_modificacion) 
VALUES ('Tigre', 0, @last_id_pregunta2,1,1),
 ('Elefante', 0, @last_id_pregunta2,1,1), 
 ('León', 1, @last_id_pregunta2,1,1),
 ('Cheetah', 0, @last_id_pregunta2,1,1);
 
 
 
 INSERT INTO preguntas (contenido, tipo_pregunta, id_cuestionarios,id_usuario_creacion, id_usuario_modificacion) VALUES ('¿Cuáles de los siguientes animales son considerados marsupiales?', 'MULTIPLE', (SELECT id_cuestionarios FROM cuestionarios WHERE codigo = 'ANI'),1,1);

SET @last_id_pregunta3 = LAST_INSERT_ID();
INSERT INTO opciones (contenido, es_correcta, id_preguntas,id_usuario_creacion, id_usuario_modificacion) 
VALUES ('Canguro', 1, @last_id_pregunta3,1,1), 
('Koala', 1, @last_id_pregunta3,1,1),
 ('Oso panda', 0, @last_id_pregunta3,1,1),
 ('Lince', 0, @last_id_pregunta3,1,1);


---update cuestionarios set tiempo_limite = 2;



INSERT INTO cuestionarios 
(titulo, descripcion, tiempo_limite, estado, fecha_creacion, fecha_modificacion, codigo ,id_usuario_creacion, id_usuario_modificacion) 
VALUES 
('Cuestionario sobre Fútbol', 'Test sobre conocimientos generales en fútbol.', 3, 1, NOW(), NOW(), 'FUT',1,1);





INSERT INTO preguntas (id_cuestionarios, contenido, tipo_pregunta,id_usuario_creacion, id_usuario_modificacion) 
VALUES ((select id_cuestionarios from cuestionarios where codigo = 'FUT'), '¿Cuál es el país que ha ganado más Copas del Mundo en fútbol masculino?', 'UNICA',1,1);


SET @last_id_pregunta1 = LAST_INSERT_ID();
INSERT INTO opciones (contenido, es_correcta, id_preguntas, id_usuario_creacion, id_usuario_modificacion) 
VALUES ('Brasil', 1, @last_id_pregunta1, 1, 1),
       ('Colombia', 0, @last_id_pregunta1, 1, 1),
       ('Argentina', 0, @last_id_pregunta1, 1, 1),
       ('Francia', 0, @last_id_pregunta1, 1, 1);
       
       
 INSERT INTO preguntas (id_cuestionarios, contenido, tipo_pregunta,id_usuario_creacion, id_usuario_modificacion) 
VALUES ((select id_cuestionarios from cuestionarios where codigo = 'FUT'), '¿Cuáles de los siguientes equipos han ganado la Champions League?', 'MULTIPLE',1,1);
      

SET @last_id_pregunta2 = LAST_INSERT_ID();
INSERT INTO opciones (contenido, es_correcta, id_preguntas, id_usuario_creacion, id_usuario_modificacion) 
VALUES ('Manchester United', 1, @last_id_pregunta2, 1, 1),
       ('Bayern Munich', 1, @last_id_pregunta2, 1, 1),
       ('Arsenal', 0, @last_id_pregunta2, 1, 1),
       ('Paris Saint-Germain', 0, @last_id_pregunta2, 1, 1);
       

INSERT INTO preguntas (id_cuestionarios, contenido, tipo_pregunta,id_usuario_creacion, id_usuario_modificacion) 
VALUES ((select id_cuestionarios from cuestionarios where codigo = 'FUT'), '¿Cuáles de los siguientes jugadores han ganado el Balón de Oro?', 'MULTIPLE',1, 1);

SET @last_id_pregunta3 = LAST_INSERT_ID();
INSERT INTO opciones (contenido, es_correcta, id_preguntas, id_usuario_creacion, id_usuario_modificacion) 
VALUES ('Lionel Messi', 1, @last_id_pregunta3, 1, 1),
       ('Neymar Jr.', 0, @last_id_pregunta3, 1, 1),
       ('Cristiano Ronaldo ', 1, @last_id_pregunta3, 1, 1),
       ('Kylian Mbappé', 0, @last_id_pregunta3, 1, 1);
       
       
  INSERT INTO preguntas (id_cuestionarios, contenido, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES ((select id_cuestionarios from cuestionarios where codigo = 'FUT'), '¿En qué país se celebró el Mundial de Fútbol 2018?', 'UNICA',1,1);     
       
SET @last_id_pregunta4 = LAST_INSERT_ID();
INSERT INTO opciones (contenido, es_correcta, id_preguntas, id_usuario_creacion, id_usuario_modificacion) 
VALUES ('Rusia', 1, @last_id_pregunta4, 1, 1),
       ('Brasil', 0, @last_id_pregunta4, 1, 1),
       ('Alemania', 0, @last_id_pregunta4, 1, 1),
       ('Qatar', 0, @last_id_pregunta4, 1, 1);
       
       
       
INSERT INTO preguntas (id_cuestionarios, contenido, tipo_pregunta, id_usuario_creacion, id_usuario_modificacion) 
VALUES ((select id_cuestionarios from cuestionarios where codigo = 'FUT'), '¿Cuáles de los siguientes estadios son icónicos en el mundo del fútbol?', 'MULTIPLE',1,1);



SET @last_id_pregunta5 = LAST_INSERT_ID();
INSERT INTO opciones (contenido, es_correcta, id_preguntas, id_usuario_creacion, id_usuario_modificacion) 
VALUES ('Camp Nou', 1, @last_id_pregunta5, 1, 1),
       ('Old Trafford', 1, @last_id_pregunta5, 1, 1),
       ('Santiago Bernabéu', 1, @last_id_pregunta5, 1, 1),
       ('Stamford Bridge', 0, @last_id_pregunta5, 1, 1);


