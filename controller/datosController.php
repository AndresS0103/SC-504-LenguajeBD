<?php
include '../config/Conexion.php';
include '../models/Datos.php';


$datos = obtenerDatos();


echo json_encode($datos);
?>

