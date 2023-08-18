<?php

namespace Modelo;
use Configuracion\bd\Conexion;
require_once __DIR__ . '/../Configuracion/bd/Conexion.php';

class HistorialCuestionario
{
    private $db;

    public function __construct()
    {
        $this->db = Conexion::getInstance()->getConnection();
    }

    public function adicionar($parametros)
    {
        $retorno = ['exito' => 1, 'datos' => [], 'mensaje' => ''];
        try {
           // Preparar la consulta SQL
        $sql = "INSERT INTO historial_cuestionarios (id_usuario, id_cuestionarios, puntaje, fecha_creacion, fecha_modificacion, id_usuario_creacion,id_usuario_modificacion) 
        VALUES (:id_usuario, :id_cuestionario, :puntaje, NOW(), NOW(), :id_usuario,:id_usuario)";

        $stmt = $this->db->prepare($sql);

        $stmt->bindParam(':id_usuario', $parametros['idUsuario']);
        $stmt->bindParam(':id_cuestionario', $parametros['idCuestionario']);
        $stmt->bindParam(':puntaje', $parametros['puntaje']);
        $stmt->bindParam(':id_usuario_creacion', $parametros['idUsuario']);
        $stmt->bindParam(':id_usuario_modificacion', $parametros['idUsuario']);
        $stmt->execute();
        $retorno['mensaje'] = 'Datos adicionados exitosamente';
            
        } catch (Exception $ex) {
            $retorno['mensaje'] = $ex->getMessage();
            $retorno['exito'] = 0;
        }
        return $retorno;
    }

    public function calcularPuntaje($parametros)  {

        $retorno = ['exito' => 1, 'datos' => [], 'mensaje' => 'Puntaje obtenido correctamente'];
        $respuestas = json_decode($parametros['respuestas'], true);
        $puntaje = 0;

    try {
        foreach ($respuestas as $respuesta) {
            $idOpcion = $respuesta['idOpcion'];
            // Consulta la base de datos para verificar si la opción seleccionada es correcta
            $sql = "SELECT es_correcta FROM opciones WHERE id_opciones = :idOpcion";
            $stmt = $this->db->prepare($sql);
            $stmt->bindParam(':idOpcion', $idOpcion);
            $stmt->execute();
            
            $opcion = $stmt->fetch(\PDO::FETCH_ASSOC);
            //Calcular el puntaje
            if ($opcion['es_correcta'] == 1 && $respuesta['seleccionado'] == true) {
                $puntaje++;
            }
        }
        $retorno['datos'] = ['puntaje' => $puntaje];

    }  catch (Exception $ex) {
        $retorno['mensaje'] = $ex->getMessage();
        $retorno['exito'] = 0;
    }
    return $retorno;

    
    }


    function obtenerPreguntasConRespuestasCorrectas($idCuestionario) {

        $preguntasConRespuestas = [];
        $retorno = ['exito' => 1, 'datos' => [], 'mensaje' => 'Preguntas con respuestas correctas'];

        try {

        // Obtener las preguntas del cuestionario
        $sqlPreguntas = "SELECT p.id_preguntas, p.contenido, c.titulo FROM preguntas  as p 
        INNER JOIN cuestionarios as c on c.id_cuestionarios = p.id_cuestionarios 
        WHERE p.id_cuestionarios =  :id_cuestionarios";
        $stmtPreguntas = $this->db->prepare($sqlPreguntas);
        $stmtPreguntas->bindParam(':id_cuestionarios', $idCuestionario);
        $stmtPreguntas->execute();
    
        $preguntas = $stmtPreguntas->fetchAll(\PDO::FETCH_ASSOC);
    
        foreach ($preguntas as $pregunta) {
            // Obtener las opciones correctas para cada pregunta
            $sqlOpciones = "SELECT id_opciones, contenido FROM opciones WHERE id_preguntas = :idPregunta AND es_correcta = 1";
            $stmtOpciones = $this->db->prepare($sqlOpciones);
            $stmtOpciones->bindParam(':idPregunta', $pregunta['id_preguntas']);
            $stmtOpciones->execute();
    
            $opciones = $stmtOpciones->fetchAll(\PDO::FETCH_ASSOC);
    
            $preguntasConRespuestas[] = [
                'tituloCuestionario' => $pregunta['titulo'],
                'pregunta' => $pregunta['contenido'],
                'respuestas_correctas' => $opciones
            ];
        }
        $retorno['datos'] = $preguntasConRespuestas;

        }catch (Exception $ex) {
        $retorno['mensaje'] = $ex->getMessage();
        $retorno['exito'] = 0;
    }
    return $retorno;

    }

    public function consultarPorUsuario($idUsuario)
    {
        $retorno = ['exito' => 1, 'datos' => [], 'mensaje' => ''];
        try {
            $sql = "SELECT hc.puntaje, c.titulo, u.nombre, hc.fecha_creacion 
            FROM historial_cuestionarios  as hc
            inner join cuestionarios as c on c.id_cuestionarios = hc.id_cuestionarios
            inner join usuario as u on u.id_usuario = hc.id_usuario
            WHERE hc.id_usuario = :id  order by hc.fecha_creacion desc";

            $stmt = $this->db->prepare($sql);
            $stmt->bindParam(':id', $idUsuario);
            $stmt->execute();
    
            $historialCuestionario = $stmt->fetchAll(\PDO::FETCH_ASSOC);
            $retorno['datos'] = $historialCuestionario;
            
        } catch (Exception $ex) {
            $retorno['mensaje'] = $ex->getMessage();
            $retorno['exito'] = 0;
        }
        return $retorno;
    }
    

}