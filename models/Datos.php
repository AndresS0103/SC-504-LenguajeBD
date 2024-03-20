<?php

include '../config/Conexion.php';

function obtenerDatos() {
    global $conexion;
    
    $query = 'SELECT * FROM EMPLOYEES';
    
    $statement = oci_parse($conexion, $query);
    oci_execute($statement);
    
    $datos = array();
    
    while ($fila = oci_fetch_assoc($statement)) {
        $datos[] = $fila;
    }
    
    oci_free_statement($statement);
    
    return $datos;
}
?>
