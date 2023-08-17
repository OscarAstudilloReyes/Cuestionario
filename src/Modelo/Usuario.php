<?php

namespace Modelo;
use Configuracion\bd\Conexion;
require_once __DIR__ . '/../Configuracion/bd/Conexion.php';

class Usuario
{
    private $db;

    public function __construct()
    {
        $this->db = Conexion::getInstance()->getConnection();
    }

    public function consultarPorUsuario($parametros)
    {
        $retorno = ['exito' => 1, 'datos' => [], 'mensaje' => ''];
        try {
            $sql = "SELECT * FROM usuario WHERE usuario = :usuario";

            $stmt = $this->db->prepare($sql);
            $stmt->bindParam(':usuario', $parametros['usuario']);
            $stmt->execute();
    
            $usuario = $stmt->fetch();


             if ($usuario && md5($parametros['contrasenia']) ===  $usuario['contrasenia']) {
                unset($usuario['contrasenia']); 
                $retorno['datos'] = $usuario;
            } else {
                $retorno['exito'] = 0;
                $retorno['mensaje'] = 'Usuario o contraseña incorrectos';
            }

        } catch (Exception $ex) {
            $retorno['mensaje'] = $ex->getMessage();
            $retorno['exito'] = 0;
        }
        return $retorno;
    }

}