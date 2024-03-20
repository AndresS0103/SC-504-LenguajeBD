<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Empleados</title>
</head>
<body>
    <h1>Lista de empleados</h1>
    <table id="tabla-empleados" border="1">
        <thead>
            <tr>
                <th>Employee ID</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Phone Number</th>
                <th>Hire Date</th>
                <th>Job ID</th>
                <th>Salary</th>
                <th>Commission Pct</th>
                <th>Manager ID</th>
                <th>Department ID</th>
            </tr>
        </thead>
        <tbody id="cuerpo-tabla"></tbody>
    </table>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <!-- Importa el script.js -->
    <script src="assets/js/datos.js"></script>
</body>
</html>