<?php

namespace Modelo;
use Configuracion\bd\Conexion;
require_once __DIR__ . '/../Configuracion/bd/Conexion.php';

class Cuestionario
{
    private $db;

    public function __construct()
    {
        $this->db = Conexion::getInstance()->getConnection();
    }

    public function obtenerPreguntas($idCuestionario)
    {
        $retorno = ['exito' => 1, 'datos' => [], 'mensaje' => ''];
        try {
            $sql = "
                SELECT 
                    preguntas.id_cuestionarios,
                    preguntas.id_preguntas,
                    preguntas.contenido,
                    preguntas.tipo_pregunta,
                    opciones.id_opciones,
                    opciones.contenido as opcion
                FROM preguntas 
                LEFT JOIN opciones ON preguntas.id_preguntas = opciones.id_preguntas
                WHERE preguntas.id_cuestionarios = {$idCuestionario}
            ORDER BY preguntas.id_preguntas, opciones.id_opciones";
      
            $rw = $this->db->query($sql);
            $retorno['exito'] = 1;
            $retorno['datos'] = $rw->fetchAll(\PDO::FETCH_ASSOC);
            $retorno['mensaje'] = 'Preguntas obtenidas';
            
        } catch (Exception $ex) {
            $retorno['mensaje'] = $ex->getMessage();
            $retorno['exito'] = 0;
        }
        return $retorno;
    }

    public function obtenerCuestionarios()
    {
        $retorno = ['exito' => 1, 'datos' => [], 'mensaje' => ''];
        try {
            $sql = "
                SELECT * FROM cuestionarios ";
      
            $rw = $this->db->query($sql);
            $retorno['exito'] = 1;
            $retorno['datos'] = $rw->fetchAll(\PDO::FETCH_ASSOC);
            $retorno['mensaje'] = 'Cuestionarios obtenido';
            
        } catch (Exception $ex) {
            $retorno['mensaje'] = $ex->getMessage();
            $retorno['exito'] = 0;
        }
        return $retorno;
    }

}