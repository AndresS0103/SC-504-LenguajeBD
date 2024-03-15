<?php
include 'conexion.php';
include 'modelo.php';


$datos = obtenerDatos();


echo json_encode($datos);
?>