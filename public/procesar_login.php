<?php

require_once __DIR__ . '/../src/Configuracion/bd/Conexion.php';
require_once __DIR__ . '/../src/Modelo/Usuario.php';
require_once __DIR__ . '/../src/Controlador/LoginControlador.php';



$loginControlador = new \Controlador\LoginControlador(new \Modelo\Usuario());

$usuario = $_POST['txtUsuario'];
$contrasenia = $_POST['txtContrasenia'];

$res = $loginControlador->iniciarSesion($usuario, $contrasenia);

if ($res['exito'] == 1) {
    header('Location: ../src/Vista/inicio.html');
} else {
    echo '<script>alert("Credenciales incorrectas");</script>';
    echo '<script>window.location.href = "index.html";</script>';

}

