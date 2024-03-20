<?php

$usuario = 'hr';
$contrasena = 'Hola123456789';
$servidor = '//localhost:1521/orcl';
$conexion = oci_connect($usuario, $contrasena, $servidor);


if (!$conexion) {
    $error = oci_error();
    trigger_error(htmlentities($error['message'], ENT_QUOTES), E_USER_ERROR);
}
?>