<?php

namespace Controlador;
use Modelo\HistorialCuestionario;
session_start();

require_once __DIR__ . '/../Modelo/HistorialCuestionario.php';



class HistorialCuestionarioControlador
{
    private $modeloHistorialCuestionarioControlador;

    public function __construct(HistorialCuestionario $modeloHistorialCuestionarioControlador)
    {
        $this->modeloHistorialCuestionarioControlador = $modeloHistorialCuestionarioControlador;
    }


    public function procesarAccion($datos)
    {
        switch ($datos['accion']) {
            case 'adicionar':
                return $this->adicionar($datos);
         
            case 'mostrar':
                return $this->mostrar();
            default:
                
                break;
        }
    }

    public function adicionar($datos)
    {
        $puntaje  =   $this->modeloHistorialCuestionarioControlador->calcularPuntaje($datos)['datos']['puntaje'];
        $respuestas = json_decode($datos['respuestas'], true);
        $idCuestionario = $respuestas[0]['idCuestionario'];
        $idUsuario = $_SESSION['usuario']['id_usuario'];

        $this->modeloHistorialCuestionarioControlador->adicionar(
            [
                'idUsuario' => $idUsuario,
                'puntaje' => $puntaje,
                'idCuestionario' => $idCuestionario
            ]
        );
        //devuelve las respuestas correctas y el puntaje
       return [
        'repuestasCorrectas' =>  $this->modeloHistorialCuestionarioControlador->obtenerPreguntasConRespuestasCorrectas($idCuestionario)['datos'],
        'puntaje' =>$puntaje
       ];
    }

    public function mostrar(){
        return $this->modeloHistorialCuestionarioControlador->consultarPorUsuario($_SESSION['usuario']['id_usuario']);
    }
}

$historialCuestionarioControlador = new \Controlador\HistorialCuestionarioControlador(new \Modelo\HistorialCuestionario());
$json = $historialCuestionarioControlador->procesarAccion($_POST);
echo json_encode($json); 