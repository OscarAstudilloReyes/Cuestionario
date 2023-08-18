<?php

namespace Controlador;
class CierreSesionControlador
{
    public function cierreSession()
    {
         
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        session_destroy();
        return [
            'mensaje' => 'Sessiones cerradas',
            'datos' => [
                'rutaLogin' => '../../index.html'
            ],
            'exito' => 1
        ];
    }
}

$cierreSesionControlador = new CierreSesionControlador();
echo json_encode($cierreSesionControlador->cierreSession());
