-- CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE RedSocial;
USE RedSocial;
-- CREACIÓN DE LAS TABLAS
CREATE TABLE Usuarios(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(10) NOT NULL,
    apellido VARCHAR(10) NOT NULL,
    nombreUsuario VARCHAR(20) NOT NULL,
    correoElectronico VARCHAR(30) NOT NULL
);
CREATE TABLE Amistades(
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    amigo_id INT,
    estado VARCHAR(10) NOT NULL,
    desde DATE NOT NULL,
	PRIMARY KEY (usuario_id, amigo_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (amigo_id) REFERENCES Usuarios(id)
);

CREATE TABLE Publicaciones(
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    fecha DATE NOT NULL,
    contenido VARCHAR(150) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

CREATE TABLE Comentarios(
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    publicacion_id INT,
    fecha DATE,
    contenido VARCHAR(150) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (publicacion_id) REFERENCES Publicaciones(id)
);

CREATE TABLE Mensajes(
    id INT AUTO_INCREMENT PRIMARY KEY,
    emisor_id INT,
    receptor_id INT,
    fecha DATE,
    contenido VARCHAR(250) NOT NULL,
    FOREIGN KEY (emisor_id) REFERENCES Usuarios(id),
    FOREIGN KEY (receptor_id) REFERENCES Usuarios(id)
);

-- INSERCIÓN DE DATOS
-- 5 usuarios
INSERT INTO Usuarios (nombre, apellido, nombreusuario, correoElectronico) 
VALUES 
('Laura', 'Arias', 'lucia.arias', 'lauraslucia@gmail.com'),
('santiago', 'vargas', 'santiago.vargas', 'santiago@gmail.com'),
('Yaritzay', 'Suarez', 'yari.suarez', 'yaritzay@example.com'),
('Carla', 'Sánchez', 'carla.sanchez', 'carla.sanchez@example.com'),
('Luis', 'Rodríguez', 'luis.rodriguez', 'luis.rodriguez@example.com');
select * from Usuarios;

-- 5 relaciones de amistad mínimo con diferentes estados

INSERT INTO Amistades(usuario_id, amigo_id, estado, desde)
VALUES 
(1, 2, 'pendiente', CURDATE()+1),
(1, 3, 'aceptada', CURDATE()-6),
(4, 1, 'pendiente', CURDATE()+8),
(2, 4, 'aceptada', CURDATE()+8),
(3, 4, 'rechazada', CURDATE()-10);

-- 2 mensajes por cada usuario con amigos diferentes
INSERT INTO Mensajes(emisor_id, receptor_id, fecha, contenido) VALUES 
(1, 2, CURDATE()-2, 'Hola, ¿cómo estás?'),
(1, 3, CURDATE()+4, '¿Vas a la fiesta esta noche?'),
(2, 1, CURDATE(), 'Hola estoy bien, gracias por preguntar.'),
(2, 4, CURDATE()+30, '¿Qué fecha es la cita?'),
(3, 1, CURDATE(), '¡Voy a ir!'),
(3, 2, CURDATE()-7, 'hola'),
(4, 2, CURDATE(), 'El martes a las 7:00 p.m. en mi casa.'),
(4, 3, CURDATE()+6, 'hey'),
(5, 1, CURDATE()-18, '¡Hola! Me preguntaba si querías salir el sábado por la noche.'),
(5, 2, CURDATE()+3, 'Sí, el sábado por la noche me encantaría. ¿A qué hora te parece?');



--  publicaciones por cada usuario con fechas distintas
INSERT INTO Publicaciones(usuario_id, fecha, contenido) VALUES 
(1, CURDATE()-2, 'Hoy es un gran día.'),
(2, CURDATE()+4, 'Esta noche vamos a la fiesta.'),
(3, CURDATE()+7, 'comiendo rico en poblado'),
(4, CURDATE()-2, 'Tengo una cita el martes a las 7:00 p.m.'),
(5, CURDATE()+1, 'Me alegra que estemos aquí.');


-- 2 comentarios en cada publicacion

INSERT INTO Comentarios(publicacion_id, usuario_id, fecha, contenido) VALUES 
(1, 2, SYSDATE()+1, 'Estoy de acuerdo, hoy es un gran día.'),
(1, 3, SYSDATE()-1, 'Hay que aprovechar al máximo.'),
(2, 4, SYSDATE()+3, 'De una'),
(2, 5, SYSDATE()+5, 'Por favor, dinos si encuentras algún problema.'),
(3, 2, SYSDATE()+1, 'No lo vamos a pensar.'),
(3, 5, SYSDATE()-6, 'Voy a tenerlo en cuenta.'),
(4, 3, SYSDATE()+30, 'A mi también me gusta este lugar.'),
(4, 1, SYSDATE()-50, 'Qué restaurante es ese?'),
(5, 2, SYSDATE()+1, 'Lo disfrutaremos al máximo.'),
(5, 3, SYSDATE()-20, 'El sábado por la noche me gustaria ir al cine.'); 

-- Usuario (Laura) Comentandose a si mismo:
INSERT INTO Comentarios(publicacion_id, usuario_id, fecha, contenido)
VALUES (4, 4, CURDATE()-2, "comentando mi post");


-- CONSULTAS -------------------------------
-- Mostrar todos los usuarios con sus publicaciones y los detalles de las mismas:
SELECT u.nombre, u.apellido, p.contenido 'Publicacion', p.fecha from Publicaciones p
inner join Usuarios u on u.id = p.usuario_id;

-- Obtener todas las publicaciones de un usuario
-- Consulta 1--

SELECT DISTINCT u.nombre, u.apellido, p.contenido, p.fecha from Publicaciones p
inner join Usuarios u on u.id = p.usuario_id where u.id = 3;


-- Buscar publicaciones con cierta palabra clave 
-- Consulta 2--

SELECT u.nombre, u.apellido, p.contenido, p.fecha FROM usuarios u
INNER JOIN publicaciones p ON u.id = p.usuario_id WHERE p.contenido LIKE '%Hoy%';



-- Mostrar los comentarios de una publicación 
--  Consulta 3--
SELECT DISTINCT u.nombre AS nombre_usuario, u.apellido AS apellido_usuario, p.contenido, c.id AS id_comentario, c.contenido AS contenido_comentario, com.nombre AS nombre_comentador
FROM Usuarios u
INNER JOIN Publicaciones p ON u.id = p.usuario_id
INNER JOIN comentarios c ON p.id = c.publicacion_id
INNER JOIN usuarios com ON c.usuario_id = com.id
WHERE publicacion_id = 4;


-- Encontrar los amigos de un usuario 
-- Consulta 4--
SELECT 'tus amigos son', u.nombre 'nombre_amigo', u.apellido
FROM Usuarios u
INNER JOIN Amistades a ON (u.id = a.usuario_id OR u.id = a.amigo_id)
WHERE u.id <> 1
AND a.estado = 'aceptada'
AND (a.usuario_id = 1 OR a.amigo_id = 1);

-- Contar la cantidad de amigos de un usuario 
-- Consulta 5--

SELECT COUNT(*) AS cantidad_amigos
FROM Amistades a
WHERE (a.usuario_id = 1 OR a.amigo_id = 1)
AND a.estado = 'aceptada';



-- Mostrar las publicaciones de los amigos de un usuario 
-- Consulta 6   (duda) -

SELECT distinct u.nombre 'Nombre del amigo', u.apellido,  p.*
FROM Publicaciones p
INNER JOIN Usuarios u ON u.id = p.usuario_id
INNER JOIN Amistades a ON p.usuario_id = a.amigo_id
WHERE a.usuario_id = 1
AND a.estado = 'aceptada';



-- Listar los usuarios que han comentado una publicación 
-- CONSULTA 7 ---
SELECT distinct Publicaciones.contenido 'PUBLICACION', Usuarios.nombre, Usuarios.apellido, Publicaciones.fecha, Comentarios.contenido 'COMENTARIO'
FROM Usuarios 
JOIN Comentarios ON Usuarios.id = Comentarios.usuario_id 
JOIN Publicaciones ON Comentarios.publicacion_id = Publicaciones.id
WHERE publicacion_id=1 ;

-- Buscar amigos que aún no han aceptado la solicitud de amistad 
-- consulta 8  (duda) --- 
SELECT distinct u.id, u.nombre, u.apellido FROM usuarios u
INNER JOIN Amistades a ON u.id = a.usuario_id OR u.id = a.amigo_id
WHERE a.estado = 'pendiente';

-- Mostrar las publicaciones más recientes ordenadas por fecha  
-- --Consulta 9--
SELECT u.nombre 'Usuario', p.contenido 'Publicacion', p.fecha FROM Publicaciones p 
INNER JOIN Usuarios u ON u.id = p.usuario_id
ORDER BY fecha DESC;


-- Mostrar la actividad reciente (publicaciones y comentarios) de un usuario. 
-- consulta 10 
SELECT p.usuario_id, p.fecha, p.contenido, 'publicacion' AS tipo
FROM Publicaciones p
WHERE p.usuario_id = 1
UNION 
SELECT c.usuario_id, c.fecha, c.contenido, 'comentario' AS tipo
FROM Comentarios c
WHERE c.usuario_id = 1
ORDER BY fecha DESC;

-- Encontrar las publicaciones de amigos en un rango de fechas 
-- CONSULTA 11
SELECT u.nombre 'Nombre del amigo', u.apellido,  p.*
FROM Publicaciones p
INNER JOIN Usuarios u ON u.id = p.usuario_id
INNER JOIN Amistades a ON p.usuario_id = a.amigo_id
WHERE a.usuario_id = 1
AND a.estado = 'aceptada'
AND fecha BETWEEN '2021-01-01' AND '2023-12-09';


-- Obtener los usuarios que han enviado mensajes a otro usuario 
-- CONSULTA 12 (duda)

SELECT DISTINCT m.emisor_id ,u1.nombre, u1.apellido, m.fecha,  receptor_id
FROM Usuarios u1
JOIN Mensajes m ON u1.id = m.emisor_id;


-- Mostrar los mensajes entre dos usuarios 
-- CONSULTA 13 
SELECT *
FROM Mensajes
WHERE (emisor_id = 4 AND receptor_id = 2)
   OR (emisor_id = 2 AND receptor_id = 4)
ORDER BY id;


--  Encontrar usuarios que no tienen amigos 
-- CONSULTA 14

SELECT 'sin amigos',  nombre, apellido
FROM Usuarios
WHERE id NOT IN (
    SELECT usuario_id FROM Amistades WHERE estado = 'aceptada'
    UNION
    SELECT usuario_id FROM Amistades WHERE estado = 'aceptada'
);


-- Mostrar los usuarios que han comentado sus propias publicaciones 
-- CONSULTA 15 (duda)

SELECT DISTINCT U.id, U.nombre, U.apellido, P.contenido
FROM Usuarios U
JOIN Comentarios C ON U.id = C.usuario_id
JOIN Publicaciones P ON C.publicacion_id = P.id
WHERE C.usuario_id = P.usuario_id;

-- Listar las 3 publicaciones más comentadas 
-- CONSULTA 16
SELECT P.id, P.contenido, COUNT(C.id) AS numeroComentarios
FROM Publicaciones P
LEFT JOIN Comentarios C ON P.id = C.publicacion_id
GROUP BY P.id
ORDER BY numeroComentarios DESC
LIMIT 3;




