<?php

namespace Configuracion\bd;

require_once('configuracion.php');

class Conexion
{
    private static $instance;
    private $connection;

    public function __construct()
    {
        $dsn = 'mysql:host=' . DB_HOSTNAME . ';dbname=' . DB_NAME;
        $this->connection = new \PDO($dsn, DB_USER, DB_PASSWORD);
        
    }

    public static function getInstance()
    {
        if (!self::$instance) {
            self::$instance = new self();
        }

        return self::$instance;
    }

    public function getConnection()
    {
        return $this->connection;
    }
}
