<?php

include 'conexion.php';


function obtenerDatos() {
    global $conexion;
    
   
    $query = 'SELECT * FROM EMPLOYEES';
    

    $statement = oci_parse($conexion, $query);
    if (!$statement) {
        $error = oci_error($conexion);
        trigger_error(htmlentities($error['message'], ENT_QUOTES), E_USER_ERROR);
    }
    

    $resultado = oci_execute($statement);
    if (!$resultado) {
        $error = oci_error($statement);
        trigger_error(htmlentities($error['message'], ENT_QUOTES), E_USER_ERROR);
    }
    
    $datos = array();
    
    while ($fila = oci_fetch_assoc($statement)) {
        $datos[] = $fila;
    }
    
    oci_free_statement($statement);
    
    return $datos;
}
?>