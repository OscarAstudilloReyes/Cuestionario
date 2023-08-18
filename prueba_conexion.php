<?php

require_once '../src/Configuracion/bd/Conexion.php';  



try {
    $db = new Conexion();
    $connection = $db->getConnection();
    echo "¡Conexión okkk!";


    // $x =  password_verify('123', '1231');
    // var_dump($x); exit();

} catch (PDOException $ex) {
    echo "Error de conexión: " . $ex->getMessage();
}
