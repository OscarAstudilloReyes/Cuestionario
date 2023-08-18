<?php

namespace Controlador;
use Modelo\Cuestionario;
session_start();

require_once __DIR__ . '/../Modelo/Cuestionario.php';



class CuestionarioControlador
{
    private $modeloCuestionario;

    public function __construct(Cuestionario $modeloCuestionario)
    {
        $this->modeloCuestionario = $modeloCuestionario;
    }


    public function procesarAccion($datos)
    {
        switch ($datos['accion']) {
            case 'mostrarPreguntas':
                return $this->mostrarPreguntas($datos['idCuestionario']);
                break;

            case 'mostrarCuestionarios':
                return $this->mostrarCuestionarios();
                break;
            default:
                
                break;
        }
    }

    public function mostrarPreguntas($idCuestionario)
    {
        return  $this->modeloCuestionario->obtenerPreguntas($idCuestionario);
    }

    public function mostrarCuestionarios()
    {
        return   [
            'datos' => $this->modeloCuestionario->obtenerCuestionarios()['datos'],
            'usuario' => $_SESSION['usuario']['nombre']
        ];
    }
}

$cuestionarioControlador = new \Controlador\CuestionarioControlador(new \Modelo\Cuestionario());
$json = $cuestionarioControlador->procesarAccion($_POST);
echo json_encode($json); 