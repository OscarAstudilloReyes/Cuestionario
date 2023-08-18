<?php

namespace Controlador;
use Modelo\Usuario;
session_start();
require_once __DIR__ . '/../Modelo/Usuario.php';



class LoginControlador
{
    private $modeloUsuario;

    public function __construct(Usuario $modeloUsuario)
    {
        $this->modeloUsuario = $modeloUsuario;
    }

    public function iniciarSesion($usuario, $contrasenia)
    {
        $resultado = $this->modeloUsuario->consultarPorUsuario(['usuario' => $usuario, 'contrasenia' => $contrasenia]);

        if ($resultado['exito'] == 1 && count($resultado['datos']) > 0) {
            $_SESSION['usuario'] = $resultado['datos']; 
            return ['exito' => 1, 'mensaje' => 'Inicio de sesión exitoso'];
        } else {
            return ['exito' => 0, 'mensaje' => 'Usuario o contraseña incorrectos'];
        }
    }
}
